---
type: "specification"
description: "Defines minimal folder structure for ADF projects"
version: "1.2.0"
updated: "2026-02-01"
scope: "adf"
lifecycle: "reference"
location: "adf/ADF-FOLDER-STRUCTURE-SPEC.md"
---

# ADF Folder Structure Specification

## Summary

Defines the minimal folder structure for all ADF projects. `docs/` is the main folder for markdown, context, and reference files. Includes lifecycle-aware folders: `inbox/` for triage, `.archive/` for inactive artifacts.

---

## Design Principles

**Minimal base:** Every project gets the same core structure.

**Type-specific additions:** Software, Artifact, and Workflow projects add what they need.

**Flat over deep:** Avoid unnecessary nesting. Add depth only when it earns its place.

**Lifecycle-aware:** Structure supports artifact lifecycle (deliverable, reference, ephemeral).

---

## Base Structure (All Projects)

```
project-root/
├── .claude/
│   ├── CLAUDE.md              # Project context (agent-writable)
│   └── rules/                 # Governing rules (human-controlled)
├── docs/                      # Main folder for markdown/context/reference
│   ├── intent.md              # North Star (from Discover)
│   ├── brief.md               # Detailed scope (from Discover)
│   ├── acm/                   # Stage planning artifacts (workspace)
│   │   └── archive/           # Completed planning artifacts
│   └── inbox/                 # Triage zone (new/unprocessed items)
├── .archive/                  # Inactive artifacts (not deleted, not active)
└── README.md                  # What this is, how to use it
```

**Core folders:** 7 items. This is the irreducible minimum.

**`docs/adf/` contents (created during Develop, populated per stage):**

```
docs/adf/
├── plan.md            # Implementation plan (Develop)
├── tasks.md           # Task tracking (Develop)
├── manifest.md        # Dependencies (Develop)
├── capabilities.md    # Agent infrastructure (Develop)
└── archive/           # Completed planning artifacts
```

---

## Lifecycle Folders

| Folder | Purpose | Lifecycle Class |
|--------|---------|-----------------|
| `docs/` | Context and reference files | Reference |
| `docs/inbox/` | New items awaiting triage | Ephemeral → Reference or delete |
| `.archive/` | Inactive but preserved (NOT FOR AGENT READS) | Archived (out of context) |

### Inbox Flow

```
New context arrives → docs/inbox/ → [Process] → docs/ or delete
```

### Archive Flow

```
Artifact no longer active → Still valuable? → .archive/ or delete
```

**Note:** `.archive/` uses dot prefix for consistency with `.claude/` and to signal "not current."

### Archive Access Rules

**CRITICAL:** The `.archive/` directory is write-only for agents unless explicitly instructed otherwise.

- ✅ Agents MAY move files TO `.archive/` during cleanup
- ❌ Agents MUST NOT read from, search in, or pull context from `.archive/` without explicit user instruction ("pull from archive", "look in archive")
- ❌ Do not assume the user wants archived content accessed — wait for explicit instruction

See `.claude/rules/archive.md` for complete rules. This prevents stale/outdated context from polluting active work.

---

## Type-Specific Additions

### Software Projects

```
project-root/
├── .claude/
├── docs/
│   ├── intent.md
│   ├── brief.md
│   ├── inbox/
│   └── decisions/             # ADRs (added as needed)
├── src/                       # Source code (deliverable)
├── tests/                     # Test files (deliverable)
├── config/                    # Configuration files
├── scripts/                   # Build/deploy scripts
├── .archive/
├── README.md
└── Makefile                   # Standard commands
```

**Additional for Software:**
- `src/` — where code lives (deliverable)
- `tests/` — where tests live (deliverable)
- `config/` — environment configs, settings
- `scripts/` — automation helpers
- `Makefile` — standard commands (setup, test, lint, build, deploy)
- `docs/decisions/` — ADRs as decisions accumulate

---

### Artifact Projects

