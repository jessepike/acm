---
type: "prompt"
description: "Prompt for generating full ACM vision architecture diagram"
version: "1.2.0"
updated: "2026-01-25"
lifecycle: "reference"
location: "prompts/architecture-visual-full-vision.md"
---

# Prompt: ACM Full Vision Architecture Diagram

Use this prompt with an image generation tool or diagramming AI to create an architectural visualization of the complete ACM vision.

---

## Prompt

Create a clean, modern software architecture diagram for "ACM — Agentic Context Management" showing the complete system vision.

**Layout:** Layered architecture, top-to-bottom

---

### 1. Meta Layer (Top)

- Label: "Meta Layer (Ambient Capabilities)"
- Contains: Skills, Tools, Templates, Rules, Prompts
- Visual: Horizontal bar across top, wraps conceptually around everything
- Note: "Pull from shelf as needed"

---

### 2. Context Layer — Tier-1 Memory (Below Meta Layer)

Two components side by side:

- **Global CLAUDE.md** (`~/.claude/CLAUDE.md`)
  - Label: "Universal guardrails, always loaded"

- **Project CLAUDE.md** (`.claude/CLAUDE.md`)
  - Label: "Project-specific context"

Box label: "Context Layer (Tier-1 Memory)"

Both feed DOWN into the Stage Workflow.

---

### 3. Intent.md — North Star (Prominent, Overarching)

- **Position:** Above or spanning the ENTIRE Stage Workflow — NOT just feeding into Design
- Visual: Most prominent artifact, use star icon, green color
- Label: "intent.md — North Star"
- **CRITICAL:** Show arrows feeding into Design, Develop, AND Deliver
- Note: "Referenced throughout — especially in Develop where agents do most work"

---

### 4. Brief.md — Scope

- Position: Feeds into Design stage ONLY
- Label: "brief.md — Scope and success criteria"
- Arrow: brief.md → Design (Design then flows to Develop)
- Note: "Influences Develop through Design, not directly"

---

### 5. Stage Workflow (Center)

Four connected stages in sequence:

```
Discover → Design → Develop → Deliver
```

Each stage shows its key question:
- Discover: "What are we trying to accomplish?"
- Design: "How will we approach it?"
- Develop: "Build the solution & validate"
- Deliver: "Release & gather feedback"

**Loopback:** Show arrow from Deliver back to Discover. Label: "Stages can loop back"

**IMPORTANT:** The entire workflow produces outcomes. Individual stages do NOT flow directly into specific Project Types.

---

### 6. Outcomes / Deliverables (Below Stage Workflow)

- Label: "Outcomes / Deliverables"
- The ENTIRE Stage Workflow flows into this box
- Inside, show Project Types as variants:
  - Software
  - Artifact
  - Workflow
- Note: "Project Type determines shape of deliverable"

**DO NOT:** Draw arrows from Develop → Software or Deliver → Workflow. The whole cycle produces outcomes.

---

### 7. Artifact Lifecycle (Bottom Left)

Separate section showing lifecycle classes:

- **Deliverable** (`src/`, `output/`, `workflows/`) — "Never auto-prune"
- **Reference** (`docs/`) — "Archive when obsolete"
- **Inbox** (`docs/inbox/`) — "Triage zone, process promptly"
- **Archive** (`_archive/`) — "Preserved but inactive (NOT ephemeral)"

Show flow: Reference → Archive (when obsolete)
Show flow: Inbox → Reference or Delete (after triage)

**IMPORTANT:** Inbox and Archive are SEPARATE concepts with different purposes.

---

### 8. Validators (Right Side)

- Label: "Validators (acm-validate)"
- Description: "Validates against artifact specs"
- What it checks:
  - Frontmatter compliance
  - Progressive disclosure structure
  - Token optimization
  - Minimal viable context
- Connects to: Artifacts and Stage Workflow

**DO NOT** say "checks frontmatter" alone — it validates against the full artifact spec.

---

### 9. Maintenance (Right Side, Below Validators)

- Label: "Maintenance (acm-prune)"
- Description: "Cleans context, processes inbox, manages archive"
- Connects to: Artifact Lifecycle

---

### 10. Self-Improvement Loop (Right Side)

- Arrow originates from **Deliver stage** (or the entire Stage Workflow box)
- Flows back UP to Meta Layer
- Label: "Learnings feed back into capabilities"

**CRITICAL:** Arrow must clearly come from Deliver/workflow completion, NOT from Design or Validators.

---

### Folder Structure (Small Inset, Left Side)

```
project/
├── .claude/
│   ├── CLAUDE.md
│   └── rules/
├── docs/
│   ├── intent.md
│   ├── brief.md
│   └── inbox/
├── _archive/
└── [type-specific]/
    ├── src/
    ├── output/
    └── workflows/
```

---

## Visual Style

- Clean, minimal, professional
- Color coding:
  - Blue for stages
  - Green for intent.md and brief.md (use star icons)
  - Light blue for CLAUDE.md files / Context Layer
  - Orange for Validators/Maintenance
  - Gray for Meta Layer
  - Muted tones for Artifact Lifecycle
- White or light background
- Clear arrows showing flow direction
- Document icons for artifacts

---

## Common Mistakes to Avoid

1. **Intent.md scope:** Do NOT show intent only feeding Design. It's the North Star for the ENTIRE workflow, especially Develop.

2. **Brief.md path:** Brief feeds Design only. Develop references it through Design, not directly.

3. **Project Types flow:** Do NOT draw Develop → Software or Deliver → Workflow. The whole workflow produces outcomes; Project Type shapes them.

4. **Self-improvement origin:** Arrow comes from Deliver/workflow completion, NOT from Design or Validators.

5. **Inbox vs Archive:** These are SEPARATE. Inbox = triage. Archive = preservation. Do not group as "ephemeral."

6. **Validators description:** They validate against artifact specs (frontmatter, progressive disclosure, token optimization, minimal viable context) — not just "structure and frontmatter."

---

**Title:** "ACM — Agentic Context Management: Full Architecture"

**Subtitle:** "Managed workflows for agentic software development"
