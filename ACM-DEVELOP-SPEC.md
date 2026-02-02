---
type: "specification"
description: "Detailed specification for the Develop stage workflow"
version: "2.1.0"
updated: "2026-02-02"
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

Develop transforms a validated design into a working deliverable. This stage handles capability assessment, planning, environment setup, implementation, documentation, and structured closeout.

**Primary Deliverables (in sequence):**

| Order | Artifact | Content | Creates |
|-------|----------|---------|---------|
| 1 | `manifest.md` | Software dependencies to install | What to install |
| 2 | `capabilities.md` | MCP servers, skills, sub-agents, tools | What agent infrastructure is needed |
| 3 | `plan.md` | Implementation plan with phases/milestones | How to build it |
| 4 | `tasks.md` | Atomic task list with status tracking | What to do |
| 5 | The deliverable | Code, artifact, or workflow | The actual thing |
| 6 | Documentation | README, API docs, usage guides | How to use it |

**Sequence matters.** Capabilities informs planning. Planning informs tasks. Do not create later artifacts until earlier ones are approved.

---

## Phase Model

**PLANNING PHASES (1-3):** Produce artifacts, proceed to review.

| Phase | Description | Exit Gate | Artifacts |
|-------|-------------|-----------|-----------|
| **1. Intake & Validation** | Ensure understanding, close loose ends | Human confirms understanding | — |
| **2. Capability Assessment** | Identify dependencies and capabilities needed | Human approves manifest + capabilities | manifest.md, capabilities.md |
| **3. Planning** | Create implementation plan and task breakdown | Agent approves plan + tasks | plan.md, tasks.md |

**REVIEW + HARD GATE (Phase 4):** Validate plan, then get human approval.

| Phase | Description | Exit Gate | Artifacts |
|-------|-------------|-----------|-----------|
| **4. Review Loop & Approval** | Internal/external review, then human sign-off | No Critical/High issues + human approval | Updated planning artifacts |

**EXECUTION PHASES (5-8):** Require approved plan.

| Phase | Description | Exit Gate | Artifacts |
|-------|-------------|-----------|-----------|
| **5. Environment Setup** | Install dependencies, configure capabilities | Environment verified | — |
| **6. Build** | Implementation with testing + build-to-design verification | 95%+ tests pass, verification complete | The deliverable |
| **7. Documentation** | README, API docs, usage guides | Docs exist and accurate | Documentation |
| **8. Closeout** | Cleanup, verification, archive, seal | All criteria met, status.md sealed | — |

### Concrete Actions at Each Phase

**What gets installed/executed when:**

| Phase | What Gets Installed/Executed | Approval Needed |
|-------|------------------------------|-----------------|
| **1. Intake & Validation** | Nothing — ask questions, clarify design | Human confirms understanding to proceed |
| **2. Capability Assessment** | Nothing — document what's needed in manifest.md + capabilities.md | Human approves capability list to proceed |
| **3. Planning** | Nothing — create plan.md + tasks.md | Not yet (wait for Review + HARD GATE) |
| **4. Review Loop & Approval** | Review plan via Ralph Loop + external reviewers | **Human approves ALL planning artifacts after review** |
| **5. Environment Setup** | ✅ Install Python packages (pip install)<br>✅ Activate plugins<br>✅ Create venv, config files | Already approved at HARD GATE |
| **6. Build** | ✅ Write code<br>✅ Run tests<br>✅ Create deliverable<br>✅ Build-to-design verification | Already approved at HARD GATE |
| **7. Documentation** | ✅ Write/update README, API docs, guides | Already approved at HARD GATE |
| **8. Closeout** | ✅ Cleanup, archive, status seal | Already approved at HARD GATE |

**Key insight:** Phase 4 is the combined review + approval gate. Agents review the plan thoroughly, THEN present polished artifacts to human for approval.

---

## Phase Boundary Protocol

Every phase transition requires context clearing to prevent accumulated drift and stale assumptions.

**Protocol (agent-driven):**

1. Agent completes phase work
2. Agent updates the **Handoff** block in `tasks.md` (see format below)
3. Agent updates `status.md` with phase completion summary
4. **Agent commits all changes** (mandatory — not optional)
5. Agent updates `current_phase` in `tasks.md` frontmatter
6. Agent moves completed tasks to Completed section in `tasks.md`
7. Agent runs `/clear`
8. Agent re-reads artifacts fresh: `CLAUDE.md` → `status.md` → `tasks.md` → `plan.md`
9. Agent confirms: **"Phase N complete. Starting Phase N+1. Here's what I see: [brief summary from handoff block]"**

