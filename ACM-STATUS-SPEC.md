---
type: "specification"
description: "Defines status.md — lightweight session state tracking across all stages"
version: "1.1.0"
updated: "2026-01-27"
scope: "acm"
lifecycle: "reference"
location: "acm/ACM-STATUS-SPEC.md"
---

# ACM Status Specification

## Purpose

Define `status.md` — a lightweight document that captures session state for continuity across agent sessions. This is a **meta-layer artifact** that persists across all stages.

---

## Why Status.md

| Problem | Solution |
|---------|----------|
| CLAUDE.md gets polluted with dynamic state | Separate concerns — CLAUDE.md is manifest, status.md is state |
| Agent loses context between sessions | status.md captures where we left off |
| Human cognitive overload managing multiple projects | Quick glance at status.md shows current state |
| Session State embedded in Brief adds noise | Brief stays focused on contract; status is separate |

---

## Relationship to Other Artifacts

| Artifact | Role | Stage Relevance |
|----------|------|-----------------|
| **CLAUDE.md** | Context manifest — points to status.md | All stages |
| **status.md** | Lightweight session state | All stages (meta-layer) |
| **tasks.md** | Comprehensive task planning with milestones | Develop, Deliver (supplements status.md) |

**Meta-layer artifact:** Status.md is always present, always loaded, always updated. It tracks session continuity regardless of stage.

**Progression:** In early stages (Discover, Design), status.md is the primary state tracker. In later stages (Develop, Deliver), `tasks.md` handles detailed task management while status.md continues tracking session-level state.

---

## Content Structure

Status.md is intentionally minimal:

```markdown
---
project: "[Project Name]"
stage: "[Discover | Design | Develop | Deliver]"
updated: "YYYY-MM-DD"
---

# Status

## Current State
- **Phase:** [Current phase within stage]
- **Focus:** [What we're working on right now]

## Last Session
- **Date:** YYYY-MM-DD
- **Completed:** [What was accomplished]

## Next Steps
- [ ] [Immediate action 1]
- [ ] [Immediate action 2]
- [ ] [Immediate action 3]

## Pending Decisions
- [Decision needed — context if relevant]

## Blockers
- [None or description]

## Notes
[Any context the next session needs that doesn't fit above]
```

**Target size:** 15-30 lines. If it's getting longer, prune or simplify.

---

## Session History & Pruning

Status.md keeps a rolling history of recent sessions. To prevent unbounded growth:

**Keep:** Last 5 session entries in the Session Log section.

**Prune:** When adding a 6th entry, remove the oldest. If historical context is important, archive to a separate `status-archive.md` or note in Brief's revision history.

**Session Log format:**

```markdown
## Session Log

| Date | Summary |
|------|---------|
| 2026-01-27 | Completed review cycle 3, addressed P1 #2 |
| 2026-01-26 | Ran review with GPT-4, logged 4 issues |
| 2026-01-25 | Drafted initial Brief v0.1 |
```

This replaces the single "Last Session" section when multiple sessions accumulate. Keep it concise — one line per session.

---

## Agent Behavior

### Session Start

1. Agent reads CLAUDE.md (manifest)
2. CLAUDE.md points to status.md
3. Agent reads status.md
4. Agent understands: current phase, last session's work, next steps
5. Agent picks up where previous session left off

### Session End

**Critical:** Agent must close the loop before session ends.

1. Agent updates status.md:
   - Update "Last Session" with date and what was completed
   - Update "Next Steps" with remaining work
   - Note any new blockers or pending decisions
2. If stage completed, update stage field
3. Commit/save status.md

**Enforcement:** This is a spec requirement. Agents should update status.md before ending work. Human can remind if agent forgets.

---

## CLAUDE.md Integration

CLAUDE.md should reference status.md:

```markdown
## Current Status

See `docs/status.md` for session state.

**Quick glance:**
- Stage: Discover
- Phase: Review Loop
```

The "Quick glance" is optional convenience — agent should still read full status.md.

---

## Context Map Entry

In CLAUDE.md's Context Map:

| File | Load When | Purpose |
|------|-----------|---------|
| docs/status.md | Always | Session state |

Status.md is always loaded — it's small and always relevant.

---

## Stage Transitions

When moving between stages:

1. Update status.md `stage` field
2. Clear completed items from "Next Steps"
3. Add stage-specific next steps
4. Archive or reset "Last Session" section

### Discover → Design Example

```markdown
## Current State
- **Phase:** Handoff complete
- **Focus:** Beginning Design stage

## Last Session
- **Date:** 2026-01-27
- **Completed:** Finalized Brief, passed exit criteria, human sign-off

## Next Steps
- [ ] Review Brief for Design inputs
- [ ] Identify architecture decisions needed
- [ ] Draft initial tech stack options
```

---

## When to Transition to tasks.md

Status.md is for discrete, sequential work. When work becomes:
- Multi-threaded (parallel tasks)
- Milestone-based (phases with many sub-tasks)
- Complex enough to need prioritization/assignment

...then transition to `tasks.md` (specified separately for Develop stage).

Typical trigger: Entering Develop stage with a non-trivial build.

---

## Format: Markdown vs YAML

**Decision:** Markdown.

Rationale:
- Human-readable without parsing
- Easy to edit manually
- Consistent with other ACM artifacts
- YAML would be overkill for ~20 lines of state

---

## File Location

```
/project-root/
  docs/
    intent.md
    discover-brief.md
    status.md          # <-- Session state
  CLAUDE.md
  README.md
```

No stage prefix needed — there's only one status.md per project.

---

## Validation Criteria

A well-formed status.md:

- [ ] Has current stage and phase
- [ ] Has "Last Session" with date and summary
- [ ] Has actionable "Next Steps" (not vague)
- [ ] Under 30 lines
- [ ] Updated at end of each session

---

## References

- ACM-PROJECT-CLAUDE-MD-SPEC.md (CLAUDE.md references status.md)
- ACM-DISCOVER-SPEC.md (Discover phase tracking)
- ACM-TAXONOMY.md (Status definitions)
