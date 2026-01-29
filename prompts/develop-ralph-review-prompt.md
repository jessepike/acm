---
type: "prompt"
description: "Ralph Loop prompt for Phase 1 internal review in Develop stage"
version: "2.0.0"
updated: "2026-01-29"
scope: "develop"
usage: "Use with Ralph Loop plugin for automated plan review"
---

# Develop Internal Review (Phase 1: Ralph Loop)

## Usage

```bash
/ralph-loop:ralph-loop "$(cat ~/code/_shared/acm/prompts/develop-ralph-review-prompt.md)" --max-iterations 10 --completion-promise "DEVELOP_INTERNAL_REVIEW_COMPLETE"
```

Run from the project root directory. The agent reads project files (manifest.md, capabilities.md, plan.md, tasks.md, design.md) relative to `$PWD`.

## Purpose

Thorough review of the implementation plan before environment setup. Validate that the plan is complete, feasible, and executable.

## Context

This is Phase 1 of two review phases:
- Phase 1 (you): Thorough internal review of plan and capabilities
- Phase 2 (external models): Diverse perspectives, catch blind spots

## Your Task

1. Read all Develop artifacts: manifest.md, capabilities.md, plan.md, tasks.md
2. Review against the design.md requirements
3. Log issues in plan.md Issue Log section
4. Address all P1 issues
5. Re-review after changes
6. Repeat until no P1 issues remain

## Review Dimensions

Design Alignment
- Does the plan cover all design requirements?
- Are all design components addressed in tasks?
- Do capabilities match what the design needs?

Manifest Completeness
- Are all software dependencies identified?
- Versions specified where critical?
- Any missing dependencies for the tech stack?

Capabilities Coverage
- Are all needed skills identified?
- Are required tools and MCP servers listed?
- Are sub-agent roles defined where needed?
- Testing capabilities sufficient?

Plan Quality
- Are phases logical and well-sequenced?
- Are milestones meaningful checkpoints?
- Is the testing strategy adequate?
- Are parallelization opportunities captured?

Task Atomicity
- Is each task small enough for single-agent execution?
- Are acceptance criteria clear and testable?
- Are dependencies between tasks noted?
- Can an agent read-complete-verify each task?

Feasibility
- Can this plan actually be executed?
- Are there hidden complexities not addressed?
- Are risk areas identified with mitigation?

Testing Strategy
- Is TDD approach clear?
- Are critical paths covered by tests?
- Will 95%+ pass rate be achievable?
- Are E2E tests planned for key flows?

## Issue Logging Format

Add issues to plan.md Issue Log:

Number | Issue | Source | Severity | Status | Resolution
-------|-------|--------|----------|--------|------------
N | description | Ralph-Develop | Critical/High/Low | Open | -

## Severity Definitions

Critical: Must resolve. Blocks implementation or fundamentally flawed.
High: Should resolve. Significant gap or weakness.
Low: Minor refinement. Can address during Build.

## YAGNI Principle

- Only flag issues that block implementation
- Do NOT suggest features beyond the design
- Do NOT over-engineer the plan
- Do NOT add unnecessary capabilities
- Focus on what is needed to execute the design

The test: If this issue is not fixed, will Build fail or produce something significantly wrong? If no, it is not P1.

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
- Plan covers all design requirements
- Tasks are atomic and executable
- Capabilities are sufficient
- Testing strategy is adequate

## Completion

When stop rules are met:
1. Update plan.md status to internal-review-complete
2. Note cycle count in Issue Log
3. Output: DEVELOP_INTERNAL_REVIEW_COMPLETE
