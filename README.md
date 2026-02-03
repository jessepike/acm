---
type: "documentation"
description: "ADF package overview and quick start"
version: "2.0.0"
updated: "2026-01-27"
lifecycle: "reference"
location: "adf/README.md"
---

# ADF — Agentic Development Framework

Minimal primitives for managed agentic workflows. A lightweight scaffolding system that applies to any project type: apps, artifacts, or workflows.

---

## Quick Start

### 1. Deploy Global CLAUDE.md

```bash
mkdir -p ~/.claude
cp /path/to/acm/CLAUDE.md ~/.claude/CLAUDE.md
```

### 2. Initialize a New Project

```bash
# Run the interactive init script
/path/to/acm/scripts/init-project.sh
```

The script will:
- Check/update your global CLAUDE.md
- Ask for project type (app, artifact, workflow)
- Ask for scale (personal, shared, community, commercial)
- Create project scaffolding with all required files

### 3. Start Discover Stage

```bash
cd your-project
# Edit docs/intent.md — define your North Star
# Work with agent to flesh out docs/discover-brief.md
```

---

## Specifications

### Core Specs

| Spec | Purpose |
|------|---------|
| [ADF-STAGES-SPEC](ADF-STAGES-SPEC.md) | Discover → Design → Develop → Deliver workflow |
| [ADF-PROJECT-TYPES-SPEC](ADF-PROJECT-TYPES-SPEC.md) | App / Artifact / Workflow types + modifiers |
| [ADF-TAXONOMY](ADF-TAXONOMY.md) | Terminology, classification, design decisions |

### Artifact Specs

| Spec | Purpose |
|------|---------|
| [ADF-INTENT-SPEC](ADF-INTENT-SPEC.md) | intent.md — the North Star |
| [ADF-BRIEF-SPEC](ADF-BRIEF-SPEC.md) | brief.md — detailed scope and criteria |
| [ADF-STATUS-SPEC](ADF-STATUS-SPEC.md) | status.md — session state tracking |
| [ADF-README-SPEC](ADF-README-SPEC.md) | README requirements and maintenance |

### Context Specs

| Spec | Purpose |
|------|---------|
| [ADF-GLOBAL-CLAUDE-MD-SPEC](ADF-GLOBAL-CLAUDE-MD-SPEC.md) | Global CLAUDE.md content |
| [ADF-PROJECT-CLAUDE-MD-SPEC](ADF-PROJECT-CLAUDE-MD-SPEC.md) | Project CLAUDE.md by type |
| [ADF-CONTEXT-ARTIFACT-SPEC](ADF-CONTEXT-ARTIFACT-SPEC.md) | Frontmatter schema, progressive disclosure |

### Stage Specs

| Spec | Purpose |
|------|---------|
| [ADF-DISCOVER-SPEC](ADF-DISCOVER-SPEC.md) | Discover stage workflow and requirements |
| [ADF-DESIGN-SPEC](ADF-DESIGN-SPEC.md) | Design stage workflow and requirements |
| [ADF-DEVELOP-SPEC](ADF-DEVELOP-SPEC.md) | Develop stage workflow and requirements |

### Structure Specs

| Spec | Purpose |
|------|---------|
| [ADF-FOLDER-STRUCTURE-SPEC](ADF-FOLDER-STRUCTURE-SPEC.md) | Base + type-specific folder structure |

---

## Core Concepts

### Three Project Types

| Type | Produces | Examples |
|------|----------|----------|
| **App** | Deployed software with users | Websites, APIs, mobile apps |
| **Artifact** | Single deliverable | Reports, presentations, spreadsheets |
| **Workflow** | Automation/orchestration | Pipelines, integrations, scheduled jobs |

### Four Scale Modifiers

| Scale | Description |
|-------|-------------|
| **personal** | Just you, private |
| **shared** | Family, friends, small group |
| **community** | Public, not monetized |
| **commercial** | Revenue intent, business requirements |

### Four Stages

