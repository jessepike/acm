---
type: "prompt"
description: "External model prompt for Phase 2 review in Design stage"
version: "2.0.0"
updated: "2026-01-29"
scope: "design"
usage: "Submit to GPT, Gemini, or other external models along with design.md, Brief, and Intent"
---

# Design External Review Prompt (Phase 2: External Review)

## Usage

Copy the prompt below and submit to external models (GPT, Gemini, etc.) along with the project documents.

To assemble the full prompt with documents included, run from the project root:

```bash
sed \
  -e '/\[PASTE INTENT.MD CONTENT HERE\]/{r docs/intent.md' -e 'd;}' \
  -e '/\[PASTE DISCOVER-BRIEF.MD CONTENT HERE\]/{r docs/discover-brief.md' -e 'd;}' \
  -e '/\[PASTE DESIGN.MD CONTENT HERE\]/{r docs/design.md' -e 'd;}' \
  ~/code/_shared/acm/prompts/design-external-review-prompt.md | pbcopy
```

This copies the complete prompt (with documents inlined) to your clipboard.

---

## Prompt

```
You are reviewing a Design specification that has already passed internal review. Your job is to catch what the internal reviewer missed — particularly technical blind spots and architectural weaknesses.

## Context

This design has passed Phase 1 (internal) review:
- All required sections are populated
- Design aligns with Brief requirements
- Architecture decisions are documented
- Capabilities are identified

You are Phase 2: a fresh technical perspective to catch blind spots.

## Documents Provided

1. **Intent** — The project's North Star (why we're doing this)
2. **Brief** — The detailed contract (what we're building)
3. **Design** — The technical specification (how we're building it)

Your job is to validate that the Design soundly delivers what the Brief requires.

## YAGNI Principle — CRITICAL

Apply "You Ain't Gonna Need It" rigorously. This is the most important instruction:

- Only flag issues that would **block or significantly harm** implementation
- Do NOT suggest features, components, or additions
- Do NOT ask "what about X?" unless X is critical to Brief requirements
- If something is explicitly out of scope, respect that decision
- Do NOT backdoor scope expansion as "architectural considerations"
- Low-impact issues should not be reported at all

**The test for every issue:** "If this isn't fixed, will the implementation fail or be significantly flawed?" If no, don't report it.

## Your Task

Review the Design against the Brief and Intent. Look for:

1. **Brief/Design Misalignment** — Does the design actually deliver what the Brief requires? Are there Brief requirements the design doesn't address?

2. **Architectural Weaknesses** — Are there technical decisions that seem unsound, risky, or inappropriate for the requirements?

3. **Tech Stack Fit** — Are the chosen technologies appropriate for the constraints and requirements? Any red flags?

4. **Interface Gaps** — Would a developer know what to build? Are there UI/UX or format decisions that are too vague?

5. **Data Model Issues** — Do the data structures support the requirements? Any integrity or scalability concerns?

6. **Capability Gaps** — Are the identified tools/skills/agents sufficient? Any obvious missing dependencies?

7. **Integration Risks** — Are there integration points that seem fragile or underspecified?

8. **Security Concerns** — Any obvious security issues given the requirements? (Don't audit exhaustively — just flag obvious gaps)

## Output Format

### Issues Found

For each **significant** issue only:
- **Issue:** [Brief description]
- **Impact:** High / Medium (no Low — if it's low impact, don't report it)
- **Rationale:** [Why this blocks or harms implementation]
- **Suggestion:** [Minimal fix — not scope expansion]

**If you find no significant issues, say so.** An empty Issues section is a valid outcome.

### Strengths

What's working well technically? (2-3 points max)

### Questions for Develop

Questions that Develop needs to answer during implementation — NOT suggestions for scope expansion.

Rules for this section:
- Only include questions where the answer affects implementation decisions
- Each question must relate to something already in the design
- Do NOT use this section to suggest features or components
- Do NOT ask "have you considered adding X?"
- If you can't think of questions that meet these criteria, leave this section empty

## What NOT To Do

- Do NOT suggest adding features, components, or capabilities beyond Brief scope
- Do NOT flag cosmetic issues (naming, formatting, minor clarity)
- Do NOT report issues just to have something to report
- Do NOT treat "Questions" as a backdoor for suggestions
- Do NOT second-guess explicit scope decisions from the Brief
- Do NOT recommend "enterprise" patterns for personal/MVP projects
- Do NOT suggest over-engineering for simplicity's sake

## What You're Solving For

The Design is ready for Develop when:
- Architecture is sound for the requirements
- A developer would know what to build
- Technology choices are appropriate
- Interface/format is clear
- Capabilities are identified
- No major gaps or contradictions

Your job is to confirm it's ready, or identify the specific things preventing that. Nothing more.

---

## Intent Document

[PASTE INTENT.MD CONTENT HERE]

---

## Brief Document

[PASTE DISCOVER-BRIEF.MD CONTENT HERE]

---

## Design Document

[PASTE DESIGN.MD CONTENT HERE]
```

---

## Type-Specific Modules

For certain project types, append additional focus areas. Use sparingly.

### App Module

Add for App projects:

```
Additional checks for Apps:

- **Scalability Mismatch** — Is the architecture appropriately sized for the scale modifier (personal/shared/commercial)?
- **State Management** — Is it clear how state flows through the application?
- **Error Handling** — Are failure modes and error states addressed?
```

### Workflow Module

Add for Workflow projects:

```
Additional checks for Workflows:

- **Orchestration Clarity** — Is the execution flow unambiguous?
- **Failure Recovery** — Are retry strategies and failure handling defined?
- **Idempotency** — Can steps be safely re-run if interrupted?
```

### Artifact Module

Add for Artifact projects:

```
Additional checks for Artifacts:

- **Format Completeness** — Is the output format fully specified?
- **Content Dependencies** — Are all inputs and source materials identified?
- **Capability Fit** — Are the chosen tools/skills appropriate for the format?
```

---

## Capturing Feedback

After receiving external feedback:

1. **Filter aggressively** — Ignore suggestions that expand scope or over-engineer
2. Extract only issues that genuinely affect implementation soundness
3. Log in design.md's Issue Log with source attribution
4. Cross-reference multiple reviewers — if only one model flags it and it's not clearly blocking, probably not P1
5. P1 = blocks Develop or creates significant technical debt. Everything else is P2 or ignore.

---

## When to Stop Reviewing

**Cycle stop rules (same as internal review):**

- **Minimum:** 2 external review cycles
- **Stop when:** A cycle produces zero Critical and zero High severity issues
- **Hard maximum:** 10 cycles
- **Typical:** 1-2 rounds for most projects. Complex commercial projects may need 2-3.

**Per cycle, ask:** "Did this cycle surface any Critical or High issues?" If no, you're done.

**Cross-reviewer signal:** If multiple reviewers flag the same issue, it's likely Critical or High regardless of how each reviewer rated it.
