---
type: "specification"
description: "Master framework specification — defines ADF's architecture, stage pipeline, artifact flow, six environment primitives, interface map, and spec index. The single entry point for understanding ADF."
version: "2.0.1"
updated: "2026-02-01"
scope: "adf"
lifecycle: "reference"
location: "adf/ADF-ARCHITECTURE-SPEC.md"
---

# ADF Architecture Specification

## Purpose

This is the **master framework specification** for ADF (Agentic Development Framework). It is the single entry point for understanding how ADF works — the two-layer model, the six environment primitives, the stage pipeline, artifact flow, interface map, and the complete spec index.

All other ADF specs define narrower slices. This spec defines the whole.

---

## How to Read ACM

| Want to understand... | Read |
|---|---|
| The whole framework | This spec (ADF-ARCHITECTURE-SPEC.md) |
| Stage workflow model | ADF-STAGES-SPEC.md |
| A specific stage | ADF-DISCOVER-SPEC / DESIGN-SPEC / DEVELOP-SPEC |
| Project classification | ADF-PROJECT-TYPES-SPEC.md |
| Artifact formats | ADF-BRIEF-SPEC / INTENT-SPEC / STATUS-SPEC / README-SPEC |
| Review process | ADF-REVIEW-SPEC.md |
| Rules governance | ADF-RULES-SPEC.md |
| Context artifacts | ADF-CONTEXT-ARTIFACT-SPEC.md / GLOBAL-CLAUDE-MD-SPEC / PROJECT-CLAUDE-MD-SPEC |
| Environment plugin | ADF-ENV-PLUGIN-SPEC.md |
| Folder conventions | ADF-FOLDER-STRUCTURE-SPEC.md |
| Backlog management | ADF-BACKLOG-SPEC.md |
| Terminology | ADF-TAXONOMY.md |

---

## Two-Layer Model

ADF operates as two distinct layers:

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

## Framework Workflow Diagram

How the full framework fits together — environment as outer boundary, primitives as ambient services, stage pipeline in the center, artifacts flowing between stages:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        ENVIRONMENT LAYER                                │
│                                                                         │
│  Orchestration ◄─── ACM Specs + Prompts                                │
│  Capabilities  ◄─── capabilities-registry/                              │
│  Knowledge     ◄─── adf/kb/                                            │
│  Memory        ◄─── memory/                                             │
│  Maintenance   ◄─── distributed (each component)                        │
│  Validation    ◄─── distributed (skills + MCP health checks)            │
│                                                                         │
│  ┌────────────────────── STAGE PIPELINE ──────────────────────────┐     │
│  │                                                                 │     │
│  │  Discover ──────► Design ──────► Develop ──────► Deliver        │     │
│  │     │                │              │               │           │     │
│  │  intent.md       design.md      deliverable     deployed/       │     │
│  │  brief.md                       tests           distributed     │     │
│  │                                 README                          │     │
│  │                                 plan/tasks/                     │     │
│  │                                 manifest/caps                   │     │
│  │                                                                 │     │
│  └─────────────────────────────────────────────────────────────────┘     │
│                                                                         │
│  Cross-stage: status.md (every session) │ CLAUDE.md (evolves)           │
│  Cross-stage: docs/adf/ (planning artifacts)                            │
│                                                                         │
│  ┌── INTERFACES ──────────────────────────────────────────────────┐     │
│  │  ADF MCP server ─── read-only spec/prompt/capability/KB access │     │
│  │  acm-env plugin ─── environment management, health, hooks      │     │
│  │  .claude/rules/ ─── policy enforcement (human-controlled)      │     │
│  │  CLAUDE.md ──────── context and orientation (agent-writable)   │     │
│  └────────────────────────────────────────────────────────────────┘     │
│                                                                         │
│  Governing specs: STAGES-SPEC │ DISCOVER-SPEC │ DESIGN-SPEC │          │
│                   DEVELOP-SPEC │ REVIEW-SPEC │ PROJECT-TYPES-SPEC      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Stages Overview

