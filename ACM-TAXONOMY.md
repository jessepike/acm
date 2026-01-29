---
type: "reference"
description: "ACM classification system, terminology, and design decisions"
version: "1.4.0"
updated: "2026-01-29"
scope: "acm"
lifecycle: "reference"
location: "acm/ACM-TAXONOMY.md"
---

# ACM Taxonomy

## Purpose

Define the classification system, terminology, and design decisions for ACM. Ensures consistency and prevents revisiting resolved discussions.

---

## Core Terms

### Review vs Validation

| Term | Definition | Use When |
|------|------------|----------|
| **Review** | Subjective, probabilistic feedback. "Does this make sense? What's missing? What could be better?" | External model feedback on Briefs. Human judgment calls. Qualitative assessment. |
| **Validation** | Deterministic check against specific criteria. "Does this meet requirement X? Yes or no." | Exit criteria checks. Schema validation. Automated gates. |

**Decision:** Use "review" for the feedback loop in Discover. Use "validation" for exit criteria checks.

---

### Spec vs Template

| Term | Definition | Use When |
|------|------------|----------|
| **Spec** | Rules, structure, requirements. Explains what and why. Agents generate artifacts from specs. | Defining artifact structures. Providing requirements. |
| **Template** | Scaffold with placeholders. Fill-in-the-blank document. Copy and populate. | Avoided in ACM. Agents generate fresh from specs. |

**Decision:** ACM uses specs, not templates. Specs include format examples for reference, but agents generate artifacts based on spec requirements rather than copying scaffolds.

**Rationale:**
- Agents can generate structure from specs; they don't need copy/paste scaffolds
- Templates become stale if spec changes
- Templates add maintenance overhead
- Specs explain *why*, templates just show *what*

---

### Intent vs Brief

| Term | Definition | Size | Stability | Context Loading |
|------|------------|------|-----------|-----------------|
| **Intent** | North Star. Why we're doing this. Problem, outcome, why it matters. | ~50-150 words | Stable — rarely changes | Every agent, every stage |
| **Brief** | Detailed contract. What, scope, success criteria, constraints. | ~300-800 words | Evolves in Discover, stable after | Consumed in Design, referenced in Develop/Deliver |

**Decision:** Separate documents. Intent travels everywhere (minimal context cost). Brief is pulled when needed (progressive disclosure).

---

## Project Classification Terms

### Primary Types

| Type | Definition |
|------|------------|
| **Artifact** | Single deliverable. Done when shipped. (Report, deck, workbook) |
| **App** | Deployed software with users. Ongoing lifecycle. (Website, mobile app, API) |
| **Workflow** | Automation/orchestration. May run standalone or feed into Apps. (Pipeline, integration, scheduled job) |

### Scale Modifiers

| Modifier | Definition |
|----------|------------|
| `personal` | Just you. Private. Low stakes, fast iteration. |
| `shared` | Known users — family, friends, small group. Moderate expectations. |
| `community` | Public access. Not monetized. Open contribution possible. |
| `commercial` | Revenue intent. Business requirements. Support expectations. |

### Scope Modifiers

| Modifier | Definition |
|----------|------------|
| `mvp` | Minimum viable. Ship fast, validate, iterate. |
| `full-build` | Complete implementation per spec. |

### Complexity Modifiers

| Modifier | Definition |
|----------|------------|
| `standalone` | Single component. Self-contained. |
| `multi-component` | Multiple services, apps, or systems working together. |

---

## Stage Terms

### Stages

| Stage | Core Question | Primary Output |
|-------|---------------|----------------|
| **Discover** | "What are we trying to accomplish?" | Intent, Brief |
| **Design** | "How will we approach it?" | Architecture, tech decisions |
| **Develop** | "Are we building it correctly?" | The thing itself |
| **Deliver** | "Is this increment done and usable?" | Deployed/shipped deliverable |

### Discover Phases

| Phase | Definition |
|-------|------------|
| **Exploration** | Divergent brainstorming. Gathering ideas, research, following threads. |
| **Crystallization** | Synthesis into structured artifacts. Drafting Intent and Brief. |
| **Review Loop** | Structured feedback cycles with external reviewer models. |
| **Finalization** | Exit criteria check, constraints pass, handoff prep. |

### Design Phases

| Phase | Definition |
|-------|------------|
| **Intake & Clarification** | Understand Brief, resolve ambiguities through structured questioning. High human interaction. |
| **Technical Design** | Produce design artifacts — architecture, interface, data model, capabilities. |
| **Review Loop** | Two-phase review (internal Ralph Loop → external models) of design decisions. |
| **Finalization** | Exit criteria check, handoff prep for Develop. |

