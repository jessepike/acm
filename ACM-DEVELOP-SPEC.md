---
type: "specification"
description: "Detailed specification for the Develop stage workflow"
version: "1.2.0"
updated: "2026-01-29"
scope: "acm"
lifecycle: "reference"
location: "acm/ACM-DEVELOP-SPEC.md"
---

# ACM Develop Stage Specification

## Purpose

Define the Develop stage — the third stage in the ACM workflow where a validated design becomes a working implementation.

---

## Stage Overview

> **"Are we building it correctly?"**

Develop transforms a validated design into a working deliverable. This stage handles capability assessment, planning, environment setup, and actual implementation with thorough automated testing before any human involvement.

**Primary Deliverables (in sequence):**

| Order | Artifact | Content | Creates |
|-------|----------|---------|---------|
| 1 | `manifest.md` | Software dependencies to install | What to install |
| 2 | `capabilities.md` | MCP servers, skills, sub-agents, tools | What agent infrastructure is needed |
| 3 | `plan.md` | Implementation plan with phases/milestones | How to build it |
| 4 | `tasks.md` | Atomic task list with status tracking | What to do |
| 5 | The deliverable | Code, artifact, or workflow | The actual thing |

**Sequence matters.** Capabilities informs planning. Planning informs tasks. Do not create later artifacts until earlier ones are approved.

---

## Phase Model

**PLANNING PHASES (1-3):** Produce artifacts, stop for human review after Phase 3.

| Phase | Description | Exit Gate | Artifacts |
|-------|-------------|-----------|-----------|
| **1. Intake & Validation** | Ensure understanding, close loose ends | Human confirms understanding | — |
| **2. Capability Assessment** | Identify dependencies and capabilities needed | Human approves manifest + capabilities | manifest.md, capabilities.md |
| **3. Planning** | Create implementation plan and task breakdown | Human approves plan + tasks | plan.md, tasks.md |

**HARD GATE:** After Phase 3, STOP. Present all planning artifacts for human review before execution.

**EXECUTION PHASES (4-6):** Require approved plan.

| Phase | Description | Exit Gate | Artifacts |
|-------|-------------|-----------|-----------|
| **4. Review Loop** | Validate plan via internal/external review | No Critical/High issues | Updated plan artifacts |
| **5. Environment Setup** | Install dependencies, configure capabilities | Environment verified | — |
| **6. Build** | Actual implementation with testing | 95%+ tests pass, human validates | The deliverable |

---

## Phase Boundary Protocol

Every phase transition requires context clearing to prevent accumulated drift and stale assumptions.

**Protocol (agent-driven):**

1. Agent completes phase work
2. Agent updates `status.md` with phase completion and summary
3. Agent updates `tasks.md` if applicable
4. Agent runs `/clear`
5. Agent re-reads artifacts fresh: `CLAUDE.md` → `status.md` → `tasks.md` → `plan.md`
6. Agent confirms: **"Phase N complete. Starting Phase N+1. Here's what I see: [brief summary of current state and next actions]"**

**Why:** Multi-phase execution accumulates stale context. Agents carry assumptions forward that may no longer apply. Clearing context and re-reading from artifacts ensures each phase starts from ground truth, not memory.

**What carries across phases (via artifacts, not memory):**
- `status.md` — current state, what was done
- `tasks.md` — task status, completion notes
- `plan.md` — implementation plan, decision log
- `manifest.md` / `capabilities.md` — dependencies and capabilities

**What does NOT carry across:**
- In-context assumptions from previous phase work
- Intermediate reasoning or exploration
- Abandoned approaches or discarded options

**Human involvement:** Human only intervenes at hard gates (e.g., post-Phase 3 planning approval). Context clearing between other phases is agent-driven and automatic.

---

## Inputs

What enters the Develop stage:

| Input | Source | Description |
|-------|--------|-------------|
| `design.md` | Design | Primary input — technical specification (consumed) |
| Supporting design docs | Design | architecture.md, data-model.md, etc. if >500 lines |
| `intent.md` | Discover | North Star — referenced throughout |
| `discover-brief.md` | Discover | Contract — referenced for success criteria |
| Project classification | Brief | Type + modifiers determine deliverable shape |
| ACM specs | Meta layer | Develop spec, testing requirements |

