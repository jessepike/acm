---
type: "documentation"
description: "ACM scripts documentation"
version: "1.0.0"
updated: "2026-01-24"
lifecycle: "reference"
location: "scripts/README.md"
---

# ACM Scripts

Automation scripts for ACM project management.

---

## init-project.sh

Initializes a new project with ACM scaffolding.

### Usage

```bash
./scripts/init-project.sh
```

### What It Does

1. **Checks Global CLAUDE.md** (`~/.claude/CLAUDE.md`)
   - If missing: Creates from ACM template
   - If exists: Shows current contents, prompts to backup + overwrite (default: yes)
   - Serves as reminder to review global context

2. **Prompts for Project Type**
   - `software` — Apps, APIs, libraries (creates src/, tests/, Makefile, etc.)
   - `artifact` — Reports, presentations (creates assets/, output/, etc.)
   - `workflow` — Automations, pipelines (creates workflows/, runbooks/, etc.)
   - `blank` — Base structure only

3. **Prompts for Target Path**
   - Where to create the project
   - Warns if directory exists

4. **Creates Scaffolding**
   - Base: `.claude/`, `docs/`, `_archive/`, README, intent.md, brief.md
   - Type-specific folders and CLAUDE.md template

### Example

```bash
$ ./scripts/init-project.sh

==========================================
  ACM Project Initialization
==========================================

Step 1: Global CLAUDE.md Check
----------------------------------------
Global CLAUDE.md exists at: /Users/you/.claude/CLAUDE.md

Current contents (first 20 lines):
----------------------------------------
[contents shown]
----------------------------------------

Recommended: Backup and overwrite with ACM template.

Backup and overwrite? (Y/n): y
Backed up to: /Users/you/.claude/CLAUDE.md.backup.20260124153022
Updated global CLAUDE.md from ACM template.

Step 2: Project Type
----------------------------------------

Available types:
  1) software  - Code that runs (apps, APIs, libraries)
  2) artifact  - Documents/files (reports, presentations)
  3) workflow  - Processes (automations, pipelines)
  4) blank     - Base structure only

Select type [1-4]: 1

Selected: software

Step 3: Target Path
----------------------------------------

Enter project path: ~/code/my-new-project

Step 4: Creating Scaffolding
----------------------------------------

Creating base structure...
  Created: src/, tests/, config/, scripts/, docs/decisions/, Makefile
  Created: .claude/, docs/, _archive/, README.md, intent.md, brief.md

==========================================
  Project Initialized!
==========================================

Location: /Users/you/code/my-new-project
Type: software

Next steps:
  1. Edit docs/intent.md — Define your North Star
  2. Edit docs/brief.md — Define scope and success criteria
  3. Edit .claude/CLAUDE.md — Add project-specific context
```

### Output Structure

#### Software Project
```
project/
├── .claude/
│   ├── CLAUDE.md
│   └── rules/
├── docs/
│   ├── intent.md
│   ├── brief.md
│   ├── inbox/
│   └── decisions/
├── src/
├── tests/
├── config/
├── scripts/
├── _archive/
├── README.md
└── Makefile
```

#### Artifact Project
```
project/
├── .claude/
│   ├── CLAUDE.md
│   └── rules/
├── docs/
│   ├── intent.md
│   ├── brief.md
│   ├── inbox/
│   └── research/
├── assets/
├── output/
├── _archive/
└── README.md
```

#### Workflow Project
```
project/
├── .claude/
│   ├── CLAUDE.md
│   └── rules/
├── docs/
│   ├── intent.md
│   ├── brief.md
│   ├── inbox/
│   └── runbooks/
├── workflows/
├── scripts/
├── _archive/
└── README.md
```

---

## Future Scripts

| Script | Purpose | Status |
|--------|---------|--------|
| `validate-global.sh` | Check global CLAUDE.md has required content | Deferred |
| `validate-project.sh` | Check project structure and artifacts | Deferred |
| `prune-context.sh` | Clean CLAUDE.md dynamic sections, archive ephemeral | Deferred |
