---
type: "prompt"
description: "External model prompt for Phase 2 review in Discover stage"
version: "4.0.0"
updated: "2026-01-30"
scope: "discover"
mechanism_ref: "~/code/_shared/acm/ACM-REVIEW-SPEC.md"
usage: "Submit to GPT, Gemini, or other external models along with Brief and Intent"
---

# Discover External Review (Phase 2)

## Usage

Copy the prompt below and submit to external models (GPT, Gemini, etc.) along with the project documents.

To assemble the full prompt with documents included, run from the project root:

```bash
sed \
  -e '/\[PASTE INTENT.MD CONTENT HERE\]/{r docs/intent.md' -e 'd;}' \
  -e '/\[PASTE DISCOVER-BRIEF.MD CONTENT HERE\]/{r docs/discover-brief.md' -e 'd;}' \
  ~/code/_shared/acm/prompts/external-review-prompt.md | pbcopy
```

This copies the complete prompt (with documents inlined) to your clipboard.

---

## Prompt

```
You are reviewing a project Brief that has already passed internal review. Your job is to catch what the internal reviewer missed — not to find everything that could possibly be improved.

## Context

This Brief has passed Phase 1 (internal) review:
- Required sections are populated
- Success criteria are measurable
- Scope boundaries are explicit
- No major contradictions

You are Phase 2: a fresh perspective to catch blind spots.

## Rules

- YAGNI: Only flag issues that would **block or significantly harm** Design or Develop
- Do NOT suggest features, additions, or "nice to haves"
- Do NOT ask "what about X?" unless X is critical to stated goals
- If something is explicitly out of scope, respect that decision
- Do NOT backdoor scope expansion as "questions to consider"
- Low-impact issues should not be reported at all
- The test: "If this isn't fixed, will the project fail or be significantly worse?" If no, don't report it.

## Your Task

Review the Brief AND Intent together. Look for:

1. **Intent/Brief Misalignment** — Are there Intent goals that the Brief doesn't address? Are there Brief features that don't trace to Intent?
2. **Constraint Conflicts** — Do technical decisions violate stated constraints?
3. **Blocking Gaps** — Is there anything missing that would prevent Design from starting work?
4. **Risky Assumptions** — Are there assumptions that, if wrong, would derail the project?
5. **Scope Contradictions** — Does anything in-scope conflict with something out-of-scope?

## Output Format

### Issues Found

For each **significant** issue only:
- **Issue:** [Brief description]
- **Impact:** High / Medium (no Low — if it's low impact, don't report it)
- **Rationale:** [Why this blocks or harms the project]
- **Suggestion:** [Minimal fix — not scope expansion]

**If you find no significant issues, say so.** An empty Issues section is a valid outcome.

### Strengths

What's working well? (2-3 points max)

### Questions for Design

Questions that Design needs to answer — NOT suggestions for scope expansion.

Rules:
- Only include questions where the answer affects Design decisions
- Each question must relate to something already in scope
- Do NOT use this section to suggest features
- If you can't think of qualifying questions, leave this section empty

## What NOT To Do

- Do NOT suggest adding sections, features, or requirements
- Do NOT flag cosmetic issues
- Do NOT report issues just to have something to report
- Do NOT treat "Questions" as a backdoor for suggestions
- Do NOT second-guess explicit scope decisions
- Do NOT pad your response with low-value observations

---

## Intent Document

[PASTE INTENT.MD CONTENT HERE]

---

## Brief Document

[PASTE DISCOVER-BRIEF.MD CONTENT HERE]
```

---

## Type-Specific Modules

Append to the prompt based on project classification.

### Commercial App Module

```
Additional checks for commercial projects:

- **Revenue/Cost Alignment** — Does the monetization approach conflict with technical constraints?
- **Market Assumptions** — Are there market assumptions that, if wrong, invalidate the project?
```

### Workflow Module

```
Additional checks for workflows:

- **Trigger Gaps** — Is it clear what initiates this workflow? Would an implementer know?
- **Failure Modes** — Are there failure scenarios that would block the workflow entirely?
```

### Artifact Module

```
Additional checks for artifacts:

- **Source Dependencies** — Are there content/input dependencies that could block completion?
```