---

## Outputs

What Develop produces:

| Output | Description | Location |
|--------|-------------|----------|
| `manifest.md` | Software dependencies, libraries, packages | `/docs/manifest.md` |
| `capabilities.md` | Skills, tools, sub-agents, MCP servers | `/docs/capabilities.md` |
| `plan.md` | Implementation plan — phases, milestones, approach | `/docs/plan.md` |
| `tasks.md` | Atomic task list with status tracking | `/docs/tasks.md` |
| Updated design docs | If gaps found during validation | `/docs/design*.md` |
| The deliverable | Code, artifact, or workflow | Type-specific location |

---

## Phase Details

### 1. Intake & Validation

**Purpose:** Ensure the development team (agents) fully understands the design before any work begins. Close all loose ends.

**Activities:**
- Read design.md and all supporting design artifacts
- Identify ambiguities, gaps, or open questions
- Use AskUserQuestion for clarification
- Validate understanding: "I read X as meaning Y — correct?"
- Close any loose ends from Design stage

**Agent role:** Active questioner. Challenge assumptions. Ensure 100% clarity before proceeding.

**Human role:** Answer questions, clarify intent, approve understanding.

**Key questions to resolve:**
- Technical choices: "I see we're using Vercel — is that confirmed, or are there alternatives to consider?"
- Ambiguities: "The design says 'simple auth' — what specifically does that mean?"
- Dependencies: "This requires X — is that available/approved?"
- Priorities: "If we hit constraints, what's negotiable?"

**Exit signal:** Agent confirms: "I have full understanding. Ready to assess capabilities."

---

### 2. Capability Assessment

**Purpose:** Identify everything needed to build the deliverable — both software dependencies and agent capabilities.

**Sequence:** Create manifest.md first, then capabilities.md. Capabilities cannot be assessed until dependencies are known.

**Two distinct outputs:**

#### manifest.md — Software Dependencies

What needs to be installed:
- Languages/runtimes (Node.js, Python, Go, etc.)
- Frameworks (Next.js, FastAPI, etc.)
- Libraries/packages (with versions where critical)
- Infrastructure dependencies (databases, caches, etc.)
- Development tools (linters, formatters, test runners)
- External services (APIs, SaaS integrations)

#### capabilities.md — Agent Infrastructure

What the agent team needs to execute. **Required sections:**

| Section | Content | Example |
|---------|---------|---------|
| **MCP Servers** | Model Context Protocol servers for external integrations | Context7 (docs), Vercel (deploy), Supabase (db) |
| **Skills** | Specialized procedural knowledge from registry | frontend-design, webapp-testing, pdf |
| **Sub-agents** | Specialized agents for specific domains | ui-expert, backend-specialist |
| **CLIs & Tools** | External command-line tools and utilities | npm, git, playwright |
| **Testing Capabilities** | Test frameworks and validation tools | Jest, Playwright, axe-core |

**Registry Query Step:**

Before documenting capabilities, query available resources:

1. **Check registry inventory** — What skills/tools are available? (INVENTORY.md or equivalent)
2. **Match to requirements** — Which available capabilities apply to this project?
3. **Identify gaps** — What's needed but not in registry? (manual specification required)
4. **Document source** — For each capability, note: registry path OR manual specification

Example capabilities.md structure:

```markdown
## MCP Servers

| Server | Purpose | Source |
|--------|---------|--------|
| context7-mcp | Astro documentation lookup | Manual (not in registry) |
| filesystem-mcp | File system access | registry: active/tool/@modelcontextprotocol/filesystem-mcp |

## Skills

| Skill | Purpose | Source |
|-------|---------|--------|
| frontend-design | UI component patterns | registry: active/skill/@anthropic/frontend-design |
| webapp-testing | E2E test patterns | registry: active/skill/@anthropic/webapp-testing |

## Sub-agents

None required for this project.

## CLIs & Tools

| Tool | Purpose | Install |
|------|---------|---------|
| npm | Package management | Bundled with Node.js |
| playwright | E2E testing | npm install |

## Testing Capabilities

| Capability | Purpose |
|------------|---------|
| Playwright | E2E browser testing |
| axe-core | Accessibility validation |
```

