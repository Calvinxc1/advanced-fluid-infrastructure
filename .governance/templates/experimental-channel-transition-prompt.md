# Experimental Governance Channel Transition Prompt

Use this prompt when an already-governed agent should move from the normal governance branch family to the secondary `enforcement-redesign/*` governance branch family.

This prompt is for transition, not first-time bootstrap. If the workspace has no `AGENTS.md` and no `.governance/` tree, use `lab-governance/templates/governance-bootstrap-prompt.md` from the target experimental branch instead.

Target branch mapping:

```text
general -> enforcement-redesign/trunk
coding_agent -> enforcement-redesign/coding-agent
desktop_orchestrator -> enforcement-redesign/desktop-orchestrator
factorio_modding_agent -> enforcement-redesign/factorio-modding-agent
```

## Prompt

````markdown
Before doing substantive work, transition this already-governed workspace from Jason's normal `ai-governance` branch family to the secondary `enforcement-redesign/*` governance branch family.

Use Jason's `ai-governance` repository as the source:

```text
gitea.infra.newedenhomestead.net:ai-projects/ai-governance.git
```

This is an experimental-channel transition. Do not update from normal `trunk`, `coding-agent`, `desktop-orchestrator`, or `factorio-modding-agent` unless Jason explicitly cancels or redirects the transition.

First, inspect the current local governance state without changing files:

- read `AGENTS.md`
- read `.governance/local/status.yaml` if present
- read `.governance/branch-descriptor.yaml` if present
- read `.governance/kind-routes.yaml` if present
- identify the current active governance branch, current active canon version, generalized canon version, and source commit when locally recorded

Confirm or ask for:

- the Jason-settled canonical agent name
- the agent kind
- the target experimental branch from the mapping below
- whether local-only governance files should be preserved as-is or reconciled during the transition

Target experimental branch mapping:

```text
general -> enforcement-redesign/trunk
coding_agent -> enforcement-redesign/coding-agent
desktop_orchestrator -> enforcement-redesign/desktop-orchestrator
factorio_modding_agent -> enforcement-redesign/factorio-modding-agent
```

Then:

1. Fetch or inspect `ai-governance`.
2. Verify the target experimental branch exists.
3. Read the target branch's `AGENTS.md`, `.governance/branch-descriptor.yaml`, `lab-governance/governance-init.md`, and `lab-governance/templates/governance-bootstrap-prompt.md`.
4. Copy or merge the target branch-local governance picture into this workspace.
5. Preserve workspace-local files under `.governance/local/` unless Jason or explicit policy says to reconcile them.
6. Ensure `.governance/local/index.yaml` exists, using `lab-governance/templates/local-index.yaml` from the target experimental branch when needed.
7. Update `.governance/local/status.yaml` so it records the target experimental branch, target active canon version, target generalized canon version, source repository, source commit, verification date, and any unresolved reconciliation notes.
8. Re-read the resulting `AGENTS.md`, `.governance/policies/universal.yaml`, `.governance/policies/enforcement-model.yaml`, `.governance/task-map.yaml`, any `.governance/kind-routes.yaml`, and `.governance/local/index.yaml` when present.
9. Compare the pre-transition status, new local status, target branch descriptor, and any legacy self-stamp or registry evidence. Report conflicts instead of silently reconciling them.
10. Treat the legacy central registry as historical and non-authoritative. Do not submit a central registry attestation unless Jason explicitly requests legacy registry maintenance.

Stop and ask Jason before mutating local governance if:

- the canonical agent name is missing or disputed
- the agent kind is unknown
- the target experimental branch is ambiguous or missing
- local status conflicts with the target branch descriptor in a way that changes which branch should be consumed
- local-only governance files appear to override branch-channel selection
- the workspace has uncommitted local governance edits whose owner is unclear

Close out with only:

- canonical agent name and agent kind
- previous governance branch and canon version, if known
- target experimental branch and commit consumed
- active and generalized canon versions after the transition
- local status path updated
- local status declared state
- local-only files preserved or reconciled
- unresolved reconciliation items and their owners
````
