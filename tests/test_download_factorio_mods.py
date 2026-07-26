#!/usr/bin/env python3
"""Unit tests for the headless Mod Portal downloader."""

from __future__ import annotations

import importlib.util
from pathlib import Path
import unittest


MODULE_PATH = Path(__file__).resolve().parents[1] / "scripts" / "download-factorio-mods.py"
SPEC = importlib.util.spec_from_file_location("download_factorio_mods", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
DOWNLOADER = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(DOWNLOADER)


class DependencyNamesTest(unittest.TestCase):
    def test_recommended_dependencies_are_included_by_default(self) -> None:
        release = {
            "info_json": {
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
        }

        self.assertEqual(
            DOWNLOADER.dependency_names(release, include_optional=False),
            ["advanced-energy-grid", "load-order-independent-required", "hard-required"],
        )
        self.assertEqual(
            DOWNLOADER.dependency_names(release, include_optional=True),
            [
                "advanced-energy-grid",
                "optional-integration",
                "hidden-integration",
                "load-order-independent-required",
                "hard-required",
            ],
        )


if __name__ == "__main__":
    unittest.main()
