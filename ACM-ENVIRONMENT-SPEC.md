---
type: "specification"
description: "Defines the ACM environment layer — the cross-cutting infrastructure that wraps around all projects and stages"
version: "1.0.0"
updated: "2026-01-29"
scope: "acm"
lifecycle: "reference"
location: "acm/ACM-ENVIRONMENT-SPEC.md"
---

# ACM Environment Layer Specification

## Purpose

Define the environment layer — the persistent, cross-cutting infrastructure that wraps around all projects and all stages. The environment layer sets the conditions for agentic work to succeed.

---

## Two-Layer Model

ACM operates as two distinct layers:

### Project Layer (the stages)

Discover → Design → Develop → Deliver. Project-scoped. Has a beginning and an end. Produces a deliverable. Every project gets this.

### Environment Layer (the wrapper)

Persists across projects. Applies to all work, all project types. Maintains itself over time. Doesn't have a beginning or end — it's always running, always learning, always maintaining.

The stages live *inside* the environment. The environment sets the conditions for the stages to succeed.

```
┌──────────────────────────────────────────────────────────┐
│                   ENVIRONMENT LAYER                       │
│                                                           │
│  ┌───────────────┐  ┌──────────────┐  ┌───────────────┐  │
│  │ Orchestration │  │ Capabilities │  │   Knowledge   │  │
│  │               │  │  (Registry)  │  │     (KB)      │  │
│  └───────────────┘  └──────────────┘  └───────────────┘  │
│                                                           │
│  ┌───────────────┐  ┌──────────────┐  ┌───────────────┐  │
│  │    Memory     │  │ Maintenance  │  │  Validation   │  │
│  │               │  │              │  │               │  │
│  └───────────────┘  └──────────────┘  └───────────────┘  │
│                                                           │
│  ┌────────────────────────────────────────────────────┐   │
│  │  ┌──────────┐ ┌────────┐ ┌─────────┐ ┌─────────┐  │   │
│  │  │ Discover │→│ Design │→│ Develop │→│ Deliver │  │   │
│  │  └──────────┘ └────────┘ └─────────┘ └─────────┘  │   │
│  │                PROJECT LAYER                        │   │
│  └────────────────────────────────────────────────────┘   │
│                                                           │
└──────────────────────────────────────────────────────────┘
```

---

## Six Primitives

The environment layer comprises six distinct concerns:

| Primitive | Purpose | Question It Answers |
|-----------|---------|---------------------|
| **Orchestration** | Stage workflow, gates, phase boundaries, context management | "What's the process?" |
| **Capabilities** | Registry of skills, tools, agents available for use | "What can I use?" |
| **Knowledge** | Curated learnings, patterns, best practices (growing over time) | "What do we know?" |
| **Memory** | Session persistence, cross-agent state, project history | "What happened?" |
| **Maintenance** | Freshness checks, updates, health monitoring | "Is everything current?" |
| **Validation** | Drift detection, spec compliance, health checks | "Is everything correct?" |

These are not sequential — they are ambient. They are always available, and the stages pull from them as needed.

---

## Primitive Details

### 1. Orchestration

**Owns:** Stage workflow, phase models, gates, prompts, context management rules.

**Implemented by:** ACM specs and prompts. The process definitions that govern how stages work.

**Key behaviors:**
- Defines stage entry/exit criteria
- Enforces phase boundaries (hard gates, context clearing)
- Provides prompts for stage transitions and reviews
- Manages context loading rules (progressive disclosure)

**Location:** `~/code/_shared/acm/` — specs, prompts, stubs.

---

### 2. Capabilities

**Owns:** Inventory of skills, tools, and agents available for use across projects.

**Implemented by:** Capability Registry — a standalone, self-maintaining catalog.

**Key behaviors:**
- Catalogs available skills, tools, and agents
- Tracks status lifecycle: staging → active → archive
- Provides agent-queryable inventory (by category, by tags)
- Syncs from upstream sources (Anthropic official, curated community)

**Location:** `~/code/_shared/capabilities-registry/` — own repo, own spec.

**Three capability types:**

