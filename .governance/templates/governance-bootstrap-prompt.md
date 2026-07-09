# Governance Bootstrap Prompt

Use this single prompt for any agent that needs to initialize, verify, or update its local governance from Jason's `ai-governance` repository.

Canonical source:

```text
gitea.infra.newedenhomestead.net:ai-projects/ai-governance.git
```

Canonical prompt path:

```text
lab-governance/templates/governance-bootstrap-prompt.md
```

Branch channel rule:

If this prompt is read from an `ai-governance` branch whose name starts with `enforcement-redesign/`, treat the secondary enforcement-redesign branch family as the source channel. Do not silently switch to the normal `trunk`, `coding-agent`, `desktop-orchestrator`, or `factorio-modding-agent` branch family unless Jason explicitly directs that change.

Secondary branch mapping:

```text
general -> enforcement-redesign/trunk
coding_agent -> enforcement-redesign/coding-agent
desktop_orchestrator -> enforcement-redesign/desktop-orchestrator
factorio_modding_agent -> enforcement-redesign/factorio-modding-agent
```

## Prompt

```markdown
Before doing substantive work, bootstrap or update this workspace's governance from Jason's `ai-governance` repository.

Use `lab-governance/governance-init.md` as the setup guide and `lab-governance/templates/local-status.yaml` as the local status shape.

Use the same governance branch channel as the prompt source. If this prompt came from an `enforcement-redesign/*` branch, select the matching `enforcement-redesign/*` branch for this agent kind unless Jason explicitly redirects you to the normal governance channel.

First, determine whether this workspace already has local governance:

- If `AGENTS.md` and `.governance/` exist, treat this as a governed-agent update.
- If they do not exist, treat this as first-time governance initialization.

Before changing files, identify or ask for:

- the Jason-settled canonical agent name
- the agent kind
- the prompt source branch or source commit, when known
- the active governance branch to consume
- the current local status path and versions, if present
- any legacy self-stamp or registry row that may provide candidate evidence only

Do not infer the canonical agent name from repository name, hostname, model backend, runtime surface, task role, or prior chat label. If local status, a legacy self-stamp, or a legacy registry row names an agent, report it and ask Jason to confirm or correct it before mutating governance.

Then:

1. Inspect or fetch `ai-governance`.
2. Select the correct active governance branch for the agent within the prompt's source branch channel.
3. Copy or merge the branch-local governance picture into the workspace.
4. Preserve local-only governance files unless Jason or explicit policy says to reconcile them.
5. Ensure `.governance/local/index.yaml` exists, using `lab-governance/templates/local-index.yaml` as the loose starter shape when needed. Do not prescribe the rest of `.governance/local/`.
6. Create or update `.governance/local/status.yaml` from `lab-governance/templates/local-status.yaml`.
7. Re-read the resulting `AGENTS.md`, `.governance/policies/universal.yaml`, `.governance/task-map.yaml`, any `.governance/kind-routes.yaml`, and `.governance/local/index.yaml` when present.
8. Treat lab/canon governance as the base layer, loaded local governance as the workspace layer above it, and explicit one-shot overrides as the top layer for their declared operation.
9. Compare local status, source branch descriptor, and any legacy self-stamp or registry evidence. Report conflicts instead of silently reconciling them.
10. Treat the legacy central registry as historical and non-authoritative. Do not submit a central registry attestation unless Jason explicitly requests legacy registry maintenance.

Do not directly edit `agent-registry/agents.yaml` unless Jason explicitly asks for legacy registry maintenance.

Close out with only:

- canonical agent name and agent kind
- source branch and commit consumed
- prompt source branch or channel used for branch selection
- active and generalized canon versions after the operation
- local status path updated or created
- local status declared state
- legacy registry status, only if Jason explicitly requested legacy registry maintenance
- unresolved reconciliation items and their owners
```
