#!/usr/bin/env python3
"""Unit tests for the headless Mod Portal downloader."""

from __future__ import annotations

import importlib.util
from pathlib import Path
import json
import tempfile
import unittest
import zipfile
from unittest.mock import patch


MODULE_PATH = Path(__file__).resolve().parents[1] / "scripts" / "download-factorio-mods.py"
SPEC = importlib.util.spec_from_file_location("download_factorio_mods", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
DOWNLOADER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(DOWNLOADER)


class DependencyNamesTest(unittest.TestCase):
    def test_recommended_dependencies_are_included_by_default(self) -> None:
        info_json = {
            "dependencies": [
                "base >= 2.1.0",
                "+ advanced-energy-grid",
                "? optional-integration",
                "(?) hidden-integration",
                "~ load-order-independent-required",
                "hard-required",
                "! incompatible-mod",
            ]
        }

        self.assertEqual(
            DOWNLOADER.dependency_names(info_json, include_optional=False),
            ["advanced-energy-grid", "load-order-independent-required", "hard-required"],
        )
        self.assertEqual(
            DOWNLOADER.dependency_names(info_json, include_optional=True),
            [
                "advanced-energy-grid",
                "optional-integration",
                "hidden-integration",
                "load-order-independent-required",
                "hard-required",
            ],
        )

    def test_local_metadata_includes_optional_dependencies_without_recursing(self) -> None:
        # Only what `local-mod` declares directly should be downloaded.
        # include_dependencies must be False here: a downloaded dependency's
        # own optional/recommended/hidden-optional dependencies must not be
        # pulled in, since that graph can reach arbitrarily far across the
        # Mod Portal (e.g. a hidden-optional compatibility shim several hops
        # away with no Factorio-version-compatible release).
        with patch.object(DOWNLOADER, "download_mod_closure") as download_mod:
            DOWNLOADER.download_info_dependency_closure(
                {
                    "name": "local-mod",
                    "dependencies": ["? optional-mod", "+ recommended-mod", "base"],
                },
                factorio_version="2.1",
                mods_dir=Path("/tmp/mods"),
                username="user",
                token="token",
            )

        self.assertEqual([call.args[0] for call in download_mod.call_args_list], ["optional-mod", "recommended-mod"])
        for call in download_mod.call_args_list:
            self.assertFalse(call.kwargs["include_dependencies"])
            self.assertTrue(call.kwargs["include_optional_dependencies"])
            self.assertEqual(call.kwargs["visited"], {"local-mod"})


class ArchiveMetadataTest(unittest.TestCase):
    """A mod archive may bundle another mod inside it, which is legal and does
    happen: RampantFixed ships RampantFixedRemote alongside its own info.json.
    Only the top-level info.json describes the mod being downloaded."""

    @staticmethod
    def _archive(directory: Path, name: str, entries: dict) -> Path:
        archive_path = directory / f"{name}.zip"
        with zipfile.ZipFile(archive_path, "w") as archive:
            for entry_name, payload in entries.items():
                archive.writestr(entry_name, json.dumps(payload))
        return archive_path

    def test_bundled_mod_metadata_is_ignored(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            archive_path = self._archive(
                Path(directory),
                "OuterMod_1.0.0",
                {
                    "OuterMod_1.0.0/info.json": {"name": "OuterMod", "version": "1.0.0"},
                    "OuterMod_1.0.0/BundledMod/info.json": {"name": "BundledMod", "version": "0.1.0"},
                },
            )
            self.assertEqual(DOWNLOADER.archive_metadata(archive_path)["name"], "OuterMod")

    def test_archive_without_top_level_metadata_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            archive_path = self._archive(
                Path(directory),
                "NoMetadata_1.0.0",
                {"NoMetadata_1.0.0/BundledMod/info.json": {"name": "BundledMod", "version": "0.1.0"}},
            )
            with self.assertRaises(DOWNLOADER.DownloadError):
                DOWNLOADER.archive_metadata(archive_path)



def _release(version: str, released_at: str, base: str | None = None) -> dict:
    dependencies = ["? something-optional"]
    if base is not None:
        dependencies.insert(0, base)
    return {
        "version": version,
        "released_at": released_at,
        "info_json": {"factorio_version": "2.1", "dependencies": dependencies},
    }


class BaseRequirementTest(unittest.TestCase):
    def test_operators_are_parsed(self) -> None:
        for declaration, expected in [
            ("base >= 2.1.13", (">=", "2.1.13")),
            ("base > 2.1.13", (">", "2.1.13")),
            ("base <= 2.1.13", ("<=", "2.1.13")),
            ("base = 2.1.13", ("=", "2.1.13")),
            ("base>=2.1.13", (">=", "2.1.13")),
        ]:
            with self.subTest(declaration=declaration):
                self.assertEqual(
                    DOWNLOADER.base_requirement({"dependencies": [declaration]}), expected
                )

    def test_absent_or_unconstrained_base_is_none(self) -> None:
        self.assertIsNone(DOWNLOADER.base_requirement({"dependencies": ["? other"]}))
        self.assertIsNone(DOWNLOADER.base_requirement({"dependencies": ["base"]}))

    def test_a_mod_named_like_base_is_not_mistaken_for_it(self) -> None:
        self.assertIsNone(
            DOWNLOADER.base_requirement({"dependencies": ["base-extension >= 2.1.13"]})
        )

    def test_release_without_a_base_requirement_loads_anywhere(self) -> None:
        self.assertTrue(DOWNLOADER.release_loads_on(_release("1.0.0", "2026-01-01"), "2.0.0"))


class LatestCompatibleReleaseTest(unittest.TestCase):
    RELEASES = {
        "releases": [
            _release("2.03.00", "2026-01-01", "base >= 2.1.0"),
            _release("2.03.07", "2026-03-01", "base >= 2.1.13"),
            _release("2.03.04", "2026-02-01", "base >= 2.1.9"),
        ]
    }

    def _resolve(self, running: str | None) -> dict:
        with patch.object(DOWNLOADER, "request_json", return_value=self.RELEASES), patch.object(
            DOWNLOADER, "running_factorio_version", return_value=running
        ):
            return DOWNLOADER.latest_compatible_release("RampantFixed", "2.1")

    def test_newest_is_chosen_when_the_running_factorio_satisfies_it(self) -> None:
        self.assertEqual(self._resolve("2.1.17")["version"], "2.03.07")

    def test_newest_loadable_is_chosen_when_the_newest_needs_a_newer_base(self) -> None:
        # The case that broke CI: 2.03.07 is the newest 2.1-series release but
        # needs base >= 2.1.13, which the image at 2.1.9 does not satisfy.
        self.assertEqual(self._resolve("2.1.9")["version"], "2.03.04")

    def test_selection_is_by_release_date_not_version_string(self) -> None:
        self.assertEqual(self._resolve("2.1.0")["version"], "2.03.00")

    def test_unknown_factorio_version_falls_back_to_the_newest(self) -> None:
        self.assertEqual(self._resolve(None)["version"], "2.03.07")

    def test_no_loadable_release_is_an_error_naming_the_requirement(self) -> None:
        with self.assertRaises(DOWNLOADER.DownloadError) as raised:
            self._resolve("2.0.0")
        message = str(raised.exception)
        self.assertIn("RampantFixed", message)
        self.assertIn("2.03.07", message)
        self.assertIn("2.1.13", message)


class RunningFactorioVersionTest(unittest.TestCase):
    def test_environment_variable_is_preferred(self) -> None:
        with patch.dict(DOWNLOADER.os.environ, {"FACTORIO_VERSION": "2.1.17"}, clear=False):
            self.assertEqual(DOWNLOADER.running_factorio_version(), "2.1.17")

    def test_version_is_read_from_the_binary_when_unset(self) -> None:
        completed = DOWNLOADER.subprocess.CompletedProcess(
            args=[], returncode=0, stdout="Version: 2.1.9 (build 86829, linux64, headless)\n"
        )
        env = {k: v for k, v in DOWNLOADER.os.environ.items() if k != "FACTORIO_VERSION"}
        env["FACTORIO_BIN"] = "/opt/factorio/bin/x64/factorio"
        with patch.dict(DOWNLOADER.os.environ, env, clear=True), patch.object(
            DOWNLOADER.os, "access", return_value=True
        ), patch.object(DOWNLOADER.subprocess, "run", return_value=completed):
            self.assertEqual(DOWNLOADER.running_factorio_version(), "2.1.9")

    def test_missing_binary_yields_none(self) -> None:
        env = {
            k: v
            for k, v in DOWNLOADER.os.environ.items()
            if k not in ("FACTORIO_VERSION", "FACTORIO_BIN")
        }
        with patch.dict(DOWNLOADER.os.environ, env, clear=True), patch.object(
            DOWNLOADER.shutil, "which", return_value=None
        ):
            self.assertIsNone(DOWNLOADER.running_factorio_version())

if __name__ == "__main__":
    unittest.main()