The project layer is a four-stage pipeline. Each stage produces artifacts that persist forward.

| Stage | Produces | Key Spec |
|---|---|---|
| Discover | intent.md, brief.md | ADF-DISCOVER-SPEC.md |
| Design | design.md | ADF-DESIGN-SPEC.md |
| Develop | deliverable, docs, planning artifacts | ADF-DEVELOP-SPEC.md |
| Deliver | deployed/distributed deliverable | ADF-DELIVER-SPEC.md |

- Universal exit criteria exist for each stage — see ADF-STAGES-SPEC.md
- Stage boundary handoff protocol: verify exit criteria → update status.md → commit → clear context
- Cross-stage artifacts that persist through all stages: status.md, CLAUDE.md, docs/adf/

---

## Artifact Flow Model

How artifacts flow through the framework — what each stage produces and what persists. These are artifacts in **consumer projects** that follow ADF stages (not in the ADF repo itself):

```
Discover: intent.md, brief.md ──────────────────────────────→ (persist all stages)
Design:   design.md ─────────────────────────────────────────→ (persist all stages)
Develop:  docs/adf/{plan,tasks,manifest,capabilities}.md ───→ (archive at stage end)
          deliverable, tests, README ────────────────────────→ (persist)
Deliver:  deployed artifact ─────────────────────────────────→ (final)
```

Cross-stage: status.md (updated every session), CLAUDE.md (evolves with project understanding)

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

**Implemented by:** ADF specs and prompts, exposed to consumer projects via the ADF MCP server.

**Key behaviors:**
- Defines stage entry/exit criteria
- Enforces phase boundaries (hard gates, context clearing)
- Provides prompts for stage transitions and reviews
- Manages context loading rules (progressive disclosure)

**MCP tools:** `get_stage`, `get_review_prompt`, `get_transition_prompt`

**Location:** `~/code/_shared/adf/` — specs, prompts, stubs.

---

### 2. Capabilities

**Owns:** Inventory of skills, tools, and agents available for use across projects.

**Implemented by:** Capability Registry — a standalone, self-maintaining catalog. Queryable from consumer projects via the ADF MCP server.

**Key behaviors:**
- Catalogs available skills, tools, and agents
- Tracks status lifecycle: staging → active → archive
- Provides agent-queryable inventory (by category, by tags)
- Syncs from upstream sources (Anthropic official, curated community)

**MCP tools:** `query_capabilities`, `get_capability_detail`

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

**Implemented by:** Knowledge base within ADF (`adf/kb/`). Searchable from consumer projects via the ADF MCP server.

**Key behaviors:**
- Stores distilled, evergreen findings
- Referenced by agents during stage work ("Based on similar projects...")
- Grows from project experience, community sources, and research
- Each entry follows a structured format: summary, finding, rationale, application

**MCP tools:** `query_knowledge`

**Location:** `~/code/_shared/adf/kb/` — within ADF for now. Tightly coupled to process learnings.

**Characteristics:**
- Curated, not raw — every entry is validated and distilled
- Evergreen — entries are true over time, not tied to a single project
- Read-heavy — consumed frequently, updated occasionally
- Human-approved — entries are reviewed before addition

**Future consideration:** May extract to own repo if growth warrants separation from ADF process specs.

---

### 4. Memory

**Owns:** Session state, cross-agent continuity, project history, raw experience data.

**Implemented by:** Memory layer — a standalone repo for persistent state. **Status: planned (B18-B19), not yet built.**

**Key behaviors (planned):**
- Stores session logs and decisions
- Enables cross-session continuity (agent picks up where last session left off)
- Accumulates raw experience data that feeds knowledge distillation
- Provides per-project memory and cross-project memory

**Location:** `~/code/_shared/memory/` — own repo (planned).

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