### Develop Phases

| Phase | Definition |
|-------|------------|
| **Intake & Validation** | Ensure full understanding of design. Close loose ends via structured questions. |
| **Capability Assessment** | Identify dependencies (manifest.md) and capabilities (skills, tools, sub-agents). |
| **Planning** | Create implementation plan (plan.md) and atomic task breakdown (tasks.md). |
| **Review Loop** | Two-phase review of plan and capabilities before environment setup. |
| **Environment Setup** | Install dependencies, configure capabilities, verify environment. |
| **Build** | Actual implementation with TDD, sub-agent parallelization, thorough testing. |

---

## Document Lifecycle Terms

### Brief Status

| Status | Definition |
|--------|------------|
| `draft` | Initial capture. Rough, incomplete, exploratory. |
| `in-review` | Undergoing review loop with external reviewers. |
| `complete` | Exit criteria met. Ready for next stage handoff. |

### Design Status

| Status | Definition |
|--------|------------|
| `intake` | Clarification phase — gathering decisions from human. |
| `drafting` | Technical design in progress. |
| `internal-review-complete` | Passed Ralph Loop, ready for external review. |
| `complete` | Exit criteria met. Ready for Develop handoff. |

### Develop Status

| Status | Definition |
|--------|------------|
| `intake` | Validation phase — ensuring full understanding of design. |
| `capability-assessment` | Identifying dependencies and capabilities needed. |
| `planning` | Creating plan.md and tasks.md. |
| `internal-review-complete` | Plan passed Ralph Loop, ready for external review. |
| `environment-setup` | Installing dependencies, configuring capabilities. |
| `building` | Active implementation in progress. |
| `complete` | All tasks done, tests pass, ready for Deliver. |

### Issue Priority

| Priority | Definition |
|----------|------------|
| **P1** | Must resolve before stage completion. Blocker. |
| **P2** | Should resolve. May defer to next stage with rationale. |
| **P3** | Nice to have. Can defer or drop. |

### Issue Status

| Status | Definition |
|--------|------------|
| `Open` | Not yet addressed. |
| `In Progress` | Being worked on. |
| `Resolved` | Addressed and closed. |
| `Deferred` | Explicitly pushed to later stage with rationale. |

---

## Environment Terms

### Environment Taxonomy

| Term | Definition |
|------|------------|
| **Environment** | Umbrella term for everything managed by acm-env — capabilities, configuration, and context |
| **Capabilities** | Plugins, MCP servers, hooks, skills, agents, tools — the functional extensions |
| **Configuration** | settings.json, keybindings — the behavioral settings |
| **Context** | CLAUDE.md files, rules/ — the knowledge artifacts that inform agent behavior |
| **Baseline** | Machine-parseable definition of expected environment state at each level |
| **Drift** | Deviation from baseline — detected by session hook or audit |
| **User level** | `~/.claude/` — cross-project configuration |
| **Project level** | `.claude/` — project-specific configuration |

---

## Context Management Terms

### Context Loading

| Term | Definition |
|------|------------|
| **Always load** | Documents loaded into every agent context. (Intent, CLAUDE.md) |
| **Consumed** | Documents fully loaded and processed in a specific stage. (Brief in Design) |
| **Referenced** | Documents available on-demand but not pre-loaded. (Brief in Develop/Deliver) |

### Progressive Disclosure

Principle: Load only the context needed for the current task. Expand on demand. Avoid overwhelming agents with unnecessary information.

---

## Agent Role Terms

| Term | Definition |
|------|------------|
| **Primary Agent** | The agent working directly with the human through a stage. Holds project context. Orchestrates work. Updates status.md. |
| **Reviewer Agent** | External model providing feedback on artifacts. Session-stateful but not project-stateful. Specialists, not stewards. |
| **Sub-Agent** | Agent spawned by primary agent for parallel task execution. Completes tasks, marks them done. Does NOT update status.md. |

---

## Core Maintainable Artifacts

Artifacts have different maintenance requirements. This tier system clarifies expectations.

### Tier 1: Always (Every Session)

| Artifact | Purpose | Update Trigger |
|----------|---------|----------------|
| `status.md` | Session state | End of every session |
| `CLAUDE.md` | Context manifest | Stage changes, structure changes |

Tier 1 artifacts maintain session continuity. Failing to update breaks the chain for future sessions.

### Tier 2: Stage-Critical (Stage Boundaries)

