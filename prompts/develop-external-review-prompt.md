---
type: "prompt"
description: "External model prompt for Phase 2 review in Develop stage"
version: "2.0.0"
updated: "2026-01-29"
scope: "develop"
usage: "Submit to GPT, Gemini, or other external models along with plan artifacts"
---

# Develop External Review Prompt (Phase 2: External Review)

## Usage

Copy the prompt below and submit to external models (GPT, Gemini, etc.) along with the project documents.

To assemble the full prompt with documents included, run from the project root:

```bash
sed \
  -e '/\[PASTE DESIGN.MD CONTENT HERE\]/{r docs/design.md' -e 'd;}' \
  -e '/\[PASTE MANIFEST.MD CONTENT HERE\]/{r docs/manifest.md' -e 'd;}' \
  -e '/\[PASTE CAPABILITIES.MD CONTENT HERE\]/{r docs/capabilities.md' -e 'd;}' \
  -e '/\[PASTE PLAN.MD CONTENT HERE\]/{r docs/plan.md' -e 'd;}' \
  -e '/\[PASTE TASKS.MD CONTENT HERE\]/{r docs/tasks.md' -e 'd;}' \
  ~/code/_shared/acm/prompts/develop-external-review-prompt.md | pbcopy
```

This copies the complete prompt (with documents inlined) to your clipboard.

---

## Prompt

```
You are reviewing an implementation plan that has already passed internal review. Your job is to catch what the internal reviewer missed — particularly feasibility issues and blind spots.

## Context

This plan has passed Phase 1 (internal) review:
- All design requirements are addressed
- Dependencies and capabilities are identified
- Tasks are atomic and have acceptance criteria
- Testing strategy is defined

You are Phase 2: a fresh perspective to catch blind spots.

## Documents Provided

1. design.md — What we're building (technical specification)
2. manifest.md — Software dependencies to install
3. capabilities.md — Skills, tools, sub-agents needed
4. plan.md — Implementation phases and milestones
5. tasks.md — Atomic task breakdown

Your job is to validate that this plan will successfully implement the design.

## YAGNI Principle — CRITICAL

Apply "You Ain't Gonna Need It" rigorously:

- Only flag issues that would block or significantly harm implementation
- Do NOT suggest features or capabilities beyond the design
- Do NOT recommend over-engineering
- Do NOT add "nice to have" tooling or testing
- If something is out of scope, respect that decision

The test: "If this isn't fixed, will the build fail or produce something significantly wrong?" If no, don't report it.

## Your Task

Review all artifacts together. Look for:

1. **Design/Plan Misalignment** — Does the plan actually implement everything in the design? Any gaps?

2. **Dependency Gaps** — Are there missing dependencies that will block implementation? Version conflicts?

3. **Capability Gaps** — Are the identified skills/tools/sub-agents sufficient? Anything missing?

4. **Task Coverage** — Do the tasks cover all the work needed? Any design elements with no corresponding tasks?

5. **Task Feasibility** — Are any tasks too large or too vague for single-agent execution?

6. **Sequencing Issues** — Are there dependency problems in the task ordering? Things that will block?

7. **Testing Gaps** — Will the testing strategy catch real issues? Any critical paths not tested?

8. **Integration Risks** — Are there integration points that seem fragile or under-planned?

## Output Format

### Issues Found

For each significant issue only:
- Issue: [Brief description]
- Impact: High / Medium (no Low)
- Rationale: [Why this blocks or harms implementation]
- Suggestion: [Minimal fix]

If you find no significant issues, say so. An empty Issues section is valid.

### Strengths

What's working well? (2-3 points max)

### Questions for Build

Questions that will need to be answered during implementation — NOT suggestions for scope expansion.

Rules:
- Only include questions where the answer affects implementation
- Each question must relate to something already in the plan
- Do NOT use this to suggest features
- If no questions meet criteria, leave empty

## What NOT To Do

- Do NOT suggest adding features or capabilities beyond design
- Do NOT flag cosmetic issues
- Do NOT report issues just to have something to report
- Do NOT over-engineer — this is MVP-focused
- Do NOT second-guess explicit design decisions

## What You're Solving For

The plan is ready for Environment Setup when:
- All design requirements have corresponding tasks
- Dependencies and capabilities are complete
- Tasks are atomic and executable
- Testing strategy will catch real issues
- No major gaps or risks

Your job is to confirm it's ready, or identify specific things preventing that. Nothing more.

---

## Design Document

[PASTE DESIGN.MD CONTENT HERE]

---

## Manifest Document

[PASTE MANIFEST.MD CONTENT HERE]

---

## Capabilities Document

[PASTE CAPABILITIES.MD CONTENT HERE]

---

## Plan Document

[PASTE PLAN.MD CONTENT HERE]

---

## Tasks Document

[PASTE TASKS.MD CONTENT HERE]
```

---

## Type-Specific Modules

### App Module

Add for App projects:

```
Additional checks for Apps:

- **Build Pipeline** — Is there a clear path from code to running application?
- **State Management** — Are state patterns appropriate for the complexity?
- **Error Handling** — Are error states and edge cases covered in tasks?
```

### Workflow Module

Add for Workflow projects:

```
Additional checks for Workflows:

- **Orchestration** — Is the execution flow clear and testable?
- **Failure Recovery** — Are retry and rollback strategies defined?
- **Idempotency** — Can steps be safely re-run if interrupted?
```

### Artifact Module

Add for Artifact projects:

```
Additional checks for Artifacts:

- **Content Pipeline** — Is the process from inputs to output clear?
- **Validation** — How will output quality be verified?
- **Format Compliance** — Are format requirements covered in tasks?
```

---

## Capturing Feedback

After receiving external feedback:

1. Filter aggressively — Ignore suggestions that expand scope
2. Extract only issues that block implementation
3. Log in plan.md Issue Log with source attribution
4. Cross-reference reviewers — single-model issues may not be P1
5. P1 = blocks Build or creates significant problems

---

## When to Stop Reviewing

**Cycle stop rules (same as internal review):**

- **Minimum:** 2 external review cycles
- **Stop when:** A cycle produces zero Critical and zero High severity issues
- **Hard maximum:** 10 cycles
- **Typical:** 1-2 rounds for most projects.

**Per cycle, ask:** "Did this cycle surface any Critical or High issues?" If no, you're done.

**Cross-reviewer signal:** If multiple reviewers flag the same issue, it's likely Critical or High regardless of how each reviewer rated it.
