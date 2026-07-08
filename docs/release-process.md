# Release Process

The local Gitea instance is the source of truth for release automation. It is private infrastructure and is not expected to be publicly accessible.

GitHub is the public mirror. Public consumers should use the GitHub repository and Factorio mod portal release artifacts rather than assuming access to the local Gitea server.

The mod version is defined in `src/info.json`. Release notes live in `src/changelog.txt` using the Factorio mod portal changelog format.

Versioning policy is documented in [semantic-versioning.md](semantic-versioning.md). The top changelog entry must match the `src/info.json` version.

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

## Future Mod Portal Deployment

The Factorio mod portal upload can be added after Gitea release packaging is stable. The official upload API requires a Factorio API key with `ModPortal: Upload Mods` usage.
