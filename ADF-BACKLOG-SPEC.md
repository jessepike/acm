---
type: "specification"
description: "Defines BACKLOG.md — prioritized queue of potential work items for a project"
version: "1.0.0"
updated: "2026-01-30"
scope: "adf"
lifecycle: "reference"
location: "adf/ADF-BACKLOG-SPEC.md"
---

# ADF Backlog Specification

## Purpose

Define `BACKLOG.md` — a running, prioritized list of potential next work items for a project. The backlog is the single place to capture, triage, and sequence work. It answers one question fast: **what should we work on next?**

---

## Design Principles

| Principle | How |
|-----------|-----|
| Quick-check friendly | Queue section shows only incomplete items — no scanning past done work |
| Progressive disclosure | Queue (actionable) on top, Archive (historical) on bottom |
| Token-efficient | Completed items compress into a minimal archive row |
| Low ceremony | Add items freely; triage and prioritize periodically |

---

## Document Structure

```
BACKLOG.md
├── Frontmatter (YAML)
├── Queue (incomplete items, sorted by priority)
└── Archive (completed items, reverse chronological)
```

### Frontmatter

Standard ACM frontmatter with `type: "tracking"`.

### Queue

The **only section you need to read** for "what's next?". Contains all incomplete items sorted by priority (P1 first), then by ID within each priority.

| Column | Required | Description |
|--------|----------|-------------|
| ID | Yes | Unique identifier (`B1`, `B2`, ...). Monotonically increasing. Never reused. |
| Item | Yes | Brief description of the work |
| Type | Yes | Category (see Type values below) |
| Component | Yes | Which part of the system this touches |
| Pri | Yes | Priority: `P1`, `P2`, `P3` |
| Size | Yes | Complexity: `S`, `M`, `L` |
| Status | Yes | `Pending`, `In Progress`, or `Blocked` |

### Archive

Completed items moved here with date and optional notes. Reverse chronological (most recent first).

| Column | Required | Description |
|--------|----------|-------------|
| ID | Yes | Original ID from queue |
| Item | Yes | Brief description |
| Completed | Yes | Date completed (YYYY-MM-DD) |
| Notes | No | Brief outcome or context |

---

## Field Values

### Priority

| Value | Meaning | Guidance |
|-------|---------|----------|
| `P1` | High | Blocking current work or critical path |
| `P2` | Medium | Important but not blocking |
| `P3` | Low | Future consideration, nice-to-have |

### Size (Complexity)

| Value | Meaning | Guidance |
|-------|---------|----------|
| `S` | Small | Single-session, no planning needed. Quick fix, cleanup, or config change. |
| `M` | Medium | Some investigation needed. 1-2 sessions. May touch multiple files. |
| `L` | Large | Needs a planning phase. Multi-session. New spec, architecture, or cross-repo work. |

### Type

Common values (not exhaustive):
- `Bug fix` — something broken
- `Enhancement` — improve existing behavior
- `New spec` — new specification document
- `Spec update` — modify existing spec
- `Maintenance` — cleanup, audits, debt
- `Architecture` — structural or design change
- `Setup` — scaffolding, repo creation
- `Script` — tooling or automation

### Status

| Value | Meaning |
|-------|---------|
| `Pending` | Ready to pick up |
| `In Progress` | Actively being worked |
| `Blocked` | Waiting on something (note what in Item or a comment) |

Items with status `Done` do not appear in the Queue — they move to Archive.

---

## Maintenance Rules

1. **Adding items:** Append to Queue with next available ID. Default status: `Pending`. Assign priority and size.
2. **Completing items:** Remove row from Queue, add row to Archive with completion date and optional notes.
3. **Reprioritizing:** Change the `Pri` column and re-sort the table (P1 → P2 → P3, then by ID within each priority).
4. **Periodic triage:** Review Queue occasionally to reprioritize, remove stale items, or split large items.
5. **ID stability:** IDs are permanent. Never reuse or renumber. Gaps are fine.

---

## Quick-Check Protocol

To find the next work item:

1. Open `BACKLOG.md`
2. Read the Queue table top-to-bottom
3. First `Pending` item at the highest priority is next
4. If the top item is `Blocked`, skip to the next `Pending` item

---

## Relationship to Other Artifacts

| Artifact | Relationship |
|----------|-------------|
| `status.md` | Status tracks current session state; backlog tracks the full work queue |
| `brief.md` | Brief defines project scope; backlog items may originate from brief requirements |
| `CLAUDE.md` | CLAUDE.md may reference the backlog for orientation |
