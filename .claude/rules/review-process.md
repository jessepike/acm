# Review Process Rules

These are non-negotiable rules for conducting reviews in ACM projects.

## Mandatory Process

- All stage reviews MUST use the Ralph Loop plugin (`/ralph-loop:ralph-loop`) for Phase 1 (internal review)
- Do NOT substitute ad-hoc agents, manual review loops, or custom prompts for the Ralph Loop mechanism
- Internal review (Phase 1) is MANDATORY for every reviewable artifact at every stage
- External review (Phase 2) is USER-DRIVEN — only conduct when the user requests it

## Preferred Invocation

Use the `acm-review` plugin commands for all reviews:

| Command | What It Does |
|---------|-------------|
| `/acm-review:artifact` | Full review: Phase 1 internal → Phase 2 external |
| `/acm-review:artifact-internal` | Phase 1 internal only |
| `/acm-review:artifact-external` | Phase 2 external only |

These commands handle stage detection, prompt resolution, and Ralph Loop invocation automatically.

## Prompt Usage

- Use the stage-specific review prompt from `~/code/_shared/acm/prompts/` — do not write custom review prompts
- Internal review: `/ralph-loop:ralph-loop "$(cat ~/code/_shared/acm/prompts/{prompt}.md)" --max-iterations 10 --completion-promise "{PROMISE}"`
- External review: `/ralph-loop:ralph-loop "$(cat ~/code/_shared/acm/prompts/{external-ralph-prompt}.md)" --max-iterations 10 --completion-promise "EXTERNAL_REVIEW_COMPLETE"`

### Prompt Map

| Stage | Internal Prompt | External Ralph Prompt | External Model Prompt | Internal Promise | External Promise |
|-------|-----------------|----------------------|----------------------|------------------|------------------|
| Discover | `ralph-review-prompt.md` | `external-ralph-prompt.md` | `external-review-prompt.md` | `INTERNAL_REVIEW_COMPLETE` | `EXTERNAL_REVIEW_COMPLETE` |
| Design | `design-ralph-review-prompt.md` | `design-external-ralph-prompt.md` | `design-external-review-prompt.md` | `DESIGN_INTERNAL_REVIEW_COMPLETE` | `EXTERNAL_REVIEW_COMPLETE` |
| Develop | `develop-ralph-review-prompt.md` | `develop-external-ralph-prompt.md` | `develop-external-review-prompt.md` | `DEVELOP_INTERNAL_REVIEW_COMPLETE` | `EXTERNAL_REVIEW_COMPLETE` |

**Note:** External Ralph Prompts instruct Claude (inside Ralph Loop) to call the MCP `review()` tool each cycle. External Model Prompts are sent to the external models via the MCP server.

## Review Mechanism

- See `ACM-REVIEW-SPEC.md` for full mechanism: cycle rules, severity definitions, stop conditions, issue logging format
- Minimum 2 internal review cycles, maximum 10
- Stop when a cycle produces zero Critical and zero High issues
- All issues logged in the artifact's Issue Log with source attribution

## What Agents Must NOT Do

- Do NOT skip internal review or claim it's unnecessary
- Do NOT improvise review mechanisms that approximate the Ralph Loop
- Do NOT decide whether external review is needed — that is the user's decision
- Do NOT expand scope during reviews — find problems, not opportunities