**Why:** Multi-phase execution accumulates stale context. Agents carry assumptions forward that may no longer apply. Clearing context and re-reading from artifacts ensures each phase starts from ground truth, not memory.

**Stage boundary** uses the heavier protocol defined in ACM-STAGES-SPEC.md (Stage Boundary Handoff Protocol). Phase boundary is internal to a stage; stage boundary transitions between stages.

### Handoff Block

The Handoff section lives at the top of `tasks.md` (after frontmatter, before phase tables). It is **overwritten** at each phase boundary — only the current handoff matters.

**Required format:**

```markdown
## Handoff

| Field | Value |
|-------|-------|
| Phase | {completed phase name} |
| Status | Complete |
| Next | {next phase name} |
| Blocker | {blocker or "None"} |

**Done this phase:**
- {task ID}: {brief summary}
- {task ID}: {brief summary}

**Next phase requires:**
- {what to start, key dependencies, any setup needed}

**Build notes:**
- {decisions made, gotchas discovered, anything the next phase needs to know}
```

**Rules:**
- **Overwrite, don't append.** Each boundary replaces the previous handoff block.
- **Keep it short.** 10-20 lines max. This is orientation, not a journal.
- **Build notes are optional.** Omit the section if there's nothing worth noting.
- **Phase field uses the phase name**, not just a number (e.g., "Phase B: Providers", not "B").

**What carries across phases (via artifacts, not memory):**
- `tasks.md` — handoff block + task status (primary orientation artifact)
- `status.md` — current state, session-level summary
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
| ACM specs | Environment layer | Develop spec, testing requirements |

---

## Outputs

What Develop produces:

| Output | Description | Location |
|--------|-------------|----------|
| `manifest.md` | Software dependencies, libraries, packages | `docs/acm/manifest.md` |
| `capabilities.md` | Skills, tools, sub-agents, MCP servers | `docs/acm/capabilities.md` |
| `plan.md` | Implementation plan — phases, milestones, approach | `docs/acm/plan.md` |
| `tasks.md` | Atomic task list with status tracking | `docs/acm/tasks.md` |
| Updated design docs | If gaps found during validation | `docs/design*.md` |
| The deliverable | Code, artifact, or workflow | Type-specific location |
| Documentation | README, API docs, usage guides | Project root + type-specific |

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

**Testing capabilities MUST be identified in Phase 2.** The build agent needs to know upfront:
- Test framework (Jest, Pytest, Vitest)
- E2E tools (Playwright, Cypress)
- Browser testing tools (Claude in Chrome, MCP Inspector)
- Linters / static analysis

If testing tools are missing from capabilities.md, Phase 2 is incomplete.

**Registry Query Step (mandatory):**

Before documenting capabilities, query available resources:

1. **Read registry inventory** — `~/code/_shared/capabilities-registry/INVENTORY.md`
2. **Match to requirements** — Which available capabilities apply to this project?
3. **Identify gaps** — What's needed but not in registry? (manual specification required)
4. **Document source** — For each capability, note: registry path OR manual specification
5. **Write Registry Summary** — Include as the first section of capabilities.md (see format below)

**Why mandatory:** Without the summary, the HARD GATE reviewer cannot verify the registry was consulted. A missing or empty Registry Summary section means Phase 2 is incomplete.

Example capabilities.md structure:

```markdown
## Registry Summary

- **Registry consulted:** ~/code/_shared/capabilities-registry/INVENTORY.md
- **Total available:** 39 capabilities (16 skills, 4 tools, 15 plugins, 4 MCP servers)
- **Matched:** 3 (frontend-design, webapp-testing, filesystem-mcp)
- **Gaps:** 1 (context7-mcp — not in registry, manual specification)

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
- **Testing Strategy:** What frameworks (from capabilities.md), what gets tested (unit, integration, E2E, browser), coverage targets (default: 95%+), browser testing plan (if applicable — Claude in Chrome or MCP Inspector)
- **Parallelization opportunities:** What can run concurrently
- **Risk areas:** Known challenges, mitigation approaches

If the testing strategy section is missing or incomplete, Phase 3 is incomplete.

#### tasks.md — Handoff + Atomic Task List

**Structure:** Handoff block first, then phase tables with progressive disclosure.

```markdown
---
current_phase: "Phase 1: Core Structure"
---

