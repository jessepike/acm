---
type: "specification"
description: "Defines acm-env — the agentic development environment manager plugin"
version: "1.0.0"
updated: "2026-01-29"
scope: "acm"
lifecycle: "reference"
location: "acm/ACM-ENV-SPEC.md"
---

# ACM Environment Specification (acm-env)

## Summary

acm-env is a user-level Claude Code plugin that manages the development environment across user and project layers. It codifies baselines, detects drift, and provides setup/audit/maintenance commands. It wraps and delegates to Anthropic plugins for execution, with built-in fallbacks.

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

### Project Level (`.claude/`)

| Item | Requirement |
|------|-------------|
| `CLAUDE.md` | Required. Has intent reference, context map, current stage. <50 lines. |
| `rules/` | Optional. Project-specific constraints only. |
| MCP servers | Project-specific only. |

## Commands

| Command | Purpose |
|---------|---------|
| `/acm-env:status` | Quick health dashboard — PASS/WARN/FAIL per check |
| `/acm-env:setup` | Smart setup — detects mode (first-time, new project, existing project) |
| `/acm-env:audit` | Deep environment audit with plugin delegation |
| `/acm-env:reset` | Interactive reset to baseline with diffs and approval |

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

## SessionStart Hook

`session-check.sh` — must complete in <100ms:
- File existence checks only (no network, no plugin invocation, no LLM calls)
- Checks: CLAUDE.md at both levels, settings.json, critical baseline markers
- **Silent when clean** — zero output, zero tokens
- **Single warning line when drift detected**

## Skill

`env-auditor` — triggers on natural-language requests like "audit my environment", "check my setup", "is my Claude Code config clean".

## Principles

- YAGNI — build only what's needed now
- Minimal viable context — smallest useful artifact
- Progressive disclosure — summary first, details on demand
- Token-efficient — every artifact earns its context cost
- Graceful degradation — never silently fail

## Relationship to ACM Meta Layer

acm-env is the **management layer for the meta layer itself**. It ensures skills, tools, rules, and context artifacts are properly configured, available, current, and not stale.

### What acm-env manages in v1
- Capabilities (installed, configured, not stale)
- Configuration (matches baseline)
- Context (structure/quality per ACM specs)
- Artifact structure validation (frontmatter, lifecycle, progressive disclosure)
- Context pruning (CLAUDE.md dynamic sections, ephemeral artifacts)

### Consciously deferred
- Spec content management (validates structure, not correctness)
- Prompt management (stage-specific, not environment-level)
- Cross-project learnings
- Intent drift detection
- Taxonomy auto-updater

## References

- ACM-STAGES-SPEC.md
- ACM-CONTEXT-ARTIFACT-SPEC.md
- ACM-TAXONOMY.md
