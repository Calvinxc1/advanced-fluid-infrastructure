# Advanced Fluid Infrastructure

Advanced Fluid Infrastructure is a Factorio 2.1 + Space Age mod that makes pipes, pumps, and fluid routing part of factory progression.

Vanilla pipes are powerful very early. This mod adds a staged fluid infrastructure path so early builds stay compact, larger fluid blocks require upgrades, and long-range/high-throughput networks become a deliberate investment instead of the default.

## Requirements

- Factorio 2.1.
- Space Age.
- Optional compatibility cleanup for Rampant Arsenal Fork when it is installed.

## Features

- Upgraded pipes and pipe-to-ground tiers with increasing pipeline extent and underground reach.
- Matching pumps and offshore pumps with tiered pumping speed.
- Fluid infrastructure technologies that gate each major upgrade.
- Space Age branches for regular surfaces, space platforms, Vulcanus, and late-game foundation infrastructure.
- Production-machine fluidbox extent patches so upgraded infrastructure behaves consistently around machines.
- Optional cleanup for Rampant Arsenal reinforced pipes when that mod is present.

## Companion Mods

Advanced Fluid Infrastructure is one of three companion mods designed to be played together: this mod for pipes and pumps; Advanced Energy Grid for poles, substations, and transmission; and Advanced Power Infrastructure for boilers, turbines, reactors, and other generation and storage. Each mod loads and works fine on its own, but the staged progression is designed with all three installed together.

## Progression Shape

The mod starts with constrained iron pipe networks, then expands through steel, rubber-lined, reinforced, and foundation infrastructure. Specialized environments have their own entry points:

- Space platforms use low-pressure steel fluid infrastructure.
- Vulcanus starts with heat-resistant infrastructure and advances into tungsten.
- Foundation infrastructure converges the branches into the final long-range backbone tier.
- High-pressure foundation pumps add postgame compression without adding a separate pipe tier.

Current tier behavior is documented in [docs/fluid-infrastructure-benchmark.md](docs/fluid-infrastructure-benchmark.md).

## For Mod Authors

Tier values are published as a data-stage API, so another mod can retune pipeline extent, underground distance, and pumping speed for any tier — including the vanilla iron tier this mod patches in place — without touching this mod's source or forking it:

```lua
-- your data.lua, with "? advanced-fluid-infrastructure >= 0.3.0" declared
if mods["advanced-fluid-infrastructure"] then
  local afi = require("__advanced-fluid-infrastructure__.api")
  afi.configure_tier("steel", { pipeline_extent = 120 }, "my-mod")
end
```

This is a back-end surface only; it adds no player-facing mod settings. Tier names, defaults, the load-order contract, conflict behavior, and troubleshooting are documented in [docs/modding-api.md](docs/modding-api.md).

## Installation

Install the released mod through the Factorio mod portal when available. Release packages are also attached to repository releases as `{mod-name}_{version}.zip`.

For local development, keep the repository layout intact and run validation from the repository root:

```sh
./scripts/validate.sh
```

### External-mod validation

CI reads `src/info.json`, downloads every declared Mod Portal dependency (required, recommended, optional, and hidden optional), and then headlessly validates the local source against that complete mod list. Configure the repository Actions secrets `FACTORIO_MOD_PORTAL_USERNAME` and `FACTORIO_MOD_PORTAL_TOKEN` with a Factorio account username and service token; neither value is logged or stored in the repository.

The same download can be run locally:

```sh
export FACTORIO_MOD_PORTAL_USERNAME='your-factorio-username'
export FACTORIO_MOD_PORTAL_TOKEN='your-factorio-service-token'
./scripts/download-factorio-mods.py --mods-dir /tmp/factorio-mods --from-info src/info.json
```

`--from-info` automatically follows the full dependency closure, including optional and recommended dependencies, and uses the local mod's declared Factorio version. This makes the workflow portable to another repository without hard-coded mod names. For a direct Mod Portal download, `--with-dependencies` follows required and recommended (`+`) dependencies; add `--include-optional-dependencies` for its full optional closure.

Semantic versioning policy is documented in [docs/semantic-versioning.md](docs/semantic-versioning.md).

Release packaging and automated deployment are documented in [docs/release-process.md](docs/release-process.md).

Contribution guidelines are documented in [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Advanced Fluid Infrastructure is released under the [MIT License](LICENSE).

## AI Disclosure

This mod is developed with substantial AI assistance. AI tools have contributed to code implementation, documentation, validation workflow setup, release automation, and generated artwork, including the thumbnail.

AI-assisted work in this repository is governed through the policy files under `.governance/`. Those policies are intended to keep AI contributions reviewable, scoped to the task at hand, and aligned with the repository's validation and release process.
