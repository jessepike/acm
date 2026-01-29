---
type: "prompt"
description: "External model prompt for Phase 2 review in Discover stage"
version: "3.0.0"
updated: "2026-01-29"
scope: "discover"
usage: "Submit to GPT, Gemini, or other external models along with Brief and Intent"
---

# External Review Prompt (Phase 2: External Review)

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

## YAGNI Principle — CRITICAL

Apply "You Ain't Gonna Need It" rigorously. This is the most important instruction:

- Only flag issues that would **block or significantly harm** Design or Develop
- Do NOT suggest features, additions, or "nice to haves"
- Do NOT ask "what about X?" unless X is critical to stated goals
- If something is explicitly out of scope, respect that decision
- Do NOT backdoor scope expansion as "questions to consider"
- Low-impact issues should not be reported at all

**The test for every issue:** "If this isn't fixed, will the project fail or be significantly worse?" If no, don't report it.

## Your Task

Review the Brief AND Intent together. Look for:

1. **Intent/Brief Misalignment** — Are there Intent goals that the Brief doesn't address? Are there Brief features that don't trace to Intent?

2. **Constraint Conflicts** — Do technical decisions violate stated constraints? (e.g., choosing paid tools when constraint says free-tier only)

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

Rules for this section:
- Only include questions where the answer affects Design decisions
- Each question must relate to something already in scope
- Do NOT use this section to suggest features
- Do NOT ask "have you considered adding X?"
- If you can't think of questions that meet these criteria, leave this section empty

## What NOT To Do

- Do NOT suggest adding sections, features, or requirements
- Do NOT flag cosmetic issues (wording, formatting, minor clarity)
- Do NOT report issues just to have something to report
- Do NOT treat "Questions" as a backdoor for suggestions
- Do NOT second-guess explicit scope decisions
- Do NOT pad your response with low-value observations

## What You're Solving For

The Brief is ready for Design when:
- Design would know what to build
- Success criteria are testable
- Constraints are clear
- No major gaps or contradictions

Your job is to confirm it's ready, or identify the specific things preventing that. Nothing more.

---

## Intent Document

[PASTE INTENT.MD CONTENT HERE]

---

## Brief Document

[PASTE DISCOVER-BRIEF.MD CONTENT HERE]
```

---

## Type-Specific Modules

For certain project types, append additional focus areas. Use sparingly — only if the project type genuinely requires additional scrutiny.

### Commercial App Module

Add only for commercial-scale projects:

```
Additional checks for commercial projects:

- **Revenue/Cost Alignment** — Does the monetization approach conflict with technical constraints?
- **Market Assumptions** — Are there market assumptions that, if wrong, invalidate the project?
```

### Workflow Module

Add only for workflow projects:

```
Additional checks for workflows:

- **Trigger Gaps** — Is it clear what initiates this workflow? Would an implementer know?
- **Failure Modes** — Are there failure scenarios that would block the workflow entirely?
```

### Artifact Module

Add only for artifact projects:

```
Additional checks for artifacts:

- **Source Dependencies** — Are there content/input dependencies that could block completion?
```

---

## Capturing Feedback

After receiving external feedback:

1. **Filter aggressively** — Ignore suggestions that expand scope
2. Extract only issues that genuinely block Design
3. Log in Brief's Issue Log with source attribution
4. Cross-reference multiple reviewers — if only one model flags it and it's not clearly blocking, it's probably not P1
5. P1 = blocks Design. Everything else is P2 or ignore.

---

## When to Stop Reviewing

**Cycle stop rules (same as internal review):**

- **Minimum:** 2 external review cycles
- **Stop when:** A cycle produces zero Critical and zero High severity issues
- **Hard maximum:** 10 cycles
- **Typical:** 1-2 rounds for most projects. Complex commercial projects may need 2-3.

**Per cycle, ask:** "Did this cycle surface any Critical or High issues?" If no, you're done.

**Cross-reviewer signal:** If multiple reviewers flag the same issue, it's likely Critical or High regardless of how each reviewer rated it.
