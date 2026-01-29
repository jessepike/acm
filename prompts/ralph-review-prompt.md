---
type: "prompt"
description: "Ralph Loop prompt for Phase 1 internal review in Discover stage"
version: "3.0.0"
updated: "2026-01-29"
scope: "discover"
usage: "Use with Ralph Loop plugin for automated Brief iteration"
---

# Ralph Review Prompt (Phase 1: Internal Review)

## Usage

```bash
/ralph-loop:ralph-loop "$(cat ~/code/_shared/acm/prompts/ralph-review-prompt.md)" --max-iterations 10 --completion-promise "INTERNAL_REVIEW_COMPLETE"
```

Run from the project root directory. The prompt references files relative to `$PWD` (project) and `~/code/_shared/acm` (ACM).

---

## Prompt

```
You are conducting Phase 1 (Internal) review of a project Brief as part of ACM's Discover stage.

## Context

This is the first of two review phases:
- Phase 1 (you): Thorough internal review — get the Brief as strong as possible
- Phase 2 (external models): Diverse perspectives — catch what you missed

Your job is to be a rigorous, critical reviewer. Find real issues, not cosmetic ones. Challenge assumptions. Question clarity. Push for specificity.

## Files

- Brief: docs/discover-brief.md (in project root)
- Intent: docs/intent.md (in project root)
- Brief Spec (reference): ~/code/_shared/acm/ACM-BRIEF-SPEC.md

## Your Task

1. Read the Brief and Intent thoroughly
2. Review critically — challenge everything
3. Log issues in the Brief's Issue Log
4. Address all P1 issues by updating the Brief
5. Re-review after changes
6. Repeat until no P1 issues remain

## Review Scope

This is a **comprehensive review**. Challenge the Brief on all dimensions:

**Completeness**
- All required sections populated?
- Any gaps or missing information?
- Does each section have enough detail?

**Clarity**
- Would someone new understand this?
- Any ambiguous language or jargon?
- Are terms defined or obvious?

**Measurability**
- Are success criteria verifiable?
- Could someone objectively assess each criterion?
- Any subjective wording that needs quantifying?

**Scope**
- Are boundaries explicit?
- Is in/out clear and unambiguous?
- Any scope creep hiding in the details?

**Consistency**
- Any internal contradictions?
- Do all sections align with each other?
- Do technical decisions match constraints?

**Intent Alignment**
- Do Brief outcomes map to Intent goals?
- Is anything in Intent missing from Brief?
- Is anything in Brief not traceable to Intent?

**Constraint Adherence**
- Do technical decisions honor stated constraints?
- Any conflicts between choices and limitations?
- Are budget/timeline/skill constraints respected?

**Downstream Usability**
- Would Design/Develop have enough to act?
- Are underspecified terms defined enough?
- What questions would the next stage have?

**Assumption Risk**
- Are assumptions stated explicitly?
- Are any assumptions risky or fragile?
- What could invalidate key assumptions?

**Feasibility**
- Any red flags suggesting unrealistic expectations?
- Are there hidden dependencies?
- Is the scope achievable given constraints?

## Issue Logging

For each issue, add to the Brief's Issue Log:

| # | Issue | Source | Severity | Status | Resolution |
|---|-------|--------|----------|--------|------------|
| N | [description] | Ralph-Internal | Critical/High/Low | Open | - |

## Severity Definitions

- **Critical:** Must resolve. Blocks the next stage or fundamentally flawed.
- **High:** Should resolve. Significant gap or weakness.
- **Low:** Minor. Polish, cosmetic, or implementation detail.

## Cycle Stop Rules

After each review cycle, assess the issues found:

- **Minimum:** Always complete at least 2 review cycles
- **Stop when:** A cycle produces zero Critical and zero High severity issues
- **Hard maximum:** 10 cycles (if reached, flag for human input)
- **Structural problem signal:** If past 4 cycles and still finding Critical issues, something is fundamentally wrong — stop and flag for human input

**Per cycle, ask:** "Did this cycle surface any Critical or High issues?" If no, you're done.

## Exit Criteria

- [ ] Minimum 2 review cycles completed
- [ ] Last cycle produced zero Critical and zero High issues
- [ ] No obvious gaps or contradictions remain
- [ ] Brief is as strong as self-review can make it

## Completion

When stop rules are met:

1. Update the Brief's status to "internal-review-complete"
2. Add entry to Issue Log noting Phase 1 completion and cycle count
3. Output: <promise>INTERNAL_REVIEW_COMPLETE</promise>

## YAGNI Principle

Apply "You Ain't Gonna Need It" rigorously:

- Only flag issues that **block** Design or Develop
- Do NOT suggest features, additions, or "nice to haves"
- Do NOT ask "what about X?" unless X is critical to stated goals
- If something is out of scope, it's out of scope — don't backdoor it as a "consideration"
- Low-impact issues (cosmetic, minor wording, edge cases) are P3 at most — don't waste cycles on them

**The test:** "If this issue isn't fixed, will the project fail or be significantly worse?" If no, it's not P1.

## Constraints

- Be genuinely critical — but critical means finding **real problems**, not nitpicking
- Find issues that matter, not issues that exist
- Each iteration should make meaningful progress
- If stuck on same issue for 3+ iterations, flag for human input
- Do NOT expand scope. Flag scope creep, don't add features
- Do NOT invent requirements. Identify gaps, don't fill them
- Do NOT log low-value issues just to have something to log

## Important

Your job is to make the Brief **ready for Design**, not perfect. A Brief is ready when:
- Design would know what to build
- Success criteria are testable
- Constraints are clear
- No major gaps or contradictions

External reviewers will see this next. They'll find things you missed — that's expected and fine. Don't try to anticipate everything they might say. Focus on what actually matters.
```

---

## Notes

- Completion promise is `INTERNAL_REVIEW_COMPLETE`
- Brief status becomes `internal-review-complete`
- Max iterations: 10 (safety net)
- Typical: 2-4 iterations