| Type | Definition | Examples |
|------|------------|---------|
| **Skill** | Procedural knowledge — a SKILL.md with instructions and supporting files | frontend-design, webapp-testing, pdf |
| **Tool** | MCP servers or deterministic scripts that provide functional extensions | memory-mcp, filesystem-mcp |
| **Agent** | Sub-agent definitions with specialized domain expertise | supabase-expert, ui-reviewer |

**Organization:** By capability name, not by vendor. Vendor/source is metadata (`.meta.yaml` tags), not folder structure. Agents query by need: "Do I have Astro skills? What Supabase capabilities are available?"

**Relationship to stages:** Develop Phase 2 (Capability Assessment) reads the registry inventory and matches project needs to available capabilities.

---

### 3. Knowledge

**Owns:** Curated learnings, validated patterns, reusable best practices.

**Implemented by:** Knowledge base within ACM (`acm/kb/`).

**Key behaviors:**
- Stores distilled, evergreen findings
- Referenced by agents during stage work ("Based on similar projects...")
- Grows from project experience, community sources, and research
- Each entry follows a structured format: summary, finding, rationale, application

**Location:** `~/code/_shared/acm/kb/` — within ACM for now. Tightly coupled to process learnings.

**Characteristics:**
- Curated, not raw — every entry is validated and distilled
- Evergreen — entries are true over time, not tied to a single project
- Read-heavy — consumed frequently, updated occasionally
- Human-approved — entries are reviewed before addition

**Future consideration:** May extract to own repo if growth warrants separation from ACM process specs.

---

### 4. Memory

**Owns:** Session state, cross-agent continuity, project history, raw experience data.

**Implemented by:** Memory layer — a standalone repo for persistent state.

**Key behaviors:**
- Stores session logs and decisions
- Enables cross-session continuity (agent picks up where last session left off)
- Accumulates raw experience data that feeds knowledge distillation
- Provides per-project memory and cross-project memory

**Location:** `~/code/_shared/memory/` — own repo.

**Characteristics:**
- Raw and temporal — captured as things happen
- Write-heavy — every session contributes
- Agent-written, human-reviewable
- Feeds the self-improvement loop (memory → distill → knowledge)

**Knowledge vs Memory:**

| Aspect | Knowledge | Memory |
|--------|-----------|--------|
| Content | Distilled, curated, evergreen | Raw, temporal, session-specific |
| Lifecycle | Grows slowly, rarely changes | Grows fast, append-only |
| Access | Read-heavy | Write-heavy |
| Example | "500-line breakout threshold for docs" | "Session 3: decided to use RSC over client components because of X" |

---

### 5. Maintenance

**Owns:** Freshness monitoring, update checks, health dashboards.

**Implemented by:** Each component owns its own maintenance behaviors. Skills and scripts within each repo handle their own health.

**Key behaviors:**
- Registry: sync from upstream, check for stale capabilities
- ACM: validate spec versions, check for outdated prompts
- Memory: cleanup old sessions, enforce retention policies
- Cross-component: environment health dashboard (acm-env plugin)

**Principle:** Each component self-maintains. No central maintenance service. Components may expose health endpoints that a dashboard aggregates.

**Location:** Distributed — maintenance scripts live within each component's `scripts/` directory.

---

### 6. Validation

**Owns:** Drift detection, spec compliance, correctness checks.

**Implemented by:** Skills that run checks against specs. Validation is a behavior, not a component.

**Key behaviors:**
- Project health checks: "Is this project aligned with its intent?"
- Spec compliance: "Does this artifact match its spec requirements?"
- Drift detection: "Has the project diverged from its design?"
- Environment checks: "Is the environment baseline met?" (acm-env)

**Principle:** Every spec is implicitly a validation contract. Validation skills read specs, read project state, and report alignment or drift.

**Location:** Distributed — validation skills live within the components whose specs they enforce.

---

## Progressive Narrowing

The environment feeds stages differently as projects gain clarity:

**Early (Discover):**
- Orchestration: "You're in Discover. Here's the workflow."
- Knowledge: "Here's what we've learned from similar projects."
- Capabilities: Minimal relevance — research tools only.

**Mid (Design):**
- Knowledge: "Last time with this stack, here's what we learned."
- Capabilities: "Here's what's available for the stack you're choosing."
- Validation: "Your design aligns with your brief."

