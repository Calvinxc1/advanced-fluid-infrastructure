# Advanced Fluid Infrastructure

Advanced Fluid Infrastructure is a Factorio 2.0 + Space Age mod that makes pipes, pumps, and fluid routing part of factory progression.

Vanilla pipes are powerful very early. This mod adds a staged fluid infrastructure path so early builds stay compact, larger fluid blocks require upgrades, and long-range/high-throughput networks become a deliberate investment instead of the default.

## Requirements

- Factorio 2.0.
- Space Age.
- Optional compatibility cleanup for Rampant Arsenal Fork when it is installed.

## Features

- Upgraded pipes and pipe-to-ground tiers with increasing pipeline extent and underground reach.
- Matching pumps and offshore pumps with tiered pumping speed.
- Fluid infrastructure technologies that gate each major upgrade.
- Space Age branches for regular surfaces, space platforms, Vulcanus, and late-game foundation infrastructure.
- Production-machine fluidbox extent patches so upgraded infrastructure behaves consistently around machines.
- Optional cleanup for Rampant Arsenal reinforced pipes when that mod is present.

## Progression Shape

The mod starts with constrained iron pipe networks, then expands through steel, rubber-lined, reinforced, and foundation infrastructure. Specialized environments have their own entry points:

- Space platforms use low-pressure steel fluid infrastructure.
- Vulcanus starts with heat-resistant infrastructure and advances into tungsten.
- Foundation infrastructure converges the branches into the final long-range backbone tier.
- High-pressure foundation pumps add postgame compression without adding a separate pipe tier.

Current tier behavior is documented in [docs/fluid-infrastructure-benchmark.md](docs/fluid-infrastructure-benchmark.md).

## Installation

Install the released mod through the Factorio mod portal when available. Release packages are also attached to repository releases as `{mod-name}_{version}.zip`.

For local development, keep the repository layout intact and run validation from the repository root:

```sh
./scripts/validate.sh
```

Semantic versioning policy is documented in [docs/semantic-versioning.md](docs/semantic-versioning.md).

Release packaging and automated deployment are documented in [docs/release-process.md](docs/release-process.md).

Contribution guidelines are documented in [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Advanced Fluid Infrastructure is released under the [MIT License](LICENSE).

## AI Disclosure

This mod is developed with substantial AI assistance. AI tools have contributed to code implementation, documentation, validation workflow setup, release automation, and generated artwork, including the thumbnail.

AI-assisted work in this repository is governed through the policy files under `.governance/`. Those policies are intended to keep AI contributions reviewable, scoped to the task at hand, and aligned with the repository's validation and release process.
