---
type: "prompt"
description: "External model prompt for Phase 2 review in Design stage"
version: "3.0.0"
updated: "2026-01-30"
scope: "design"
mechanism_ref: "~/code/_shared/acm/ACM-REVIEW-SPEC.md"
usage: "Submit to GPT, Gemini, or other external models along with design.md, Brief, and Intent"
---

# Design External Review (Phase 2)

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

## Rules

- YAGNI: Only flag issues that would **block or significantly harm** implementation
- Do NOT suggest features, components, or additions
- Do NOT ask "what about X?" unless X is critical to Brief requirements
- If something is explicitly out of scope, respect that decision
- Do NOT backdoor scope expansion as "architectural considerations"
- Low-impact issues should not be reported at all
- The test: "If this isn't fixed, will the implementation fail or be significantly flawed?" If no, don't report it.

## Your Task

Review the Design against the Brief and Intent. Look for:

1. **Brief/Design Misalignment** — Does the design actually deliver what the Brief requires?
2. **Architectural Weaknesses** — Technical decisions that seem unsound or risky?
3. **Tech Stack Fit** — Technologies appropriate for constraints and requirements?
4. **Interface Gaps** — Would a developer know what to build?
5. **Data Model Issues** — Data structures support the requirements?
6. **Capability Gaps** — Tools/skills/agents sufficient?
7. **Integration Risks** — Integration points fragile or underspecified?
8. **Security Concerns** — Obvious security issues? (Don't audit exhaustively)

## Output Format

### Issues Found

For each **significant** issue only:
- **Issue:** [Brief description]
- **Impact:** High / Medium (no Low)
- **Rationale:** [Why this blocks or harms implementation]
- **Suggestion:** [Minimal fix — not scope expansion]

**If you find no significant issues, say so.**

### Strengths

What's working well technically? (2-3 points max)

### Questions for Develop

Questions that Develop needs to answer — NOT suggestions for scope expansion.

Rules:
- Only include questions where the answer affects implementation decisions
- Each question must relate to something already in the design
- If you can't think of qualifying questions, leave this section empty

## What NOT To Do

- Do NOT suggest adding features, components, or capabilities beyond Brief scope
- Do NOT flag cosmetic issues
- Do NOT report issues just to have something to report
- Do NOT recommend "enterprise" patterns for personal/MVP projects
- Do NOT suggest over-engineering

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

### App Module

```
Additional checks for Apps:

- **Scalability Mismatch** — Is the architecture appropriately sized for the scale modifier?
- **State Management** — Is it clear how state flows through the application?
- **Error Handling** — Are failure modes and error states addressed?
```

### Workflow Module

```
Additional checks for Workflows:

- **Orchestration Clarity** — Is the execution flow unambiguous?
- **Failure Recovery** — Are retry strategies and failure handling defined?
- **Idempotency** — Can steps be safely re-run if interrupted?
```

### Artifact Module

```
Additional checks for Artifacts:

- **Format Completeness** — Is the output format fully specified?
- **Content Dependencies** — Are all inputs and source materials identified?
- **Capability Fit** — Are the chosen tools/skills appropriate for the format?
```
