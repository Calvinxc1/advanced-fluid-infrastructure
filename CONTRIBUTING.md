# Contributing

Contributions are welcome through pull requests against the `dev` branch.

Day-to-day maintainer implementation may happen directly on `dev` for now. Feature branches are not required until the repository maintainer enables feature branching for this repository.

Before opening a pull request, run:

```sh
./scripts/validate.sh
```

For release packaging checks, also run:

```sh
./scripts/package.sh
```

Versioning rules are documented in [docs/semantic-versioning.md](docs/semantic-versioning.md). Pull requests that change released mod behavior should state whether they require a patch, minor, or major bump.

## Scope

Advanced Fluid Infrastructure owns pipe, pipe-to-ground, pump, offshore pump, pipeline extent, and fluid infrastructure progression for Factorio 2.0 and Space Age.

Keep changes focused on that scope. Compatibility fixes are welcome when they preserve the mod's staged fluid progression and do not move unrelated gameplay systems into this repository.

## AI-Assisted Contributions

This repository permits AI-assisted work. Contributions should still be reviewed, tested, and explained like any other change.

The `.governance/` directory is intentionally public. It documents the guardrails used for AI-assisted development in this repository, including task scoping, validation expectations, release discipline, and review posture.

## Release Discipline

Do not publish, tag, upload to the Factorio mod portal, or modify release automation as part of a contribution unless the pull request is explicitly about release work.

Version changes belong in `src/info.json` and should be paired with `src/changelog.txt` updates.

Promotions to `main` must use a short-lived `release/*` branch created from `dev`. Do not open recurring pull requests directly from `dev` to `main`.