| Stage | Question | Output |
|-------|----------|--------|
| **Discover** | What are we trying to accomplish? | intent.md, brief.md |
| **Design** | How will we approach it? | Architecture, tech decisions |
| **Develop** | Are we building it correctly? | The thing itself |
| **Deliver** | Is it done and usable? | Deployed/shipped deliverable |

### Core Artifacts

| Artifact | Purpose | Maintenance |
|----------|---------|-------------|
| `status.md` | Session state | Every session |
| `CLAUDE.md` | Context manifest | Stage changes |
| `intent.md` | North Star | Rarely |
| `brief.md` | Project contract | Discover stage |

---

## Project Structure

```
project/
├── .claude/
│   ├── CLAUDE.md          # Project context (auto-loaded)
│   └── rules/             # Governing rules
├── docs/
│   ├── intent.md          # North Star
│   ├── discover-brief.md  # Project contract
│   └── status.md          # Session state
├── .archive/              # Inactive artifacts
└── README.md              # Project overview
```

Type-specific additions:
- **App:** `src/`, `tests/`, `config/`
- **Artifact:** `assets/`, `output/`, `docs/research/`
- **Workflow:** `workflows/`, `scripts/`

---

## Agent Session Protocol

Every agent session:

1. **Start:** Read CLAUDE.md → Read status.md → Understand state
2. **Work:** Align to intent, stay in scope
3. **End:** Update status.md → Log what was done, next steps

See [AGENT-INSTRUCTIONS](AGENT-INSTRUCTIONS.md) for detailed guidance.

---

## Prompts

### Discover Stage

| Prompt | Purpose |
|--------|---------|
| [ralph-review-prompt](prompts/ralph-review-prompt.md) | Phase 1 internal review (Ralph Loop) |
| [external-review-prompt](prompts/external-review-prompt.md) | Phase 2 external review (GPT/Gemini) |

### Design Stage

| Prompt | Purpose |
|--------|---------|
| [start-design-prompt](prompts/start-design-prompt.md) | Stage transition — validates Discover, initiates Design |
| [design-intake-prompt](prompts/design-intake-prompt.md) | Structured clarification interview |
| [design-ralph-review-prompt](prompts/design-ralph-review-prompt.md) | Phase 1 internal review (Ralph Loop) |
| [design-external-review-prompt](prompts/design-external-review-prompt.md) | Phase 2 external review (GPT/Gemini) |
| [architecture-visual-design-stage](prompts/architecture-visual-design-stage.md) | Generate Design stage architecture diagram |

### Develop Stage

| Prompt | Purpose |
|--------|---------|
| [start-develop-prompt](prompts/start-develop-prompt.md) | Stage transition — validates Design, initiates Develop (includes intake validation) |
| [develop-ralph-review-prompt](prompts/develop-ralph-review-prompt.md) | Phase 1 internal review (Ralph Loop) |
| [develop-external-review-prompt](prompts/develop-external-review-prompt.md) | Phase 2 external review (GPT/Gemini) |
| [develop-artifact-correction-prompt](prompts/develop-artifact-correction-prompt.md) | One-off fix for planning artifacts (capabilities.md, tasks.md) |

---

## Scripts

| Script | Purpose |
|--------|---------|
| [init-project.sh](scripts/init-project.sh) | Initialize new project with ACM scaffolding |

---

## Stubs

Minimal starter files used by init-project.sh. See [stubs/README](stubs/README.md).

---

## Knowledge Base

Research and learnings captured for reuse:

| Entry | Purpose |
|-------|---------|
| [DOCUMENT-BREAKOUT-THRESHOLD](kb/DOCUMENT-BREAKOUT-THRESHOLD.md) | 500-line threshold for document splitting |
| [REVIEW-CYCLE-GUIDANCE](kb/REVIEW-CYCLE-GUIDANCE.md) | Stop at diminishing returns — cycle count guidance |

---

## References

- [AGENT-INSTRUCTIONS](AGENT-INSTRUCTIONS.md) — Detailed agent guidance
- [ADF-TAXONOMY](ADF-TAXONOMY.md) — All terminology and design decisions