**Late (Develop):**
- Capabilities: "Here are the exact skills, tools, agents for this project."
- Orchestration: "Phase boundary. Clear context. Re-read artifacts."
- Validation: "Drift check — still aligned with intent."
- Memory: "Previous sessions decided X, Y, Z."

**Ongoing (across all stages):**
- Maintenance: "3 capabilities have upstream updates."
- Knowledge: "Capture this learning for next time."
- Validation: "Project health check — specs current, no drift."
- Memory: "Log this session's decisions and outcomes."

---

## Physical Layout

```
~/code/_shared/
├── acm/                          # Orchestration + Knowledge
│   ├── ACM-*-SPEC.md             # Process specs (orchestration contracts)
│   ├── ACM-ENVIRONMENT-SPEC.md   # This spec (architecture vision)
│   ├── prompts/                  # Stage prompts
│   ├── kb/                       # Knowledge base (curated learnings)
│   ├── scripts/                  # Init, orchestration scripts
│   └── stubs/                    # Project scaffolding
│
├── capabilities-registry/          # Capabilities
│   ├── capabilities/             # skills/, tools/, agents/
│   ├── staging/                  # Not yet promoted
│   ├── archive/                  # Deprecated versions
│   ├── scripts/                  # Sync, freshness, promote
│   ├── REGISTRY-SPEC.md          # Self-documenting spec
│   ├── inventory.json            # Source of truth (machine-readable)
│   └── INVENTORY.md              # Generated from JSON (agent-queryable)
│
└── memory/                       # Memory
    ├── sessions/                 # Raw session logs
    ├── projects/                 # Per-project memory
    ├── scripts/                  # Distillation, cleanup
    └── MEMORY-SPEC.md            # How memory works
```

**Maintenance** and **Validation** are distributed — each component owns its own maintenance scripts and validation skills. They don't have separate repos.

---

## Component Relationships

```
acm (orchestration) ──references──→ capabilities-registry (capabilities)
acm (orchestration) ──contains───→ kb/ (knowledge)
acm (orchestration) ──references──→ memory (session state)

capabilities-registry ──self-maintains──→ (sync, freshness)
memory ──feeds──→ kb/ (distillation: raw memory → curated knowledge)

validation (skills) ──reads──→ acm specs (contracts to validate against)
maintenance (scripts) ──lives in──→ each component
```

**Coupling rules:**
- ACM references registry and memory but doesn't manage them
- Registry and memory don't know about each other
- Registry doesn't know about ACM — it's consumed, not coupled
- Each component is self-contained and self-maintaining
- Components point to each other but don't own each other

---

## Self-Improvement Loop

The environment layer enables continuous improvement across projects:

1. **Capture** — During projects, agents log decisions, friction, learnings to memory
2. **Distill** — Periodically, a skill processes raw memory into KB entries or spec update proposals
3. **Apply** — When starting new work, agents read KB and benefit from accumulated experience
4. **Validate** — Ongoing checks ensure specs, capabilities, and knowledge stay current and aligned

This loop is the mechanism by which the system gets better over time. It is not a stage — it is ambient behavior of the environment layer.

---

## Relationship to Existing Specs

| Spec | Relationship |
|------|-------------|
| ACM-ENV-PLUGIN-SPEC.md | Narrower — defines the acm-env plugin specifically. This spec supersedes it architecturally. |
| ACM-STAGES-SPEC.md | Defines the project layer. This spec defines the environment layer that wraps it. |
| ACM-TAXONOMY.md | Terminology. Environment terms section should be updated to reflect six primitives. |
| REGISTRY-SPEC.md | To be created — self-documenting spec for the capability registry. |
| MEMORY-SPEC.md | To be created — defines how memory works. |

---

## Design Principles

- **Modular and self-contained** — each component has its own repo, spec, and maintenance
- **Loosely coupled** — components reference each other but don't manage each other
- **Self-maintaining** — each component owns its own freshness and health
- **Goldilocks complexity** — simple but effective; avoid over-engineering
- **Progressive narrowing** — broad early, specific as projects gain clarity
- **Specs as contracts** — every spec is implicitly a validation contract

---

## References

- ACM-STAGES-SPEC.md (project layer)
- ACM-ENV-PLUGIN-SPEC.md (acm-env plugin — narrower scope)
- ACM-TAXONOMY.md (terminology)
