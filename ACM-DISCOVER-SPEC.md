---
type: "specification"
description: "Detailed specification for the Discover stage workflow"
version: "1.2.0"
updated: "2026-01-27"
scope: "acm"
lifecycle: "reference"
location: "acm/ACM-DISCOVER-SPEC.md"
---

# ACM Discover Stage Specification

## Purpose

Define the Discover stage — the first stage in the ACM workflow where raw ideas become a clear, validated Brief ready for Design.

---

## Stage Overview

> **"What are we trying to accomplish?"**

Discover transforms a rough concept into a structured, reviewed Brief. The primary agent works with the human to explore, crystallize, review, and finalize the project definition.

**Deliverables:**
- `intent.md` — North Star (stable, universal)
- `discover-brief.md` — Detailed contract (evolves through review)

---

## Phase Model

| Phase | Description | Human Involvement | Agent Involvement |
|-------|-------------|-------------------|-------------------|
| **Exploration** | Divergent brainstorming — gathering ideas, researching, following threads | High | Low (conversational support) |
| **Crystallization** | Synthesis into coherent draft Brief and Intent | Low-Medium | High (structuring, drafting) |
| **Review Loop** | Structured feedback cycles with external reviewer models | Medium (orchestrating, deciding) | High (processing, integrating) |
| **Finalization** | Exit criteria check, constraints pass, handoff prep | Medium (sign-off) | High (validation checks) |

---

## Inputs

What enters the Discover stage:

| Input | Source | Description |
|-------|--------|-------------|
| Raw idea | Human | Initial concept — may be vague, incomplete, or ambitious |
| Project type guess | Human | Initial classification (Artifact, App, Workflow) |
| Domain context | Human/Research | Relevant background, constraints, prior art |
| ACM specs | Meta layer | Brief spec, Intent spec, Project Types spec |

---

## Outputs

What Discover produces:

| Output | Description | Location |
|--------|-------------|----------|
| `intent.md` | Stable North Star — problem, outcome, why it matters | `/docs/intent.md` |
| `discover-brief.md` | Detailed contract with all required sections | `/docs/discover-brief.md` |

Both artifacts must pass exit criteria before handoff to Design.

---

## Phase Details

### 1. Exploration

**Purpose:** Gather the puzzle pieces. Understand the problem space.

**Activities:**
- Brainstorm with models (conversational, broad)
- Research prior art, competitors, adjacent solutions
- Capture rough notes, questions, possibilities
- Identify constraints and dependencies

**Agent role:** Conversational partner. Ask clarifying questions. Surface considerations. Don't structure yet — let ideas flow.

**Human role:** Provide direction, domain knowledge, gut instincts. Follow interesting threads.

**Exit signal:** Enough raw material to start structuring. Human says "I think I have enough to crystallize."

---

### 2. Crystallization

**Purpose:** Synthesize exploration into structured artifacts.

**Activities:**
- Draft `intent.md` — distill to problem, outcome, why it matters
- Draft `discover-brief.md` — structure per Brief spec
- Assign project classification (type + modifiers)
- Identify initial scope boundaries
- Capture open questions

**Agent role:** Heavy lifting. Take raw inputs and structure them. Propose draft language. Identify gaps.

**Human role:** Review, adjust, approve direction. Fill in domain-specific details.

**Exit signal:** Draft Brief exists with all core sections populated (may be rough). Ready for external review.

---

### 3. Review Loop

**Purpose:** Stress-test the Brief through thorough review — first with the primary agent (internal), then with external models for diverse perspectives.

**Two-Phase Review Model:**

The review loop has two phases based on *who* reviews, not *what kind* of review:

| Phase | Reviewer | Mechanism | Value |
|-------|----------|-----------|-------|
| **Phase 1: Internal** | Primary agent (Claude) | Ralph Loop — automated iteration | Fast iteration, handles the grind, gets Brief to solid baseline |
| **Phase 2: External** | Other models (GPT, Gemini) | Manual submission | Diverse perspectives, catches blind spots, cross-checks assumptions |

**Why two phases:** Single-model review, no matter how thorough, has blind spots. External models bring different training, different biases, different strengths. The combination produces higher quality than either alone.

---

#### Phase 1: Internal Review (Ralph Loop)

**Purpose:** Thorough self-review and iteration. Get the Brief as strong as possible before external eyes see it.

**Mechanism:** Ralph Loop plugin with Claude — iterates until no P1 issues remain.

**Review scope:** Comprehensive. The internal reviewer should challenge everything:

- **Completeness** — All required sections populated? Gaps?
- **Clarity** — Would someone new understand this? Ambiguous language?
- **Measurability** — Success criteria verifiable? Subjective wording?
- **Scope** — Boundaries explicit? In/out clear?
- **Consistency** — Internal contradictions? Conflicts between sections?
- **Intent alignment** — Brief outcomes match Intent goals?
- **Constraint adherence** — Technical decisions honor stated constraints?
- **Downstream usability** — Would Design/Develop know what to do?
- **Assumption risk** — Unstated assumptions? Risky dependencies?
- **Feasibility** — Red flags? Unrealistic expectations?

