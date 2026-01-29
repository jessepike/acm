---
type: "memory_global"
description: "ACM global operating context"
version: "2.0.0"
updated: "2026-01-25"
scope: "global"
lifecycle: "reference"
location: "~/.claude/CLAUDE.md"
---

# ACM Global Context

<constraints>
- Never commit secrets, credentials, or API keys
- Never modify `.claude/rules/` without explicit human approval
- Confirm before destructive operations (delete, drop, overwrite)
- Ask when uncertain rather than assume
</constraints>

## Orientation

On any ACM project, read in this order:
1. `docs/intent.md` — North Star (what we're trying to accomplish)
2. `docs/brief.md` — Scope, success criteria, constraints
3. `.claude/CLAUDE.md` — Project-specific context
4. `.claude/rules/` — Governing constraints (if present)

## Folder Structure

```
project/
├── .claude/
│   ├── CLAUDE.md      # Project context
│   └── rules/         # Human-controlled rules
├── docs/
│   ├── intent.md      # North Star
│   ├── brief.md       # Scope and criteria
│   └── inbox/         # Triage zone
├── _archive/          # Inactive but preserved
└── README.md
```

## Key Artifacts

| Artifact | Location | Purpose |
|----------|----------|---------|
| intent.md | `docs/intent.md` | North Star — what and why (human-controlled) |
| brief.md | `docs/brief.md` | Scope, success criteria, constraints |
| CLAUDE.md | `.claude/CLAUDE.md` | Project context and current state |

## Artifact Lifecycle

| Class | Location | Rule |
|-------|----------|------|
| **Deliverable** | `src/`, `output/`, `workflows/` | Never auto-prune |
| **Reference** | `docs/` | Archive when obsolete |
| **Ephemeral** | `docs/inbox/` | Delete after use |

**Inbox:** Triage zone — process items, then move to `docs/` or delete.

**Archive:** `_archive/` — inactive but might need later.

## Commit Standards

- Atomic commits — one logical change per commit
- Format: `type(scope): description`
- Verify before commit: lint, test, build

## Communication

- Concise — bullets over paragraphs
- Flag blockers immediately
- State assumptions explicitly
