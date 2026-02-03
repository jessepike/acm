---
type: "specification"
description: "Defines the ADF stage workflow model and environment layer"
version: "1.2.0"
updated: "2026-02-01"
scope: "adf"
lifecycle: "reference"
location: "adf/ADF-STAGES-SPEC.md"
---

# ADF Stages Specification

## Purpose

Define the minimal stage workflow for agentic projects — applicable to software development, presentations, reports, or any structured work.

## Model Overview

```
┌─────────────────────────────────────────────────────┐
│  ENVIRONMENT LAYER (Ambient Capabilities)            │
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

## Environment Layer

The persistent, cross-cutting infrastructure that wraps around all stages. Stages pull what they need on demand. See `ADF-ARCHITECTURE-SPEC.md` for full architecture.

### Contents
- **Skills** — Reusable capabilities (research, review, creation)
- **Tools** — External systems and utilities
- **Specs** — Artifact structure definitions (brief, intent, etc.)
- **Rules** — Governing constraints (from Global CLAUDE.md)
- **Prompts** — Pre-built prompts for common operations

### Environment Layer Interfaces

- **acm-env plugin** — Environment *management*: configuration, baseline validation, hooks, plugin/capability administration. See `ADF-ENV-PLUGIN-SPEC.md`.
- **ACM MCP server** — Environment *knowledge*: queryable access to specs, prompts, stubs, project validation, capability queries. Consumed by agents in any project via `.mcp.json`.

### Cross-Stage Artifacts

Some artifacts persist across all stages:

| Artifact | Purpose | Behavior |
|----------|---------|----------|
| `intent.md` | North Star — why we're doing this | Created in Discover, stable thereafter |
| `status.md` | Session state — where we left off | Updated every session, all stages |
| `CLAUDE.md` | Context manifest — what to load | Evolves with project, references status.md |
| `docs/adf/` | Stage planning workspace | Created in Develop, archived at stage completion |

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

## Artifact Lifecycle

Each stage produces artifacts that fall into three categories:

| Category | Definition | Behavior at Stage Transition |
|----------|------------|------------------------------|
| **Deliverable** | Final outputs that carry forward | Remain active in project context |
| **Working** | Ephemeral artifacts created during exploration/iteration | Archive to `_archive/` |
| **Reference** | Supporting materials that remain useful | Remain active in `docs/` |

### Artifact Lifecycle by Stage

| Stage | Deliverables (Keep Active) | Working Artifacts (Archive) |
|-------|---------------------------|----------------------------|
| **Discover** | `intent.md`, `brief.md` | Concept briefs, discovery briefs, research spikes |
| **Design** | `design.md`, `BACKLOG.md`, decision records | Draft designs, spike reports, exploration notes |
| **Develop** | Implementation (code/artifacts), tests | Planning documents from `docs/adf/` |
| **Deliver** | Deployment artifacts, handoff docs | Deployment notes, validation reports |

### Stage Transition Cleanup Protocol

When transitioning between stages:

1. **Identify deliverables** — verify these artifacts are final and complete
2. **Archive working artifacts** — move to `_archive/` with naming: `_archive/YYYY-MM-DD-<artifact-name>.md`
3. **Verify active context** — only deliverable and reference artifacts remain accessible
4. **Update status.md** — document what was archived and why

See `.claude/rules/archive.md` for archive access rules.

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

Each transition requires the completing stage to execute the **Stage Boundary Handoff Protocol** (below), plus stage-specific setup:

| Transition | Setup Activity |
|------------|----------------|
| Init → Discover | Scaffold folders, load rules, prep validation prompts |
| Discover → Design | Handoff protocol, verify intent clarity, prep decision frameworks |
| Design → Develop | Handoff protocol, environment ready, tools installed, plan created |
| Develop → Deliver | Handoff protocol, deployment config, documentation |

---

## Universal Exit Criteria

Every stage must satisfy these before transitioning. Stage-specific exit criteria (defined in each stage spec) layer on top.

- [ ] Primary deliverable(s) exist with required content
- [ ] No Critical or High issues open (post-review)
- [ ] Alignment verified with intent.md and brief.md
- [ ] All work committed (atomic commits, no uncommitted changes)
- [ ] Documentation appropriate to deliverable exists
- [ ] Workspace cleanup complete (no transients, .gitignore current)
- [ ] status.md updated with stage completion (THE SEAL — last step)
- [ ] Human sign-off obtained

---

## Stage Boundary Handoff Protocol

When transitioning between stages, the completing agent:

1. Completes all stage-specific exit criteria
2. **Executes Stage Transition Cleanup Protocol** (see Artifact Lifecycle above)
   - Archive working artifacts to `_archive/`
   - Verify only deliverables and reference artifacts remain active
3. Updates status.md with structured stage handoff:
   - **What was produced** — deliverable summary + key files
   - **What was archived** — list of archived artifacts and rationale
   - **Success criteria status** — from brief.md
   - **Known limitations / deferred items**
   - **Read order for next stage agent**
4. Commits with `chore({stage}): stage complete — {summary}`
5. Runs `/clear`

The next stage agent starts by reading `CLAUDE.md` → `status.md` (which contains the handoff).

---

## Design Principles

**Inclusive, not prescriptive:** Stages apply to any project type, not just software.

**Intent-aligned:** Every stage references back to `intent.md` as the source of truth.

**Pull-based:** Capabilities exist in the environment layer; stages pull what they need.

**Minimal gates:** Exit criteria are clarity checks, not bureaucratic approvals.

---

## References

- ADF-GLOBAL-PRIMITIVES-v0.1.md
- ADF-GLOBAL-CLAUDE-MD-SPEC.md
