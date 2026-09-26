#!/usr/bin/env bash
# Runs one Factorio load test by name. CI runs each as its own job so that one
# failing load shape does not hide the others; locally, run any of them the same
# way, e.g. ./scripts/ci-load-test.sh space-age
#
#   base-game                          Space Age disabled
#   space-age                          Space Age, plus the local Rampant Arsenal
#                                      fixture and its assertions
#   mod-family                         AFI + AEG + API + PowerOverload +
#                                      Rampant Arsenal Fork
#   full-dependencies                  every dependency declared in info.json
#   full-dependencies-with-parameters  full-dependencies plus the configuration
#                                      API fixture, which configures tiers and
#                                      asserts the results
#
# The mod-family and full-dependencies tests download from the Mod Portal and
# need FACTORIO_MOD_PORTAL_USERNAME and FACTORIO_MOD_PORTAL_TOKEN.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."
export AFI_REQUIRE_FACTORIO="${AFI_REQUIRE_FACTORIO:-1}"

mod_name="$(python3 -c 'import json; print(json.load(open("src/info.json", encoding="utf-8"))["name"])')"

require_portal_credentials() {
  if [[ -z "${FACTORIO_MOD_PORTAL_USERNAME:-}" || -z "${FACTORIO_MOD_PORTAL_TOKEN:-}" ]]; then
    echo "FACTORIO_MOD_PORTAL_USERNAME and FACTORIO_MOD_PORTAL_TOKEN must both be set for the $1 test." >&2
    exit 1
  fi
}

# Mods directories are global rather than local: they are removed by an EXIT
# trap, which runs after the function that created them has returned.
new_mods_dir() {
  mktemp -d "${RUNNER_TEMP:-/tmp}/factorio-$1-mods.XXXXXX"
}

base_game() {
  ./scripts/factorio-validate-base-game.sh
}

space_age() {
  # The local Rampant Arsenal fixture needs Space Age, and exercises ingredient
  # shapes the published mod does not have.
  mods_dir="$(new_mods_dir space-age)"
  trap 'rm -rf -- "$mods_dir"' EXIT
  ln -s "$PWD/src" "$mods_dir/$mod_name"
  for fixture in RampantArsenalFork afi-rampant-compatibility-test; do
    ln -s "$PWD/tests/fixtures/$fixture" "$mods_dir/$fixture"
  done
  FACTORIO_MODS_DIR="$mods_dir" ./scripts/factorio-validate.sh
}

full_dependencies() {
  local with_parameters="$1"
  require_portal_credentials full-dependencies
  mods_dir="$(new_mods_dir dependencies)"
  trap 'rm -rf -- "$mods_dir"' EXIT
  ./scripts/download-factorio-mods.py --mods-dir "$mods_dir" --from-info src/info.json
  ln -s "$PWD/src" "$mods_dir/$mod_name"
  if [[ "$with_parameters" == "1" ]]; then
    # Configures tiers through the API and asserts the values reach entities,
    # items, tooltips and production machines, and that every rejection path
    # refuses without writing.
    ln -s "$PWD/tests/fixtures/afi-config-api-test" "$mods_dir/afi-config-api-test"
  fi
  FACTORIO_MODS_DIR="$mods_dir" ./scripts/factorio-validate.sh
}

mod_family() {
  require_portal_credentials mod-family

  temp_base="${RUNNER_TEMP:-/tmp}"
  mkdir -p "$temp_base"
  family_info="$(mktemp "$temp_base/family-info.XXXXXX.json")"
  mods_dir="$(mktemp -d "$temp_base/factorio-family-mods.XXXXXX")"
  trap 'rm -f -- "$family_info"; rm -rf -- "$mods_dir"' EXIT

  python3 - "$family_info" <<'PY'
import json
import re
import sys

own_info = json.load(open("src/info.json", encoding="utf-8"))

# download-factorio-mods.py no longer recurses past a mod's own
# directly-declared dependencies (recursing into hidden-optional
# dependencies-of-dependencies once reached an unrelated, unmaintained
# mod several hops away with no compatible release). So Rampant
# Arsenal Fork has to be listed here explicitly rather than arriving
# transitively. Its constraint is drawn from AFI's own info.json,
# which already declares it, rather than duplicated as a literal.
dependency_pattern = re.compile(
    r"^\s*(?:\(\?\)|\?|\+|!|~)?\s*(?P<name>[A-Za-z0-9_-]+)(?P<constraint>\s*(?:>=|<=|=|>|<)\s*[0-9][0-9.]*)?\s*$"
)
rampant_arsenal_fork = "RampantArsenalFork"
for declaration in own_info["dependencies"]:
    match = dependency_pattern.match(declaration)
    if match and match.group("name") == "RampantArsenalFork":
        constraint = (match.group("constraint") or "").strip()
        rampant_arsenal_fork = f"RampantArsenalFork {constraint}".strip()
        break

# advanced-energy-grid, advanced-power-infrastructure, and
# PowerOverload are not declared anywhere in AFI's own info.json (AFI
# has no code coupling with any of them), so there is no local
# info.json data to draw their names from.
json.dump(
    {
        "name": "advanced-infrastructure-family-validation",
        "version": "0.0.1",
        "factorio_version": own_info["factorio_version"],
        "dependencies": [
            "advanced-energy-grid",
            "advanced-power-infrastructure",
            "PowerOverload",
            rampant_arsenal_fork,
        ],
    },
    open(sys.argv[1], "w", encoding="utf-8"),
)
PY

  ./scripts/download-factorio-mods.py \
    --mods-dir "$mods_dir" \
    --from-info "$family_info"

  # advanced-power-infrastructure declares an optional dependency on this
  # mod, so the download above pulls in a Mod Portal copy of it too.
  # Discard that copy in favor of the local checkout under test so
  # Factorio doesn't see two releases of the same mod.
  rm -f "$mods_dir/${mod_name}"_*.zip

  ln -s "$PWD/src" "$mods_dir/$mod_name"
  ln -s "$PWD/tests/fixtures/afi-rampant-compatibility-test" "$mods_dir/afi-rampant-compatibility-test"
  FACTORIO_MODS_DIR="$mods_dir" ./scripts/factorio-validate.sh
}

case "${1:-}" in
  base-game) base_game ;;
  space-age) space_age ;;
  mod-family) mod_family ;;
  full-dependencies) full_dependencies 0 ;;
  full-dependencies-with-parameters) full_dependencies 1 ;;
  *)
    echo "usage: $0 {base-game|space-age|mod-family|full-dependencies|full-dependencies-with-parameters}" >&2
    exit 2
    ;;
esac
