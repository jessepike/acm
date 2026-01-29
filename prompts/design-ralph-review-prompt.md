---
type: "prompt"
description: "Ralph Loop prompt for Phase 1 internal review in Design stage"
version: "2.0.0"
updated: "2026-01-29"
scope: "design"
usage: "Use with Ralph Loop plugin via scripts/run-design-review.sh"
---

# Design Internal Review (Phase 1: Ralph Loop)

## Usage

```bash
/ralph-loop:ralph-loop "$(cat ~/code/_shared/acm/prompts/design-ralph-review-prompt.md)" --max-iterations 10 --completion-promise "DESIGN_INTERNAL_REVIEW_COMPLETE"
```

Run from the project root directory. The agent reads project files (design.md, discover-brief.md, intent.md) relative to `$PWD`.

## Purpose

Thorough self-review of design.md. Iterate until no P1 issues remain.

## Context

This is Phase 1 of two review phases:
- Phase 1 (you): Thorough internal review — get design.md as strong as possible
- Phase 2 (external models): Diverse perspectives — catch what you missed

## Your Task

1. Read design.md, discover-brief.md, and intent.md
2. Review critically — validate decisions, challenge gaps
3. Log issues in design.md Issue Log section
4. Address all P1 issues by updating design.md
5. Re-review after changes
6. Repeat until no P1 issues remain

## Review Dimensions

Brief Alignment
- Does design deliver everything Brief specifies?
- All success criteria addressable?
- Anything contradict the Brief?
- Scope boundaries respected?

Completeness
- All required sections for project type present?
- Gaps a developer would stumble on?
- Capabilities inventory sufficient?

Feasibility
- Can this be built with stated constraints?
- Technology choices realistic?
- Hidden complexity not accounted for?

Consistency
- All sections align with each other?
- Internal contradictions?
- Data model support interface design?

Interface Clarity
- Would a developer know what to build?
- Interactions specified, not just screens?
- Edge cases addressed?

Architecture Soundness (Apps/Workflows)
- Component breakdown logical?
- Boundaries clear?
- Tech stack appropriate?

Capability Coverage
- All needed tools/skills/agents identified?
- Gaps in inventory?

Decision Quality
- Key decisions documented with rationale?
- Alternatives considered?

Downstream Usability
- Could Develop start from this?
- What questions would an implementer have?

## Issue Logging Format

Add issues to design.md Issue Log:

Number | Issue | Source | Severity | Status | Resolution
-------|-------|--------|----------|--------|------------
N | description | Ralph-Design | Critical/High/Low | Open | -

## Severity Definitions

Critical: Must resolve. Blocks Develop or fundamentally flawed.
High: Should resolve. Significant gap or weakness.
Low: Minor improvement, polish, or implementation detail.

## YAGNI Principle

- Only flag issues that block Develop or make design unsound
- Do NOT suggest features or additions beyond Brief
- Do NOT expand architecture beyond requirements
- Do NOT add capabilities just in case
- Low-impact issues are P3 at most

The test: If this issue is not fixed, will Develop fail or produce something significantly wrong? If no, it is not P1.

## Cycle Stop Rules

After each review cycle, assess the issues found:

- **Minimum:** Always complete at least 2 review cycles
- **Stop when:** A cycle produces zero Critical and zero High severity issues
- **Hard maximum:** 10 cycles (if reached, flag for human input)
- **Structural problem signal:** If past 4 cycles and still finding Critical issues, stop and flag for human input

Per cycle, ask: "Did this cycle surface any Critical or High issues?" If no, you're done.

## Exit Criteria

- Minimum 2 review cycles completed
- Last cycle produced zero Critical and zero High issues
- Design delivers what Brief requires
- No obvious gaps for implementers

## Completion

When stop rules are met:
1. Update design.md status to internal-review-complete
2. Note cycle count in Issue Log
3. Output: DESIGN_INTERNAL_REVIEW_COMPLETE