```
project-root/
├── .claude/
├── docs/
│   ├── intent.md
│   ├── brief.md
│   ├── inbox/
│   └── research/              # Source materials, notes
├── assets/                    # Images, data files
├── output/                    # Generated artifacts (deliverable)
├── .archive/
└── README.md
```

**Additional for Artifact:**
- `assets/` — supporting files (images, data)
- `output/` — where the artifact gets built/exported (deliverable)
- `docs/research/` — source materials, reference docs

---

### Workflow Projects

```
project-root/
├── .claude/
├── docs/
│   ├── intent.md
│   ├── brief.md
│   ├── inbox/
│   └── runbooks/              # Operational procedures
├── workflows/                 # Workflow definitions (deliverable)
├── scripts/                   # Supporting automation
├── .archive/
└── README.md
```

**Additional for Workflow:**
- `workflows/` — pipeline definitions, agent configs (deliverable)
- `scripts/` — supporting automation
- `docs/runbooks/` — operational procedures, SOPs

---

## Folder Purposes

| Folder | Purpose | Lifecycle | Who writes |
|--------|---------|-----------|------------|
| `.claude/` | Agent context and governance | Reference | Agent + Human |
| `.claude/rules/` | Hard constraints (policy) | Reference (protected) | Human only |
| `docs/` | Main context/reference folder | Reference | Human + Agent |
| `docs/inbox/` | Triage zone | Ephemeral | Human + Agent |
| `docs/adf/` | Stage planning artifacts, agent workspace | Ephemeral → Archive after stage | Agent |
| `docs/adf/archive/` | Completed planning artifacts | Archived | Agent |
| `docs/intent.md` | North Star | Reference (protected) | Human |
| `docs/brief.md` | Scope and criteria | Reference | Human + Agent |
| `.archive/` | Inactive artifacts (write-only for agents) | Archived | Agent (write), Human (read/write) |
| `src/` | Source code (Software) | Deliverable | Agent |
| `tests/` | Test code (Software) | Deliverable | Agent |
| `output/` | Generated output (Artifact) | Deliverable | Agent |
| `workflows/` | Process definitions (Workflow) | Deliverable | Agent |

---

## What NOT to Create at Init

These emerge during Design/Develop, not at Project Init:

- `node_modules/`, `.venv/`, etc. (runtime artifacts)
- `.env` files (created during Setup)
- CI/CD configs (created during Design/Setup)
- Detailed architecture docs (created during Design)

---

## Scaffolding Script (Conceptual)

```bash
# Project Init creates:
mkdir -p .claude/rules docs/inbox docs/adf/archive .archive
touch .claude/CLAUDE.md
touch docs/intent.md docs/brief.md
touch README.md

# Type-specific additions:
# Software: mkdir -p src tests config scripts docs/decisions && touch Makefile
# Artifact: mkdir -p assets output docs/research
# Workflow: mkdir -p workflows scripts docs/runbooks
```

---

## Maintenance

### Prune Triggers

| Trigger | Action |
|---------|--------|
| Stage transition | Clear `docs/inbox/`, review ephemeral |
| Stage completion | Archive planning artifacts from `docs/adf/` to `docs/adf/archive/` |
| Project milestone | Review `docs/`, archive obsolete |
| Context bloat | Audit all folders, prune aggressively |

### Archive vs Delete

- **Archive** if: Might need later, historical value, uncertain
- **Delete** if: Clearly obsolete, duplicated elsewhere, no future value

---

## Validation Checklist

Before exiting Project Init:

- [ ] `.claude/CLAUDE.md` exists (can be stub)
- [ ] `docs/intent.md` exists (can be stub)
- [ ] `docs/brief.md` exists (can be stub)
- [ ] `docs/inbox/` exists
- [ ] `docs/adf/archive/` exists
- [ ] `.archive/` exists
- [ ] `README.md` exists (can be minimal)
- [ ] Type-specific folders created

---

## References

- ADF-CONTEXT-ARTIFACT-SPEC.md (lifecycle classes)
- ADF-PROJECT-TYPES-SPEC.md (type determines additions)
- ADF-STAGES-SPEC.md (Project Init creates structure)