## Handoff
[Current phase handoff — overwritten each boundary]

## Active Tasks
[Current phase tasks — what the agent works on]

## Upcoming
[Next phase(s) — planning reference]

## Completed
[Previous phases — kept for traceability, agents skip unless investigating]
```

**Progressive disclosure rules:**
- Agent reads Handoff + Active Tasks. Start from Handoff, work Active Tasks. Skip Completed unless investigating history.
- When phase completes: move tasks to Completed, promote next to Active
- `current_phase` in frontmatter tells agent where to start

**Task format (table with status):**

```markdown
## Active Tasks

| ID | Task | Status | Acceptance Criteria | Testing | Depends | Capability |
|----|------|--------|---------------------|---------|---------|------------|
| 1.1 | Set up Next.js project | pending | `npm run dev` starts | Unit: project loads | — | npm CLI |
| 1.2 | Configure Tailwind CSS | pending | Tailwind classes apply | Unit: class resolution | 1.1 | frontend-design |
| 1.3 | Create base layout | pending | Layout renders with slots | Unit: render test | 1.2 | — |
```

**Status values:** `pending`, `in-progress`, `done`, `blocked`

**Testing column:** What tests cover this task. Links task to testing strategy.

**Capability column:** Links task to required capability from capabilities.md. Validates agent has what it needs.

**Task granularity:** Small enough that one agent can:
1. Read the task
2. Complete the work
3. Verify acceptance criteria
4. Mark complete and sign off

**Exit signal:** Plan and tasks drafted. Ready for review.

---

### 4. Review Loop & Approval

**Purpose:** Validate the plan and capability assessment through thorough review, THEN get human approval.

**Two-step process:**

#### Step 1: Review Loop

Invoke review per ACM-REVIEW-SPEC.md. Use `get_review_prompt('develop', phase)` from ACM MCP server.

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

**Review phases:**

| Phase | Reviewer | Mechanism | Value |
|-------|----------|-----------|-------|
| **Phase 1: Internal** | Primary agent (Claude) | Ralph Loop — automated iteration | Fast iteration, gets plan to solid baseline |
| **Phase 2: External** | Other models (GPT, Gemini) | Manual submission (user-driven) | Diverse perspectives, catches blind spots |

**Exit condition (Step 1):** No Critical/High issues. Plan is executable.

#### Step 2: HARD GATE — Human Approval

After review completes, present all planning artifacts to human for approval.

**Agent presents:**
- manifest.md (dependencies)
- capabilities.md (skills/tools needed)
- plan.md (implementation approach + testing strategy)
- tasks.md (atomic task breakdown)
- Review summary (issues resolved, reviewer feedback)

**Human evaluates:**
- Does this make sense for our context?
- Are the dependencies correct?
- Is the testing strategy appropriate?
- Any concerns or changes needed?

**Exit condition (Step 2):** Human approves: "Proceed with execution."

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
Commit
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

**Build-to-Design Verification (after all tasks complete):**

Before proceeding to Phase 7, verify implementation against design:

1. Re-read design.md
2. For each major design requirement, identify where it's implemented
3. Simple checklist format:
   ```
   Design Requirement → Implementation
   - [ ] Two MCP tools (list_models, review) → external_review_server.py
   - [ ] Parallel execution → asyncio.gather in review()
   - [ ] Provider abstraction → providers/base.py + 2 implementations
   ```
4. Flag gaps: fix small ones, flag significant ones for human

Not a full audit. A structured sanity check: "did we build what we designed?"

**What gets maintained during Build:**
- `tasks.md` — Updated as tasks complete
- `status.md` — Updated by primary agent (not sub-agents)
- `backlog.md` — New ideas/improvements captured
- Decision log (in plan.md) — Key implementation decisions documented

**Critical rule:** Do NOT ask for human testing until:
- All tasks marked complete
- Automated tests pass (95%+ rate)
- Basic functionality verified
- Agent has done thorough self-validation
- Build-to-design verification complete

**Exit signal:** All tasks complete. Automated tests pass. Build-to-design verification complete. Ready for documentation.

---

### 7. Documentation

**Purpose:** Write documentation while the build is fresh. Don't defer — context degrades rapidly.

**Activities:**
- Write/update README.md (installation, usage, key features)
- Create API docs or tool reference (if applicable)
- Document configuration options
- Write testing instructions

**Documentation by project type:**

| Type | Required Docs |
|------|---------------|
| App | README (install, run, configure), architecture notes |
| MCP Server | README (install, .mcp.json wiring, tool reference), testing instructions |
| Workflow | README (trigger setup, configuration), runbook |
| Artifact | README (usage, inputs/outputs), format spec |

**Exit signal:** Documentation exists, is accurate, enables a new user to use the deliverable.

---

### 8. Closeout

**Purpose:** Structured verification, cleanup, and seal. This is not a formality — it's the quality gate.

**Ordered checklist:**

#### 8.1 Cleanup

- [ ] .gitignore updated (venv, node_modules, __pycache__, build artifacts)
- [ ] Transient files deleted (temp outputs, debug logs)
- [ ] No secrets in repo
- [ ] No commented-out code blocks

#### 8.2 Success Criteria Gate

- [ ] Load brief.md → success criteria
- [ ] Map each criterion to evidence (code location, test result, feature)
- [ ] Mark each: met / partial (with explanation) / not met (BLOCKS completion)
- [ ] Document mapping in status.md

#### 8.3 Artifact Lifecycle

- Keep in `docs/`: intent.md, brief.md, design.md (cross-stage reference)
- Archive to `docs/acm/archive/`: plan.md, tasks.md, manifest.md, capabilities.md
- Keep in project: deliverable, tests, documentation

#### 8.4 Commit Verification

- [ ] No uncommitted changes
- [ ] Commit history shows atomic commits (not one giant commit)

#### 8.5 status.md Update (THE SEAL)

- Mark stage complete
- Include structured stage handoff (per ACM-STAGES-SPEC.md Stage Boundary Handoff Protocol)
- This is the LAST step

---

## Testing Strategy

Testing is not optional. It's core to Develop.

### Planning-Time Decisions (Phase 2-3)

- plan.md MUST specify frameworks, coverage targets, browser testing plan
- capabilities.md MUST include testing tools in the Testing Capabilities section
- If planning doesn't answer these questions, Phase 3 is incomplete:
  - What test framework?
  - What gets unit tested vs integration tested vs E2E tested?
  - What's the coverage target?
  - Is browser testing needed? With what tool?

### Two-Tier Testing Model

| Tier | What | When | Tools |
|------|------|------|-------|
| **Tier 1: Automated** | Unit, integration, E2E via frameworks | During build | Jest, Pytest, Vitest, Playwright |
| **Tier 2: Real-world** | Interactive testing in browser or inspector | After automated tests pass | Claude in Chrome, MCP Inspector |

### Testing by Project Type

| Type | Automated Focus | Browser Testing? |
|------|-----------------|------------------|
| App | Unit, integration, E2E, accessibility | Yes (Claude in Chrome) |
| MCP Server | Tool handlers, params, error paths | Yes (MCP Inspector) |
| Workflow | Unit, integration, error handling | No (unless UI) |
| Artifact | Validation, format, content accuracy | No |

### Testing Requirements

| Level | What | When |
|-------|------|------|
| **Unit tests** | Individual functions/components | During task implementation |
| **Integration tests** | Component interactions | After related tasks complete |
| **End-to-end tests** | Full user flows | Before human handoff |
| **Smoke tests** | Basic functionality | Continuous |

---

## Commit Cadence

**Hard requirements:**
- Commit after every task completion
- Commit at every phase boundary
- Commit before requesting human input
- Conventional format: `type(scope): description`

**Anti-patterns:**
- One giant commit at the end
- "wip" commit messages
- Uncommitted work across sessions
- Skipping commits between phases

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

### Universal Criteria

Per ACM-STAGES-SPEC.md:

- [ ] Primary deliverable(s) exist with required content
- [ ] No Critical or High issues open (post-review)
- [ ] Alignment verified with intent.md and brief.md
- [ ] All work committed (atomic commits, no uncommitted changes)
- [ ] Documentation appropriate to deliverable exists
- [ ] Workspace cleanup complete (no transients, .gitignore current)
- [ ] status.md updated with stage completion (THE SEAL — last step)
- [ ] Human sign-off obtained

### Develop-Specific Criteria

- [ ] Automated tests pass (95%+ rate)
- [ ] Build-to-design verification complete
- [ ] Success criteria from brief mapped to evidence (all met)

### Type-Specific Criteria

| Type | Additional Criteria |
|------|---------------------|
| App | Browser testing complete, accessibility checked |
| MCP Server | Inspector testing complete |
| Workflow | Error handling tested |
| Artifact | Format validation passes |

**The handoff test:** Human tests the most basic functionality. If it fails, Develop is not done.

**Registration and deployment are Deliver stage activities.** Do not include .mcp.json registration, capability registry updates, or deployment in Develop exit criteria.

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
| docs/acm/plan.md | Develop stage (after created) | Implementation guide |
| docs/acm/tasks.md | Develop stage (after created) | Task tracking |
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
│  │  - plan.md           │  (phases, milestones, testing strategy)   │
│  │  - tasks.md          │  (atomic tasks with testing column)       │
│  └──────┬───────────────┘                                           │
│         │ "Plan drafted"                                            │
│         ▼                                                           │
│  ┌────────────────────────────────────────────────────────┐         │
│  │                    REVIEW LOOP                          │         │
│  │  Per ACM-REVIEW-SPEC.md                                 │         │
│  │  Internal (Ralph Loop) then External (user-driven)      │         │
│  └────────────────────────────────────────────────────────┘         │
│         │ "No Critical/High issues"                                 │
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
│  │  - Design verify     │                                           │
│  └──────┬───────────────┘                                           │
│         │ "All tests pass + design verified"                        │
│         ▼                                                           │
│  ┌──────────────────────┐                                           │
│  │   DOCUMENTATION      │  Human: None | Agent: High                │
│  │  - README            │                                           │
│  │  - API docs          │                                           │
│  │  - Testing guide     │                                           │
│  └──────┬───────────────┘                                           │
│         │ "Docs complete"                                           │
│         ▼                                                           │
│  ┌──────────────────────┐                                           │
│  │      CLOSEOUT        │  Human: Low | Agent: High                 │
│  │  - Cleanup           │                                           │
│  │  - Success criteria  │                                           │
│  │  - Archive artifacts │                                           │
│  │  - THE SEAL          │                                           │
│  └──────┬───────────────┘                                           │
│         │ "Stage complete"                                          │
│         ▼                                                           │
│  ┌──────────────────────────────────────┐                           │
│  │  OUTPUTS: Deliverable + docs + seal   │                          │
│  └──────────────────────────────────────┘                           │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                        DELIVER STAGE
```

