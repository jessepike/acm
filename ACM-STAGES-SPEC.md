---
type: "specification"
description: "Defines the ACM stage workflow model and meta layer"
version: "1.1.0"
updated: "2026-01-27"
scope: "acm"
lifecycle: "reference"
location: "acm/ACM-STAGES-SPEC.md"
---

# ACM Stages Specification

## Purpose

Define the minimal stage workflow for agentic projects — applicable to software development, presentations, reports, or any structured work.

## Model Overview

```
┌─────────────────────────────────────────────────────┐
│  META LAYER (Ambient Capabilities)                  │
│  Skills, Tools, Templates, Rules, Prompts           │
│                                                     │
│  ┌──────────┐  ┌────────┐  ┌─────────┐  ┌─────────┐│
│  │ Discover │→ │ Design │→ │ Develop │→ │ Deliver ││
│  └──────────┘  └────────┘  └─────────┘  └─────────┘│
│       ↑            ↑            ↑            ↑     │
│       └────────────┴────────────┴────────────┘     │
│                 Pull from shelf                    │
└─────────────────────────────────────────────────────┘
```

---

## Meta Layer

The ambient capability set that wraps around all stages. Stages pull what they need on demand.

### Contents
- **Skills** — Reusable capabilities (research, review, creation)
- **Tools** — External systems and utilities
- **Specs** — Artifact structure definitions (brief, intent, etc.)
- **Rules** — Governing constraints (from Global CLAUDE.md)
- **Prompts** — Pre-built prompts for common operations

### Meta Layer Manager: acm-env

The **acm-env** plugin (`~/.claude/plugins/acm-env/`) is the management layer for the meta layer itself. It ensures skills, tools, rules, and context artifacts are properly configured, available, current, and not stale. See `ACM-ENV-SPEC.md`.

### Cross-Stage Artifacts

Some artifacts persist across all stages:

| Artifact | Purpose | Behavior |
|----------|---------|----------|
| `intent.md` | North Star — why we're doing this | Created in Discover, stable thereafter |
| `status.md` | Session state — where we left off | Updated every session, all stages |
| `CLAUDE.md` | Context manifest — what to load | Evolves with project, references status.md |

**Agent Session Protocol:**
1. Session start: Read CLAUDE.md → Read status.md → Understand state
2. Session end: Update status.md → Capture what was done, next steps

### Project Init (Boot Sequence)

Happens once at project inception, before Discover begins.

**Human actions:**
- Create project folder
- Identify project type (software, presentation, report, workflow, etc.)
- Identify initial tools/capabilities needed

**Scaffolding created:**
- Folder structure appropriate to project type
- Project CLAUDE.md (minimal stub with Context Map)
- `intent.md` stub (ready for Discover)
- `status.md` (initial session state)

---

## Stages

### DISCOVER

> **"What are we trying to accomplish?"**

| Aspect | Description |
|--------|-------------|
| **Inputs** | Initial concept, constraints, domain context |
| **Setup needs** | Validation prompts, research tools |
| **Outputs** | `intent.md`, `brief.md` |
| **Exit criteria** | Intent is crystal clear; success criteria defined |

**Intent.md is the #1 artifact.** All agents, all humans, all stages must align to intent.

---

### DESIGN

> **"How will we approach it?"**

| Aspect | Description |
|--------|-------------|
| **Inputs** | `intent.md`, `brief.md` |
| **Setup needs** | Decision frameworks, reference materials |
| **Outputs** | Approach decisions (tools, structure, dependencies) |
| **Exit criteria** | We know what we're building and how |

**Note:** "Approach" is project-type dependent:
- Software → architecture, stack, data model
- Presentation → outline, visual style, tool choice
- Report → structure, sources, format

---

### DEVELOP

> **"Are we building it correctly?"**

| Aspect | Description |
|--------|-------------|
| **Inputs** | Design decisions, `intent.md` (reference) |
| **Setup needs** | Environment, tools, detailed plan/tasks |
| **Outputs** | The thing itself (code, doc, deck, etc.) |
| **Exit criteria** | Following good practices; making progress toward intent |

**Not just software.** Develop = executing the work, whatever form it takes.

---

### DELIVER

> **"Is this increment done and usable?"**

| Aspect | Description |
|--------|-------------|
| **Inputs** | Built artifact |
| **Setup needs** | Deployment/distribution config, documentation |
| **Outputs** | Usable, accessible deliverable |
| **Exit criteria** | User can access/use it; MVP loop closes |

**Milestone-based.** Deliver marks completion of an increment, not necessarily end of project.

---

## Stage Transitions

Each transition may require stage-specific setup:

| Transition | Setup Activity |
|------------|----------------|
| Init → Discover | Scaffold folders, load rules, prep validation prompts |
| Discover → Design | Verify intent clarity, prep decision frameworks |
| Design → Develop | Environment ready, tools installed, plan created |
| Develop → Deliver | Deployment config, handoff prep, documentation |

---

## Design Principles

**Inclusive, not prescriptive:** Stages apply to any project type, not just software.

**Intent-aligned:** Every stage references back to `intent.md` as the source of truth.

**Pull-based:** Capabilities exist in the meta layer; stages pull what they need.

**Minimal gates:** Exit criteria are clarity checks, not bureaucratic approvals.

---

## References

- ACM-GLOBAL-PRIMITIVES-v0.1.md
- ACM-GLOBAL-CLAUDE-MD-SPEC.md