| Artifact | Purpose | Update Trigger |
|----------|---------|----------------|
| `intent.md` | North Star | Rarely — only if direction fundamentally changes |
| `brief.md` | Project contract | Discover stage (then stable) |
| `README.md` | Project overview | Major milestones, stage completion |

Tier 2 artifacts define the project. They stabilize after their primary stage.

### Tier 3: Reference (When Relevant)

| Artifact | Purpose | Update Trigger |
|----------|---------|----------------|
| Architecture docs | Technical decisions | Design stage, major changes |
| Decision log | Why decisions were made | When decisions are made |
| Research notes | Background information | During research |

Tier 3 artifacts support the project. Updated opportunistically, not mandatorily.

**Enforcement:** Tier 1 is mandatory. Tier 2 is expected at boundaries. Tier 3 is good practice.

---

## Design Decisions Log

Decisions made during ACM development that should not be revisited without explicit reason.

| Decision | Rationale | Date |
|----------|-----------|------|
| Specs over templates | Agents generate better from specs; templates add maintenance burden | 2026-01-27 |
| Review over validation (for feedback loops) | Review = subjective/probabilistic; validation = deterministic checks | 2026-01-27 |
| Intent separate from Brief | Intent is universal context (low cost); Brief is stage-specific (progressive disclosure) | 2026-01-27 |
| Flat file structure with stage prefixes | Simpler than nested folders; agents parse faster; naming provides organization | 2026-01-27 |
| CLAUDE.md as context manifest | Single source for agent instructions + context loading; no extra files | 2026-01-27 |
| Separate status.md for session state | Keeps CLAUDE.md clean; status.md is lightweight dynamic state; scales to tasks.md in Develop | 2026-01-27 |
| Taxonomy over Glossary | Taxonomy = classification system + definitions; more accurate for what ACM captures | 2026-01-27 |
| 500-line breakout threshold | Research-backed: LLM context efficiency (~3,500 tokens), human cognitive load, industry standards | 2026-01-27 |
| design.md as primary Design artifact | Single document for most projects; break out at 500 lines; capabilities section (not separate file) | 2026-01-27 |
| "Interface & Format Spec" over "UI/UX" | Applies to all project types — Apps have UI, Artifacts have format, Workflows have integration surfaces | 2026-01-27 |
| Capabilities identified in Design, modifiable in Develop | Design recommends tools/skills/agents; Develop can add/remove during implementation | 2026-01-27 |
| No timeline/effort estimation in Design | LLMs are unreliable at effort estimation; excluded from intake questions | 2026-01-27 |
| Separate manifest.md and capabilities.md | Dependencies (software) vs capabilities (skills/tools/agents) come from different sources | 2026-01-28 |
| TDD approach with 95%+ pass rate | Thorough automated testing before human involvement; prevents wasted human time | 2026-01-28 |
| Primary agent owns status.md | Sub-agents complete tasks but don't update session state; prevents conflicts | 2026-01-28 |
| Atomic tasks for single-agent execution | Tasks small enough to read-complete-verify in one agent session | 2026-01-28 |
| Design updates in Develop: document and move on | No re-review needed for gaps discovered during implementation prep | 2026-01-28 |
| acm-env as user-level plugin | Manages environment across all projects; sits at highest non-managed layer | 2026-01-29 |
| Environment as umbrella term (capabilities + configuration + context) | Encompasses all configurable elements of Claude Code | 2026-01-29 |
| Wrapper/delegation over internalization of Anthropic plugins | Leverage upstream improvements; YAGNI; ACM adds spec/orchestration layer | 2026-01-29 |
| Graceful degradation with loud warnings (never silent failure) | User must always know what's missing or broken | 2026-01-29 |
| Absorb deferred acm-validate and acm-prune into acm-env | Single plugin with multiple skills; modular growth | 2026-01-29 |
| Smart mode detection over separate commands | One /acm-env:setup handles first-time, new project, existing project | 2026-01-29 |
| Codified baseline spec (machine-parseable YAML) over prose guidelines | Enables automated drift detection and comparison | 2026-01-29 |
| Rename consideration: "Agentic Development Environment" | Under consideration; deferred to validation after acm-env proves concept | 2026-01-29 |

---

## References

- ACM-BRIEF-SPEC.md
- ACM-INTENT-SPEC.md
- ACM-PROJECT-TYPES-SPEC.md
- ACM-DISCOVER-SPEC.md
- ACM-DESIGN-SPEC.md
- ACM-DEVELOP-SPEC.md
- ACM-STAGES-SPEC.md
- ACM-ENV-SPEC.md
- kb/DOCUMENT-BREAKOUT-THRESHOLD.md
- kb/REVIEW-CYCLE-GUIDANCE.md