**The goal is not a checklist — it's a thorough, critical review.** Find real issues, not cosmetic ones.

**Exit signal:** No P1 issues remain. The Brief is as strong as single-model review can make it.

**Typical iterations:** 2-5

---

#### Phase 2: External Review (Multiple Models)

**Purpose:** Get perspectives the internal reviewer missed. Different models catch different things.

**Mechanism:** Submit Brief + Intent to external models (GPT, Gemini, others). Manual orchestration.

**Review scope:** Also comprehensive, but with emphasis on:

- What the internal reviewer might have missed or been too lenient on
- Cross-artifact alignment (Intent vs Brief coherence)
- Domain-specific blind spots
- Assumptions that seem reasonable to one model but questionable to another
- Edge cases and failure modes
- Audience/market considerations

**Process:**
1. Submit Brief + Intent to 2+ external models
2. Collect feedback, extract discrete issues
3. Log issues with source attribution
4. Prioritize: High-impact issues from multiple reviewers = P1
5. Address P1s, assess P2s
6. Re-submit if major issues found

**Exit signal:** External reviewers find no new P1 issues. Cross-reviewer consensus on core elements.

**Typical cycles:** 1-2

---

#### Review Cycle Guidance by Type

| Type + Scale | Phase 1 (Internal) | Phase 2 (External) | Total Cycles |
|--------------|---------------------|---------------------|--------------|
| Artifact | 1-2 | 1 | 2-3 |
| App (personal) | 2-3 | 1 | 3-4 |
| App (shared/community) | 2-4 | 1-2 | 3-6 |
| App (commercial) | 3-5 | 2-3 | 5-8 |
| Workflow | 2-3 | 1-2 | 3-5 |

---

#### Convergence Signals

- Issue count decreasing across cycles
- Cross-reviewer consensus on core elements
- Diminishing returns on new feedback
- No P1 issues remaining
- External reviewers validate rather than challenge

---

### 4. Finalization

**Purpose:** Verify exit criteria. Prepare for Design handoff.

**Activities:**
- Run exit criteria checklist
- Ensure all P1 issues resolved
- Confirm open questions are resolved or explicitly deferred
- Add/verify constraints section (resources, timeline, dependencies)
- Update Session State to phase: complete
- Human sign-off

**Agent role:** Run validation checks. Flag any gaps. Prepare handoff summary if needed.

**Human role:** Final review and approval.

**Exit signal:** All exit criteria met. Human confirms ready for Design.

---

## Exit Criteria

Discover is complete when:

- [ ] `intent.md` exists and passes Intent spec validation
- [ ] `discover-brief.md` exists with all required sections (core + type-specific)
- [ ] Project classification assigned (type + modifiers)
- [ ] Scope boundaries clear (in/out explicit)
- [ ] Success criteria are verifiable (not vague)
- [ ] No P1 issues open in Issue Log
- [ ] Open Questions empty or deferred to Design with rationale
- [ ] Constraints documented
- [ ] Session State shows phase: complete
- [ ] Human sign-off

---

## Context Loading

### What the Primary Agent Needs

The agent working through Discover needs context on:

1. **ACM Framework** — What is ACM, what stage are we in, how does it work
2. **Stage Workflow** — This spec (phases, activities, exit criteria)
3. **Artifact Specs** — Brief spec, Intent spec
4. **Project Types** — Classification system
5. **Current State** — Where we left off (from Session State in Brief)

### Context Map (for CLAUDE.md)

```markdown
## Context Map

| File | Load When | Purpose |
|------|-----------|---------|
| intent.md | Always | North Star |
| discover-brief.md | Discover stage | Working Brief |
| ACM-DISCOVER-SPEC.md | Discover stage (reference) | Stage workflow |
| ACM-BRIEF-SPEC.md | Discover stage (reference) | Brief structure |
| ACM-INTENT-SPEC.md | Discover stage (reference) | Intent structure |
| ACM-PROJECT-TYPES-SPEC.md | Discover stage (reference) | Classification |
```

Specs are reference documents — load on demand, not into every context.

---

## Supporting Artifacts

### Review Prompts

Two prompts support the two-phase review model:

| Prompt | Location | Purpose |
|--------|----------|---------|
| Ralph Review Prompt | `/prompts/ralph-review-prompt.md` | Phase 1 internal iteration |
| External Review Prompt | `/prompts/external-review-prompt.md` | Phase 2 external review |

#### Ralph Review Prompt

Used with Ralph Loop plugin for Phase 1 (internal review).

**Structure:**
1. Task: Thorough review and iteration until no P1 issues remain
2. Scope: Comprehensive — challenge everything, find real issues
3. Process: Read → Review → Log issues → Fix P1s → Re-review → Repeat
4. Completion: Output promise when Brief is as strong as self-review can make it

