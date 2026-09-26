#!/usr/bin/env python3
"""Keeps the CI load-test matrix and scripts/ci-load-test.sh in step."""

from __future__ import annotations

from pathlib import Path
import re
import unittest

import yaml


ROOT = Path(__file__).resolve().parents[1]


class LoadTestMatrixTest(unittest.TestCase):
    def test_every_matrix_entry_is_a_script_case_and_vice_versa(self) -> None:
        # The matrix has to be written into the workflow, so nothing else stops a
        # new test being added to the script and never run, or a matrix entry
        # naming a case the script does not have and failing on its usage line.
        workflow = yaml.safe_load((ROOT / ".gitea" / "workflows" / "ci.yml").read_text(encoding="utf-8"))
        matrix = workflow["jobs"]["load"]["strategy"]["matrix"]["test"]
        script = (ROOT / "scripts" / "ci-load-test.sh").read_text(encoding="utf-8")
        cases = re.findall(r"^  ([a-z][a-z-]*)\)", script, re.MULTILINE)
        self.assertEqual(sorted(matrix), sorted(cases))

    def test_the_gate_keeps_the_required_check_name(self) -> None:
        workflow = yaml.safe_load((ROOT / ".gitea" / "workflows" / "ci.yml").read_text(encoding="utf-8"))
        gate = workflow["jobs"]["gate"]
        self.assertEqual(gate["name"], "Gate: Validate Factorio mod")
        self.assertEqual(set(gate["needs"]), {"static", "load"})


if __name__ == "__main__":
    unittest.main()