**Agent role:** Query registry, research requirements from design, document comprehensively with sources.

**Human role:** Validate capability choices, approve or suggest alternatives, provide registry access if needed.

**Exit signal:** Manifest and capabilities approved. Ready to plan.

---

### 3. Planning

**Purpose:** Create a comprehensive implementation plan and atomic task breakdown.

**Two outputs:**

#### plan.md — Implementation Plan

- **Overview:** What we're building, approach summary
- **Phases:** Logical groupings of work (e.g., Phase 1: Core structure, Phase 2: Features, Phase 3: Polish)
- **Milestones:** Key checkpoints with deliverables
- **Approach:** How we'll tackle each phase
- **Testing strategy:** TDD approach, what gets tested, acceptance criteria
- **Parallelization opportunities:** What can run concurrently
- **Risk areas:** Known challenges, mitigation approaches

#### tasks.md — Atomic Task List

- **Atomic tasks:** Small, single-agent executable chunks
- **Grouped by phase:** Matches plan.md phases
- **Grouped by domain:** Frontend, backend, testing, etc.
- **Clear acceptance criteria:** How to know task is complete
- **Dependencies noted:** What must complete before this task

**Task format (table with status):**

```markdown
## Phase 1: Core Structure

| ID | Task | Status | Acceptance Criteria | Depends | Capability |
|----|------|--------|---------------------|---------|------------|
| 1.1 | Set up Next.js project | pending | `npm run dev` starts, shows default page | — | npm CLI |
| 1.2 | Configure Tailwind CSS | pending | Tailwind classes apply correctly | 1.1 | frontend-design skill |
| 1.3 | Create base layout | pending | Layout renders with header/footer slots | 1.2 | — |
```

**Status values:** `pending`, `in-progress`, `done`, `blocked`

**Capability column:** Links task to required capability from capabilities.md. Validates agent has what it needs.

**Task granularity:** Small enough that one agent can:
1. Read the task
2. Complete the work
3. Verify acceptance criteria
4. Mark complete and sign off

**Exit signal:** Plan and tasks drafted. Ready for review.

---

### 4. Review Loop

**Purpose:** Validate the plan and capability assessment before environment setup.

**Two-Phase Review Model:**

| Phase | Reviewer | Focus |
|-------|----------|-------|
| **Internal** | Primary agent (Ralph Loop) | Completeness, feasibility, task coverage |
| **External** | GPT, Gemini, etc. | Blind spots, alternative approaches, risk identification |

**What gets reviewed:**
- manifest.md
- capabilities.md
- plan.md
- tasks.md

All artifacts reviewed together — they must align.

**Review focus:**
- Does the plan cover all design requirements?
- Are tasks atomic enough for single-agent execution?
- Are dependencies complete? Anything missing?
- Is the testing strategy sufficient?
- Are there parallelization opportunities not captured?
- Any risks not addressed?

**Exit signal:** No P1 issues. Plan is executable.

**Design updates:** If review surfaces gaps in design, update design artifacts (document and move on — no re-review of design).

---

### 5. Environment Setup

**Purpose:** Get everything ready for build. No coding yet — just preparation.

**Activities:**
- Install dependencies from manifest.md
- Configure tools and capabilities from capabilities.md
- Set up project structure
- Configure testing framework
- Verify environment works (smoke test)

**Agent role:** Execute setup, verify each step.

**Human role:** Minimal — troubleshoot if issues arise.

**Verification:**
- All dependencies install successfully
- Development server runs
- Test framework executes
- Required capabilities are accessible

**Exit signal:** Environment verified. Ready to build.

---

### 6. Build

**Purpose:** Actually implement the deliverable with thorough automated testing.

**Approach: Test-Driven Development**

For each task:
1. Write tests first (where applicable)
2. Implement to pass tests
3. Verify acceptance criteria
4. Mark task complete