---

## Revision History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-28 | Initial specification |
| 1.1.0 | 2026-01-29 | Added registry query step, testing capabilities section |
| 1.2.0 | 2026-01-29 | Added phase boundary protocol with context clearing |
| 1.3.0 | 2026-01-31 | Added handoff block in tasks.md, registry summary enforcement |
| 2.0.0 | 2026-02-01 | Major revision: 8 phases (added Documentation + Closeout), two-tier testing model, progressive disclosure in tasks.md, build-to-design verification, commit cadence, universal + type-specific exit criteria, removed registration from Develop |
| 2.1.0 | 2026-02-02 | Fixed HARD GATE placement (B61): Moved from after Phase 3 to after Phase 4 (Review Loop). Correct pattern: Plan → Review → HARD GATE → Execution. Phase 4 now "Review Loop & Approval" combining internal/external review + human approval. Matches Deliver spec pattern. Updated start-develop-prompt.md to v2.2.0. |

---

## References

- ACM-STAGES-SPEC.md (Universal exit criteria, stage boundary handoff)
- ACM-REVIEW-SPEC.md (Review mechanism — cycles, severity, stop conditions)
- ACM-DESIGN-SPEC.md (Design is primary input)
- ACM-BRIEF-SPEC.md (Success criteria reference)
- ACM-INTENT-SPEC.md (North Star reference)
- ACM-PROJECT-TYPES-SPEC.md (Deliverable shape)
- ACM-FOLDER-STRUCTURE-SPEC.md (docs/acm/ convention)
- ACM-TAXONOMY.md (Terminology)