**Implemented by:** Skills that run checks against specs. Validation is a behavior, not a component. Structural checks are also exposed via the ADF MCP server.

**Key behaviors:**
- Project health checks: "Is this project aligned with its intent?"
- Spec compliance: "Does this artifact match its spec requirements?"
- Drift detection: "Has the project diverged from its design?"
- Environment checks: "Is the environment baseline met?" (acm-env)

**MCP tools:** `check_project_structure`, `check_project_health`

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

## Governance Model: Rules vs Context

The environment layer distinguishes **policy** from **guidance** using two complementary mechanisms:

| Layer | Location | Purpose | Who Controls | Precedence |
|-------|----------|---------|--------------|------------|
| **Rules** | `.claude/rules/` | Hard constraints — non-negotiable behavior | Human only | Wins on conflict |
| **Context** | `CLAUDE.md` | Working norms, orientation, project understanding | Human + Agent | Defers to rules |

**Rules** are enforcement. Claude must not creatively reinterpret or work around them. They cover security, governance, safety, and architectural boundaries.

**Context** is guidance. It helps Claude understand *how we work here* — project goals, terminology, workflow norms, related repos. It is flexible and evolves frequently.

Every ADF project gets both. Rules are created at project init (`.claude/rules/` directory) and are human-controlled. Context is maintained in `CLAUDE.md` and can be updated by agents within normal workflow.

