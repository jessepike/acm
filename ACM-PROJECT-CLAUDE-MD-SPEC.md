---
type: "specification"
description: "Defines content and purpose of Project-level CLAUDE.md"
version: "1.1.0"
updated: "2026-01-27"
scope: "acm"
lifecycle: "reference"
location: "acm/ACM-PROJECT-CLAUDE-MD-SPEC.md"
---

# ACM Project CLAUDE.md Specification

## Purpose

Define what belongs in `.claude/CLAUDE.md` — the project-level context that supplements global guardrails with project-specific guidance.

## Relationship to Global

| Level | Contains | Stability |
|-------|----------|-----------|
| Global (`~/.claude/CLAUDE.md`) | Universal guardrails | Static |
| Project (`.claude/CLAUDE.md`) | Project-specific context | Evolves with project |

Global = safety rails that never change.
Project = context that helps agents work effectively on THIS project.

---

## Content by Project Type

### Base Content (All Types)

Every project CLAUDE.md includes:

```markdown
# [Project Name]

## Intent
[1-2 sentences summarizing intent — or link to docs/intent.md]

## Type
[Software | Artifact | Workflow]

## Current Stage
[Discover | Design | Develop | Deliver]

## Key Files
- Intent: `docs/intent.md`
- Brief: `docs/discover-brief.md`
- [Type-specific key files]

## Context Map

| File | Load When | Purpose |
|------|-----------|---------|
| docs/intent.md | Always | North Star |
| docs/status.md | Always | Session state — review at start, update at end |
| docs/discover-brief.md | Discover, Design | Project contract |
| docs/design-architecture.md | Design, Develop | Technical approach |
| [stage-specific files] | [stage] | [purpose] |

## Agent Session Protocol

1. **Session Start:** Read status.md first. Understand current state, last session, next steps.
2. **Session End:** Update status.md before closing. Log what was done, update next steps.
```

---

### Software Projects

Additional sections:

```markdown
## Stack
- Language: [e.g., Python 3.12]
- Framework: [e.g., FastAPI]
- Database: [e.g., PostgreSQL]

## Commands
- Setup: `make setup`
- Dev: `make dev`
- Test: `make test`
- Lint: `make lint`
- Build: `make build`

## Architecture
- Source: `src/`
- Tests: `tests/`
- Config: `config/`

## Gotchas
- [Project-specific pitfalls]
```

---

### Artifact Projects

Additional sections:

```markdown
## Output
- Format: [e.g., PPTX, PDF, XLSX]
- Location: `output/`
- Tool: [e.g., Google Slides, PowerPoint]

## Sources
- Research: `docs/research/`
- Assets: `assets/`

## Style
- [Tone, formatting, branding notes]
```

---

### Workflow Projects

Additional sections:

```markdown
## Workflow Type
[Deterministic | Probabilistic/Agentic]

## Trigger
[Manual | Scheduled | Event-driven]

## Integrations
- [System/API 1]
- [System/API 2]

## Runbooks
- Location: `docs/runbooks/`
```

---

## Static vs Dynamic Sections

Use HTML comments to mark sections:

```markdown
<!-- ====== STATIC SECTION (preserve on prune) ====== -->

## Stack
...

## Commands
...

<!-- ====== DYNAMIC SECTION (prune regularly) ====== -->

## Current Focus
- Active task: [description]
- Working in: [directories]

## Recent Activity
- [Recent commits, decisions, blockers]
```

| Section | Content | Prune Behavior |
|---------|---------|----------------|
| Static | Stack, commands, architecture, gotchas | Preserve |
| Dynamic | Current focus, recent activity | Prune regularly |

---

## Lifecycle

| Stage | CLAUDE.md State |
|-------|-----------------|
| Project Init | Stub created (type, intent reference) |
| Discover | Intent and type confirmed |
| Design | Stack/output/workflow details added |
| Develop | Commands, architecture, gotchas filled in |
| Ongoing | Dynamic sections updated, static preserved |

---

## Governance

| Aspect | Rule |
|--------|------|
| Location | `.claude/CLAUDE.md` |
| Who modifies | Agent (dynamic sections), Human (static sections) |
| Prune frequency | When dynamic section exceeds ~20 lines |
| Target size | 30-50 lines (excluding comments) |

---

## Rules Directory

`.claude/rules/` contains human-controlled governing rules:

```
.claude/
├── CLAUDE.md              # Project context (agent-writable)
└── rules/                 # Governing rules (human-controlled)
    ├── architecture.md    # Structural decisions
    ├── stack.md           # Technology-specific rules
    └── domain.md          # Domain terminology, business rules
```

**Key distinction:**
- `CLAUDE.md` = context that evolves
- `rules/` = constraints that persist

---

## Context Map Pattern

The Context Map tells agents what files to load based on current stage. This enables progressive disclosure — agents load only what's needed.

**Structure:**

```markdown
## Context Map

| File | Load When | Purpose |
|------|-----------|---------|
| docs/intent.md | Always | North Star |
| docs/discover-brief.md | Discover, Design | Project contract |
| docs/design-architecture.md | Design, Develop | Technical approach |
```

**Load When values:**
- `Always` — Load into every agent context
- `[Stage name]` — Load when working in that stage
- `[Stage], [Stage]` — Load when working in either stage
- `On demand` — Reference when needed, don't pre-load

**Principle:** CLAUDE.md is the manifest. Agent reads it first, knows what else to load.

---

## Validation Criteria

A well-formed project CLAUDE.md:

- [ ] States project type and classification
- [ ] References intent.md
- [ ] Includes Context Map
- [ ] Includes type-appropriate sections
- [ ] Has static/dynamic markers (if dynamic content exists)
- [ ] Under 50 lines (or prune needed)
- [ ] Commands are accurate and runnable (Software)

---

## Templates

### Minimal Stub (Project Init)

```markdown
# [Project Name]

## Intent
See `docs/intent.md`

## Classification
- **Type:** [Artifact | App | Workflow]
- **Scale:** [personal | shared | community | commercial]
- **Scope:** [mvp | full-build]
- **Complexity:** [standalone | multi-component]

## Current Stage
Discover

## Context Map

| File | Load When | Purpose |
|------|-----------|---------|
| docs/intent.md | Always | North Star |
| docs/discover-brief.md | Discover | Working Brief |
```

### Software Template

See: TIER1_KIT_SPEC.md for full template

### Artifact Template

```markdown
# [Project Name]

## Intent
[1-2 sentences]

## Type
Artifact

## Output
- Format: [format]
- Location: `output/`

## Current Stage
[stage]
```

### Workflow Template

```markdown
# [Project Name]

## Intent
[1-2 sentences]

## Type
Workflow

## Workflow Type
[Deterministic | Probabilistic]

## Current Stage
[stage]
```

---

## References

- ACM-GLOBAL-CLAUDE-MD-SPEC.md (global counterpart)
- ACM-PROJECT-TYPES-SPEC.md (type determines content)
- ACM-FOLDER-STRUCTURE-SPEC.md (location in structure)
- TIER1_KIT_SPEC.md (detailed templates)
