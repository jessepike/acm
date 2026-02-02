---
type: "specification"
description: "Defines acm-env — the agentic development environment manager plugin"
version: "1.0.0"
updated: "2026-01-29"
scope: "adf"
lifecycle: "reference"
location: "adf/ADF-ENV-PLUGIN-SPEC.md"
---

# ADF Environment Specification (acm-env)

## Summary

acm-env is a user-level Claude Code plugin that manages the development environment across user and project layers. It codifies baselines, detects drift, and provides setup/audit/maintenance skills. It wraps and delegates to Anthropic plugins for execution, with built-in fallbacks.

## Taxonomy

- **Environment** — umbrella term for everything acm-env manages
  - **Capabilities** — plugins, MCP servers, hooks, skills, agents, tools
  - **Configuration** — settings.json, keybindings
  - **Context** — CLAUDE.md files, rules/

## Baselines

acm-env defines expected state at two levels:

### User Level (`~/.claude/`)

| Item | Requirement |
|------|-------------|
| `CLAUDE.md` | Required. <50 lines. Has `<constraints>` block. No project-specific content. |
| `settings.json` | Required. Has permissions block. |
| Plugins/MCP servers | Only cross-project items at this level. |
| Hooks | All user-level hooks declared in `baseline.yaml`. Undeclared hooks = drift. |

### Project Level (`.claude/`)

| Item | Requirement |
|------|-------------|
| `CLAUDE.md` | Required. Has intent reference, context map, current stage. <50 lines. |
| `rules/` | Optional. Project-specific constraints only. |
| MCP servers | Project-specific only. |

## Skills

| Skill | Purpose |
|-------|---------|
| `/acm-env:status` | Scope-aware health dashboard — `--scope project` (default) or `--scope user` |
| `/acm-env:setup` | Smart setup — detects mode (first-time, new project, existing project) |
| `/acm-env:audit` | Deep environment audit with plugin delegation |
| `/acm-env:reset` | Interactive reset to baseline with diffs and approval |

### Status Command (`/acm-env:status`)

Supports `--scope` flag:
- **`project`** (default) — user-level foundation + project-level specifics + capabilities (plugins, MCP servers)
- **`user`** — cross-project only: global config, user-level plugins, MCP servers, hooks

Capabilities reporting checks:
- **Plugins**: required/available/remove lists from `baseline.yaml`, cross-referenced with `installed_plugins.json` and `settings.json`
- **MCP servers**: standalone (`~/.claude.json` → `mcpServers`), plugin-bundled (`.mcp.json` in plugin dirs), project-level (`.mcp.json` + project overrides in `~/.claude.json`)
- **Remove list**: flags configured servers/plugins that should be removed per baseline

### Mode Detection (`/acm-env:setup`)

| Condition | Mode | Behavior |
|-----------|------|----------|
| No `~/.claude/CLAUDE.md` or baseline config | First-time | Bootstrap user-level environment |
| In directory with no `.claude/` | New project | Initialize project-level environment |
| In directory with existing `.claude/` | Existing project | Audit and offer corrections |

## Dependencies

```
acm-env (wrapper/orchestrator)
  ├── claude-md-management → CLAUDE.md quality audit + session learning capture
  └── claude-code-setup    → codebase analysis, automation recommendations
```

- Dependencies are **expected** but acm-env **degrades gracefully** with clear warnings
- When a dependency is missing: surface explicit warning, run built-in fallback, suggest installation
- Never silently fail — always inform the user

## Hooks

### SessionStart Hook

`session-check.sh` — must complete in <100ms:
- File existence checks only (no network, no plugin invocation, no LLM calls)
- Checks: CLAUDE.md at both levels, settings.json, critical baseline markers
- **Silent when clean** — zero output, zero tokens
- **Single warning line when drift detected**

### Stop Hook

`stop-check.sh` — enforces session discipline:
- Checks for uncommitted changes (staged or unstaged)
- Checks if `status.md` was modified recently (within 5 minutes)
- **Blocks session end** if either check fails — Claude resumes to commit and update
- Enforces the Session Discipline rule from `.claude/rules/`

### Hooks Governance

All user-level hooks must be declared in `baseline.yaml` under `user_level.checks.hooks.declared`. This prevents drift where a hook gets installed during one project and silently affects all future projects.

The `/acm-env:audit` command validates:
- All declared hooks are present and functional
- No undeclared hooks exist at user level
- Each hook has a documented source and purpose

## Skill

`env-auditor` — triggers on natural-language requests like "audit my environment", "check my setup", "is my Claude Code config clean".

## Principles

- YAGNI — build only what's needed now
- Minimal viable context — smallest useful artifact
- Progressive disclosure — summary first, details on demand
- Token-efficient — every artifact earns its context cost
- Graceful degradation — never silently fail

## Relationship to ADF Environment Layer

acm-env is the **management layer for the environment layer itself**. It ensures skills, tools, rules, and context artifacts are properly configured, available, current, and not stale.

### Capabilities Registry

The source of truth for available capabilities is the **capabilities registry** at `~/code/_shared/capabilities-registry/`. acm-env references the registry's `INVENTORY.md` to validate that expected capabilities are present and current. See `REGISTRY-SPEC.md` in that repo for the full specification.

### What acm-env manages in v1
- Capabilities (installed, configured, not stale — validated against capabilities-registry)
- Configuration (matches baseline)
- Context (structure/quality per ADF specs)
- Artifact structure validation (frontmatter, lifecycle, progressive disclosure)
- Context pruning (CLAUDE.md dynamic sections, ephemeral artifacts)

### Consciously deferred
- Spec content management (validates structure, not correctness)
- Prompt management (stage-specific, not environment-level)
- Cross-project learnings
- Intent drift detection
- Taxonomy auto-updater

## References

- ADF-STAGES-SPEC.md
- ADF-CONTEXT-ARTIFACT-SPEC.md
- ADF-TAXONOMY.md
- `~/code/_shared/capabilities-registry/REGISTRY-SPEC.md`