**Global rules** live at `~/.claude/CLAUDE.md` in the `<constraints>` block (Claude Code's native mechanism). Project rules in `.claude/rules/` extend these with project-specific policy.

---

## Interface Map

Unified view of how external consumers and internal components interact with ACM:

| Interface | What | Scope | Spec |
|---|---|---|---|
| ADF MCP server | Read-only spec/prompt/capability/KB access | Consumer projects | adf-server/README.md |
| acm-env plugin | Environment management, health, hooks | All projects | ADF-ENV-PLUGIN-SPEC.md |
| .claude/rules/ | Policy enforcement (human-controlled) | Per project | ADF-RULES-SPEC.md |
| CLAUDE.md | Context and orientation (agent-writable) | Per project | ADF-CONTEXT-ARTIFACT-SPEC.md |
| Companion skill | Workflow instructions for agents | Consumer projects | skills/acm-workflow/skill.md |

---

## Physical Layout

```
~/code/_shared/
├── acm/                          # Orchestration + Knowledge
│   ├── .claude/
│   │   ├── CLAUDE.md             # Project context (agent-writable)
│   │   └── rules/                # Hard constraints (human-controlled)
│   │       └── constraints.md    # Non-negotiable rules
│   ├── ADF-*-SPEC.md             # Process specs (orchestration contracts)
│   ├── ADF-ARCHITECTURE-SPEC.md   # This spec (master framework spec)
│   ├── adf-server/               # ADF MCP server (read-only tool interface)
│   ├── skills/                   # ADF-process skills (review automation, workflow)
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
└── memory/                       # Memory (PLANNED — not yet built, see B18-B19)
    ├── sessions/                 # Raw session logs
    ├── projects/                 # Per-project memory
    ├── scripts/                  # Distillation, cleanup
    └── MEMORY-SPEC.md            # How memory works
```

**ADF-process skills** (`acm/skills/`) are tightly coupled to ADF orchestration — review automation, workflow tools, stage transitions. They live inside ADF because they implement ADF's own process. General-purpose capabilities (frontend-design, pdf, etc.) live in the capabilities-registry.

**Maintenance** and **Validation** are distributed — each component owns its own maintenance scripts and validation skills. They don't have separate repos.

---

## Component Relationships

```
acm (orchestration) ──references──→ capabilities-registry (capabilities)
acm (orchestration) ──contains───→ kb/ (knowledge)
acm (orchestration) ──references──→ memory (session state) [PLANNED]

capabilities-registry ──self-maintains──→ (sync, freshness)
memory ──feeds──→ kb/ (distillation: raw memory → curated knowledge) [PLANNED]

validation (skills) ──reads──→ acm specs (contracts to validate against)
maintenance (scripts) ──lives in──→ each component
```

**Coupling rules:**
- ACM references registry and memory but doesn't manage them
- Registry and memory don't know about each other
- Registry doesn't depend on ADF — it's consumed, not coupled (ecosystem-aware via CLAUDE.md context, but no functional dependency)
- Each component is self-contained and self-maintaining
- Components point to each other but don't own each other

---

## MCP Server Interface Layer

The ADF MCP server (`acm/adf-server/`) is the **read-only interface** between the environment layer and consumer projects. It exposes four of the six primitives as tools that any agent can call without the ADF repo being open:

```
┌─────────────────────────────────┐
│  Consumer Project               │
│  (e.g., link-triage-pipeline)   │
│                                 │         ┌──────────────────────┐
│  Claude Code ──stdio──► ACM     │         │  ~/code/_shared/adf/ │
│  Agent                  MCP  ───┼── reads ─► specs, prompts,    │
│                         Server  │         │  stubs, kb/          │
│                                 │         ├──────────────────────┤
│  .mcp.json wires up server      │         │  capabilities-       │
│  CLAUDE.md references ACM skill │         │  registry/           │
└─────────────────────────────────┘         └──────────────────────┘
```

### Tool Coverage by Primitive

| Primitive | MCP Tools | What's Exposed |
|-----------|-----------|----------------|
| **Orchestration** | `get_stage`, `get_review_prompt`, `get_transition_prompt` | Stage specs, review prompts, transition guidance with validation |
| **Capabilities** | `query_capabilities`, `get_capability_detail` | Registry search and capability details |
| **Knowledge** | `query_knowledge` | KB article search by topic |
| **Validation** | `check_project_structure`, `check_project_health` | Structural and health checks against ADF spec |
| **Memory** | — | Not yet built (future: memory layer) |
| **Maintenance** | — | Handled by acm-env plugin, not the MCP server |

### Supporting Tools

| Tool | Purpose |
|------|---------|
| `get_artifact_spec` | Spec for any artifact type (brief, intent, status, etc.) |
| `get_artifact_stub` | Starter template for any artifact |
| `get_project_type_guidance` | What a project type requires |
| `get_rules_spec` | Rules governance specification |
| `get_context_spec` | CLAUDE.md specification (global/project) |

### Companion Skill

The ACM Workflow skill (`acm/skills/acm-workflow/`) teaches agents **when and how** to use the tools. The MCP server provides data access; the skill provides narrative workflow instructions. Consumer projects reference the skill in their CLAUDE.md.

### Consumer Wiring

A consumer project needs two things:

1. **`.mcp.json`** — wires the server (one-time setup)
2. **`CLAUDE.md` reference** — points to the companion skill (optional but recommended)

The server is read-only, has no network access, and reads all data from disk at request time (no caching, always reflects current spec state).

---

## Self-Improvement Loop

The environment layer is designed to enable continuous improvement across projects:

1. **Capture** — During projects, agents log decisions, friction, learnings to memory
2. **Distill** — Periodically, a skill processes raw memory into KB entries or spec update proposals
3. **Apply** — When starting new work, agents read KB and benefit from accumulated experience
4. **Validate** — Ongoing checks ensure specs, capabilities, and knowledge stay current and aligned

This loop is the mechanism by which the system gets better over time. It is not a stage — it is ambient behavior of the environment layer.

**Current status:** Steps 3 (Apply) and 4 (Validate) are operational — KB is queryable via MCP and validation skills exist. Steps 1 (Capture) and 2 (Distill) depend on the memory layer (B18-B19, planned). KB entries are currently created manually during project work.

---

## Spec Index

Complete table of all ADF specifications:

| Spec | Version | Governs | Primitive |
|---|---|---|---|
| ADF-ARCHITECTURE-SPEC.md | 2.0.1 | Framework architecture (this doc) | All |
| ADF-STAGES-SPEC.md | 1.2.0 | Stage workflow, exit criteria, handoff | Orchestration |
| ADF-DISCOVER-SPEC.md | 1.3.0 | Discover stage | Orchestration |
| ADF-DESIGN-SPEC.md | 1.1.0 | Design stage | Orchestration |
| ADF-DEVELOP-SPEC.md | 2.0.0 | Develop stage | Orchestration |
| ADF-REVIEW-SPEC.md | 1.2.0 | Two-phase review mechanism | Validation |
| ADF-PROJECT-TYPES-SPEC.md | 2.0.0 | Project classification | Orchestration |
| ADF-BRIEF-SPEC.md | 2.1.0 | Brief artifact format | Orchestration |
| ADF-INTENT-SPEC.md | 1.0.1 | Intent artifact format | Orchestration |
| ADF-STATUS-SPEC.md | 1.1.0 | Status artifact format | Orchestration |
| ADF-README-SPEC.md | 1.0.0 | README artifact format | Orchestration |
| ADF-CONTEXT-ARTIFACT-SPEC.md | 1.0.0 | CLAUDE.md format (shared) | Orchestration |
| ADF-GLOBAL-CLAUDE-MD-SPEC.md | 1.1.0 | Global CLAUDE.md format | Orchestration |
| ADF-PROJECT-CLAUDE-MD-SPEC.md | 1.1.0 | Project CLAUDE.md format | Orchestration |
| ADF-FOLDER-STRUCTURE-SPEC.md | 1.2.0 | Folder conventions | Orchestration |
| ADF-RULES-SPEC.md | 1.0.0 | Rules governance | Validation |
| ADF-BACKLOG-SPEC.md | 1.0.0 | Backlog management | Orchestration |
| ADF-ENV-PLUGIN-SPEC.md | 1.0.0 | acm-env plugin | Maintenance |
| ADF-TAXONOMY.md | 1.4.0 | Terminology | All |

---

## Design Principles

- **Modular and self-contained** — each component has its own repo, spec, and maintenance
- **Loosely coupled** — components reference each other but don't manage each other
- **Self-maintaining** — each component owns its own freshness and health
- **Goldilocks complexity** — simple but effective; avoid over-engineering
- **Progressive narrowing** — broad early, specific as projects gain clarity
- **Specs as contracts** — every spec is implicitly a validation contract

---

## Revision History

| Version | Date | Changes |
|---|---|---|
| 1.0.0 | 2026-01-29 | Initial — six primitives, two-layer model |
| 1.1.0 | 2026-01-30 | Physical layout, governance model |
| 1.2.0 | 2026-01-31 | Skills/ and adf-server/ in physical layout |
| 1.3.0 | 2026-01-31 | MCP server interface layer section |
| 2.0.0 | 2026-02-01 | Elevated to master framework spec — added spec map, framework diagram, stages overview, artifact flow, interface map, spec index |
| 2.0.1 | 2026-02-01 | Review pass — marked memory as planned (B18-B19), clarified artifact flow is consumer-project scoped, corrected spec index primitive assignments (STATUS→Orchestration, README→Orchestration), clarified registry coupling, added self-improvement loop implementation status |

---

## References

- ADF-STAGES-SPEC.md (project layer — stage workflow model)
- ADF-RULES-SPEC.md (enforcement layer — rules governance model)
- ADF-ENV-PLUGIN-SPEC.md (acm-env plugin — environment management)
- ADF-TAXONOMY.md (terminology)
- adf-server/README.md (MCP server — installation, tools, consumer wiring)
- skills/acm-workflow/skill.md (companion skill — workflow instructions)
- docs/design.md (MCP server design spec — full tool schemas and architecture)
