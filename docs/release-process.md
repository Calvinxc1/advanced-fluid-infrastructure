# Release Process

This document is for maintainers. Public users do not need access to the release automation infrastructure to install or use the mod.

The local Gitea instance is the source of truth for release automation. It is private infrastructure and is not expected to be publicly accessible.

GitHub is the public mirror. Public consumers should use the GitHub repository and Factorio mod portal release artifacts rather than assuming access to the local Gitea server.

The mod version is defined in `src/info.json`. Release notes live in `src/changelog.txt` using the Factorio mod portal changelog format.

Versioning policy is documented in [semantic-versioning.md](semantic-versioning.md). The top changelog entry must match the `src/info.json` version.

## Branch Model

This repository uses a lightweight Gitflow model:

- `dev` is the long-lived integration branch.
- `main` is the release branch.
- Release promotion uses short-lived `release/*` branches created from `dev`.
- Feature branches are not required yet; day-to-day maintainer work may happen directly on `dev` until the repository maintainer enables feature branching.

Do not open recurring pull requests directly from `dev` to `main`. This Gitea instance keeps merged pull requests associated with their live head/base branch pair, so reusing `dev -> main` can block future pull requests after the first merge.

Use this promotion shape instead:

```text
dev -> release/<version-or-purpose> -> main
```

Example release branch names:

```text
release/0.1.1
release/0.2.0
release/public-readiness-0.1.0
```

## Local Checks

Run the full validation entrypoint before opening a release PR:

```sh
./scripts/validate.sh
```

Build the upload package locally with:

```sh
./scripts/package.sh
```

The package is written to `dist/` and named `{mod-name}_{version}.zip`.

## Release Branch Procedure

When `dev` is ready to promote:

1. Ensure local `main` and `dev` are current.
2. Create a release branch from `dev`:

   ```sh
   git checkout dev
   git pull --ff-only origin dev
   git checkout -b release/<version-or-purpose>
   git push origin release/<version-or-purpose>
   ```

3. Open a pull request from `release/<version-or-purpose>` to `main`.
4. Confirm CI passes.
5. Merge the release PR into `main`.
6. Delete the release branch after merge.
7. Merge or fast-forward `main` back into `dev` so `dev` contains the release merge ancestry.

## Automated Gitea Release

The Gitea deploy workflow runs on pushes to `main`.

It validates the mod, compares the current `src/info.json` version to the previous `main` version, packages the mod, and creates a Gitea release only when the version changed.

This means a version bump is the deployment trigger. Changes merged to `main` without a version bump are validated but do not create a release.

The workflow uses the built-in Gitea Actions token:

```text
${{ secrets.GITEA_TOKEN }}
```

The workflow requests:

```yaml
permissions:
  contents: read
  releases: write
```

No separate release token is required unless repository or owner Actions settings clamp the built-in token below `releases: write`.

Release artifacts created in local Gitea may be mirrored or copied to public distribution channels, but public users should not depend on private Gitea URLs.

## Future Mod Portal Deployment

The Factorio mod portal upload can be added after Gitea release packaging is stable. The official upload API requires a Factorio API key with `ModPortal: Upload Mods` usage.
