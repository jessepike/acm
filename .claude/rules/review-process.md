# Review Process Rules

These are non-negotiable rules for conducting reviews in ADF projects.

## Mandatory Process

- All stage reviews MUST use the `adf-review` skill (triggers: "run review", "review this", "run ADF review")
- Do NOT substitute ad-hoc agents, manual review loops, or custom prompts for the review mechanism
- Do NOT skip reviews or claim they're unnecessary
- Do NOT expand scope during reviews — find problems, not opportunities

## Default Review Type

**The default is FULL REVIEW (internal + external) unless explicitly specified otherwise.**

When the user requests a review (e.g., "run it through ADF review", "review this design"), the agent MUST:

1. **Ask the user to confirm review type** using AskUserQuestion with these options:
   - **Full review (internal + external)** — Recommended (default)
   - Internal review only
   - External review only

2. **Trigger the adf-review skill** which will orchestrate the selected review type
   - The skill handles execution of both internal (Ralph Loop) and external (multi-model) phases
   - No need to invoke Ralph Loop or external-review MCP directly

## Review Phases

**Full Review Process:**
1. **Phase 1 (Internal):** Ralph Loop self-review - identifies structural issues, missing artifacts, inconsistencies
2. **Phase 2 (External):** Multi-model review - independent perspectives from external models on design quality, approach, risks

Both phases run automatically when full review is selected (default).

## When to Use Each Type

**Full Review (default):**
- Design artifacts before implementation
- Major architectural changes
- Stage transition readiness
- When you want comprehensive validation

**Internal Review Only:**
- Quick structural checks
- Early draft validation
- When external API costs are a concern
- Iterative refinement cycles

**External Review Only:**
- When internal review already passed
- Getting fresh perspectives on mature designs
- Validating implementation approaches

## What Agents Must NOT Do

- Do NOT manually invoke `/ralph-loop:ralph-loop` directly — use the adf-review skill orchestrator
- Do NOT assume user wants internal-only review by default
- Do NOT skip asking the user for review type preference
- Do NOT improvise review mechanisms that bypass the adf-review skill
- Do NOT call ADF MCP tools directly for reviews — let adf-review skill handle orchestration
