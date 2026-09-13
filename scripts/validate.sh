#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

python3 - <<'PY'
import json
import re
from pathlib import Path

info = json.load(open("src/info.json", encoding="utf-8"))
version = info["version"]

for path in sorted(Path("tests/fixtures").rglob("info.json")):
    json.loads(path.read_text(encoding="utf-8"))

if not re.fullmatch(r"\d+\.\d+\.\d+", version):
    raise SystemExit(f"src/info.json version must be MAJOR.MINOR.PATCH: {version}")

changelog = Path("src/changelog.txt").read_text(encoding="utf-8")
match = re.search(r"(?m)^Version:\s*(\d+\.\d+\.\d+)\s*$", changelog)
if not match:
    raise SystemExit("src/changelog.txt must contain a Factorio changelog Version entry")
if match.group(1) != version:
    raise SystemExit(
        f"src/changelog.txt top version {match.group(1)} does not match src/info.json {version}"
    )

try:
    import yaml
except ImportError:
    pass
else:
    for path in sorted(Path(".governance").rglob("*.yaml")):
        yaml.safe_load(path.read_text(encoding="utf-8"))
PY

python3 -m unittest discover --start-directory tests --pattern 'test_*.py'

while IFS= read -r file; do
  luac -p "$file"
done < <(rg --files -g '*.lua' src tests/fixtures)

# CI runs the Factorio load tests as their own named steps and sets this to
# keep this script to the static checks. Locally it still does everything.
if [[ "${AFI_SKIP_FACTORIO:-0}" != "1" ]]; then
  ./scripts/factorio-validate.sh
fi