**Task execution workflow:**

```
Agent assigned task
    ↓
Read task + acceptance criteria
    ↓
Implement (TDD where applicable)
    ↓
Run tests — must pass
    ↓
Verify acceptance criteria met
    ↓
Mark task complete in tasks.md
    ↓
Sign off
```

**Parallelization:**
- Independent tasks can run concurrently via sub-agents
- Primary orchestrating agent coordinates
- Sub-agents report completion back

**Testing requirements:**
- Automated tests for all critical paths
- **95%+ pass rate minimum** before human testing
- No "ready for testing" when basic functionality fails
- Integration tests where components interact

**What gets maintained during Build:**
- `tasks.md` — Updated as tasks complete
- `status.md` — Updated by primary agent (not sub-agents)
- `backlog.md` — New ideas/improvements captured
- `decision-log` — Key implementation decisions documented

**Critical rule:** Do NOT ask for human testing until:
- All tasks marked complete
- Automated tests pass (95%+ rate)
- Basic functionality verified
- Agent has done thorough self-validation

**Exit signal:** All tasks complete. Automated tests pass. Ready for human validation.

---

## Testing Strategy

Testing is not optional. It's core to Develop.

### Testing Levels

| Level | What | When |
|-------|------|------|
| **Unit tests** | Individual functions/components | During task implementation |
| **Integration tests** | Component interactions | After related tasks complete |
| **End-to-end tests** | Full user flows | Before human handoff |
| **Smoke tests** | Basic functionality | Continuous |

### Testing Requirements by Type

| Project Type | Testing Focus |
|--------------|---------------|
| **App** | Unit, integration, E2E, accessibility, performance |
| **Workflow** | Unit, integration, error handling, idempotency |
| **Artifact** | Validation, format compliance, content accuracy |

### Testing Capabilities

These should be identified in capabilities.md:
- Test runners (Jest, Pytest, etc.)
- E2E frameworks (Playwright, Cypress)
- Accessibility checkers
- Performance profilers
- Linters and static analysis

---

## Artifact Maintenance

During Develop, these artifacts require ongoing updates:

| Artifact | Updated By | Frequency | Content |
|----------|------------|-----------|---------|
| `tasks.md` | Any agent completing tasks | Per task | Task status, completion notes |
| `status.md` | Primary orchestrating agent only | Regular checkpoints | Phase progress, blockers, next steps |
| `backlog.md` | Any agent | As discovered | Ideas, improvements, future work |
| Decision log (in plan.md) | Any agent | As decisions made | Key choices with rationale |

**Critical:** Sub-agents do NOT update status.md. Only the primary orchestrating agent maintains session state.

---

## Exit Criteria

Develop is complete when:

- [ ] All tasks in tasks.md marked complete
- [ ] Automated tests pass (95%+ rate)
- [ ] Success criteria from Brief are verifiable
- [ ] No critical bugs or broken functionality
- [ ] Basic user flows work end-to-end
- [ ] status.md updated with stage completion
- [ ] Human validation confirms readiness

**The handoff test:** Human tests the most basic functionality. If it fails, Develop is not done.

---

## Context Loading

### What the Primary Agent Needs

1. **Design package** — design.md + supporting docs (consumed)
2. **Intent** — North Star (referenced)
3. **Brief** — Success criteria (referenced)
4. **This spec** — Stage workflow
5. **Current state** — status.md

### Context Map (for CLAUDE.md)

```markdown
## Context Map

| File | Load When | Purpose |
|------|-----------|---------|
| intent.md | Always | North Star |
| design.md | Develop stage | Primary input |
| plan.md | Develop stage (after created) | Implementation guide |
| tasks.md | Develop stage (after created) | Task tracking |
| ACM-DEVELOP-SPEC.md | Develop stage (reference) | Stage workflow |
```

---

## Sub-Agent Coordination

Develop makes heavy use of sub-agents for parallelization.

### Primary Agent Responsibilities

- Orchestrate overall workflow
- Assign tasks to sub-agents
- Update status.md
- Coordinate dependencies between tasks
- Final validation before human handoff