#### External Review Prompt

Used with GPT, Gemini, other external models for Phase 2.

**Structure:**
1. Context: ACM framework, Discover stage, this Brief has passed internal review
2. Input: Brief + Intent (both artifacts)
3. Task: Comprehensive review — find what the internal reviewer missed
4. Focus: Diverse perspective, blind spots, cross-artifact alignment
5. Format: Issues with impact, rationale, suggestion

### Type-Specific Review Modules

For commercial apps, workflows, etc. — additional review focus areas appended to external review prompt. See `/prompts/external-review-prompt.md` for modules.

---

## Workflow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        DISCOVER STAGE                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐                                               │
│  │  EXPLORATION │  Human: High | Agent: Low                     │
│  │  - Brainstorm│                                               │
│  │  - Research  │                                               │
│  │  - Gather    │                                               │
│  └──────┬───────┘                                               │
│         │ "Enough to crystallize"                               │
│         ▼                                                       │
│  ┌──────────────────┐                                           │
│  │  CRYSTALLIZATION │  Human: Low-Med | Agent: High             │
│  │  - Draft Intent  │                                           │
│  │  - Draft Brief   │                                           │
│  │  - Classify      │                                           │
│  └──────┬───────────┘                                           │
│         │ Draft ready                                           │
│         ▼                                                       │
│  ┌────────────────────────────────────────────────────────┐     │
│  │                    REVIEW LOOP                          │     │
│  │  ┌─────────────────┐       ┌─────────────────────────┐ │     │
│  │  │ PHASE 1:        │       │ PHASE 2:                │ │     │
│  │  │ INTERNAL        │       │ EXTERNAL                │ │     │
│  │  │                 │       │                         │ │     │
│  │  │ Ralph Loop      │  ───► │ GPT, Gemini, etc.       │ │     │
│  │  │ (Claude)        │       │                         │ │     │
│  │  │                 │       │                         │ │     │
│  │  │ Thorough self-  │       │ Diverse perspectives    │ │     │
│  │  │ review and      │       │ catch blind spots       │ │     │
│  │  │ iteration       │       │ and assumptions         │ │     │
│  │  │                 │       │                         │ │     │
│  │  │ 2-5 iterations  │       │ 1-2 cycles              │ │     │
│  │  └─────────────────┘       └─────────────────────────┘ │     │
│  └────────────────────────────────────────────────────────┘     │
│         │ Convergence reached                                   │
│         ▼                                                       │
│  ┌──────────────────┐                                           │
│  │   FINALIZATION   │  Human: Med | Agent: High                 │
│  │  - Exit criteria │                                           │
│  │  - Constraints   │                                           │
│  │  - Sign-off      │                                           │
│  └──────┬───────────┘                                           │
│         │                                                       │
│         ▼                                                       │
│  ┌──────────────────────────────────────┐                       │
│  │  OUTPUTS: intent.md, discover-brief.md │                     │
│  └──────────────────────────────────────┘                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                        DESIGN STAGE
```

---

## Session Continuity

Discover may span multiple sessions. To maintain continuity:

1. **Session State** in Brief tracks current phase, last action, next steps
2. **Issue Log** in Brief tracks all feedback and resolution status
3. **Revision History** in Brief tracks document evolution

New session workflow:
1. Agent reads CLAUDE.md (loads context map)
2. Agent reads `discover-brief.md` (gets Session State)
3. Agent picks up where previous session left off
4. At session end, agent updates Session State

---

## Capabilities Required

### Current State (Manual)

| Capability | How It Works |
|------------|--------------|
| Document creation | File system, markdown |
| LLM access (review) | Manual copy/paste to different model UIs |
| Issue tracking | In-document table |
| Orchestration | Human coordinates |

### Future State (Automated)

| Capability | How It Would Work |
|------------|-------------------|
| Document creation | Same (works fine) |
| LLM access (review) | Automated multi-model orchestration |
| Issue tracking | Automated parsing/prioritization |
| Orchestration | Automated review loops, LLM-as-judge patterns |

---

## Visual Architecture

See `prompts/architecture-visual-discover.md` for the diagram generation prompt.

The Discover stage diagram shows:
- Four-phase workflow (Exploration → Crystallization → Review Loop → Finalization)
- Two-phase review model (Internal/Ralph + External/GPT,Gemini)
- YAGNI principle prominence
- Inputs, outputs, and exit criteria

---

## References

- ACM-BRIEF-SPEC.md (Brief structure and requirements)
- ACM-INTENT-SPEC.md (Intent structure and requirements)
- ACM-PROJECT-TYPES-SPEC.md (Classification system)
- ACM-STAGES-SPEC.md (Stage overview and meta layer)
- ACM-TAXONOMY.md (Terminology definitions)
- prompts/architecture-visual-discover.md (Diagram prompt)