### Sub-Agent Responsibilities

- Execute assigned tasks
- Run tests for their work
- Mark tasks complete in tasks.md
- Report blockers to primary agent
- Do NOT update status.md

### Parallelization Rules

- Only parallelize independent tasks
- Tasks with dependencies execute sequentially
- Primary agent monitors all parallel work
- Merge/integration points are synchronization barriers

---

## Supporting Artifacts

### Prompts

| Prompt | Location | Purpose |
|--------|----------|---------|
| Start Develop Prompt | `/prompts/start-develop-prompt.md` | Stage transition + intake validation |
| Develop Ralph Review Prompt | `/prompts/develop-ralph-review-prompt.md` | Internal review |
| Develop External Review Prompt | `/prompts/develop-external-review-prompt.md` | External review |

---

## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                          DEVELOP STAGE                               │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────────────┐                                           │
│  │  INTAKE & VALIDATION │  Human: Med | Agent: High                 │
│  │  - Read design       │                                           │
│  │  - Clarify questions │                                           │
│  │  - Close loose ends  │                                           │
│  └──────┬───────────────┘                                           │
│         │ "Full understanding"                                      │
│         ▼                                                           │
│  ┌──────────────────────┐                                           │
│  │ CAPABILITY ASSESSMENT│  Human: Low | Agent: High                 │
│  │  - manifest.md       │  (dependencies)                           │
│  │  - capabilities.md   │  (skills, tools, sub-agents)              │
│  └──────┬───────────────┘                                           │
│         │ "Capabilities approved"                                   │
│         ▼                                                           │
│  ┌──────────────────────┐                                           │
│  │      PLANNING        │  Human: Low-Med | Agent: High             │
│  │  - plan.md           │  (phases, milestones)                     │
│  │  - tasks.md          │  (atomic tasks)                           │
│  └──────┬───────────────┘                                           │
│         │ "Plan drafted"                                            │
│         ▼                                                           │
│  ┌────────────────────────────────────────────────────────┐         │
│  │                    REVIEW LOOP                          │         │
│  │  ┌─────────────────┐       ┌─────────────────────────┐ │         │
│  │  │ INTERNAL        │       │ EXTERNAL                │ │         │
│  │  │ (Ralph Loop)    │  ───► │ (GPT, Gemini)           │ │         │
│  │  │                 │       │                         │ │         │
│  │  │ Plan complete?  │       │ Blind spots?            │ │         │
│  │  │ Tasks atomic?   │       │ Risks?                  │ │         │
│  │  └─────────────────┘       └─────────────────────────┘ │         │
│  └────────────────────────────────────────────────────────┘         │
│         │ "No P1 issues"                                            │
│         ▼                                                           │
│  ┌──────────────────────┐                                           │
│  │  ENVIRONMENT SETUP   │  Human: Low | Agent: High                 │
│  │  - Install deps      │                                           │
│  │  - Configure tools   │                                           │
│  │  - Verify environment│                                           │
│  └──────┬───────────────┘                                           │
│         │ "Environment ready"                                       │
│         ▼                                                           │
│  ┌──────────────────────┐                                           │
│  │        BUILD         │  Human: Low | Agent: High                 │
│  │  - TDD approach      │                                           │
│  │  - Task execution    │  ←─── Sub-agents (parallel)               │
│  │  - Automated testing │                                           │
│  │  - 95%+ pass rate    │                                           │
│  └──────┬───────────────┘                                           │
│         │ "All tests pass"                                          │
│         ▼                                                           │
│  ┌──────────────────────────────────────┐                           │
│  │  OUTPUTS: The deliverable + docs      │                          │
│  └──────────────────────────────────────┘                           │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                        DELIVER STAGE
```

---

## References

- ACM-DESIGN-SPEC.md (Design is primary input)
- ACM-BRIEF-SPEC.md (Success criteria reference)
- ACM-INTENT-SPEC.md (North Star reference)
- ACM-PROJECT-TYPES-SPEC.md (Deliverable shape)
- ACM-TAXONOMY.md (Terminology)
