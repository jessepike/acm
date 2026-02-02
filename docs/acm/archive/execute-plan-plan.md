---
type: "implementation-plan"
artifact: "execute-plan-skill"
version: "1.1.0"
created: "2026-02-02"
updated: "2026-02-02"
stage: "develop"
phase: "planning"
status: "internal-review-complete"
---

# Execute-Plan Skill: Implementation Plan

## Overview

**What we're building:**
Autonomous development orchestration skill that executes approved `plan.md` + `tasks.md` during Develop stage Build phase. Coordinates parallel task executors, enforces TDD, integrates ralph-loop quality gates, and provides complete traceability.

**Approach:**
Incremental implementation across 7 phases, validating each phase against link-triage-pipeline before advancing. Start with sequential execution (Phase 1), layer in quality gates (Phases 2-3), optimize with parallelization (Phase 4), enforce TDD (Phase 5), add observability (Phase 6), and polish UX (Phase 7).

**Validation target:**
link-triage-pipeline Phase 1 (13 tasks) for MVP validation, full 5-phase plan (66 tasks) for complete validation.

---

## Phases

### Phase 1: Core Orchestrator (Foundation)

**Deliverables:**
- Main skill entry point: `skills/execute-plan/skill.md`
- Orchestrator agent: `skills/execute-plan/agents/orchestrator.md`
- Basic task executor agent: `skills/execute-plan/agents/task-executor.md` (no TDD yet)
- Commit message template: `skills/execute-plan/templates/commit-message.txt`
- Directory structure: `skills/execute-plan/` with subdirectories

**Approach:**
- Parse execute-plan-plan.md (or target project's plan.md) to extract phases, phase names, phase descriptions
- Parse execute-plan-tasks.md (or target project's tasks.md) to extract all tasks with dependencies, acceptance criteria
- Create TaskList with all tasks upfront (TaskCreate × N)
- Execute tasks sequentially (one at a time, no parallelization)
- Atomic commit per task using template
- Update tasks.md status after each completion
- Append session log entries to status.md

**Exit criteria:**
- Can parse plan.md and tasks.md correctly (validates with link-triage-pipeline: 5 phases, 66 tasks extracted)
- Can execute Phase 1 of link-triage-pipeline sequentially
- Produces 13 commits (one per task)
- Tasks.md updated with "done" status for all Phase 1 tasks
- Session log in status.md shows phase start/completion

---

### Phase 2: Ralph Loop Integration (Quality Gates)

**Deliverables:**
- Ralph-loop invocation logic in orchestrator
- Issue severity parser (Critical/High/Medium/Low regex extraction)
- Fix task creation workflow (auto-generate tasks for High issues)
- Ralph cycle tracking (count cycles 1, 2, 3, stop at 3 max)

**Approach:**
- At phase boundary: invoke ralph-loop via Skill tool
- Parse ralph output using regex for `[Critical]`, `[High]`, etc.
- Decision tree: Critical → stop, High → create fix tasks, Medium/Low → log warnings, Clean → proceed
- Fix task IDs use F-prefix (1.F1, 1.F2) to avoid collisions with planned tasks
- Track ralph cycle count per phase, stop at 3 cycles max
- Re-invoke ralph after fix tasks complete (cycle 2, possibly cycle 3)
- Log ralph cycle results to run log and session log

**Exit criteria:**
- Ralph-loop invoked at end of Phase 1
- If High issues found: creates fix tasks (1.F1, 1.F2, etc.)
- Re-reviews after fixes
- Only advances to Phase 2 when ralph returns clean (0 Critical, 0 High)
- Ralph cycle count tracked correctly (stops at 3 max)

---

### Phase 3: Phase Validator (Exit Criteria)

**Deliverables:**
- Phase validator agent: `skills/execute-plan/agents/phase-validator.md`
- Exit criteria parsers: test-based, execution-based, artifact-based
- Validation report generator (pass/fail with details)

**Approach:**
- Parse phase exit criteria from target project's plan.md (natural language)
- For each criterion, determine type (test/execution/artifact)
- Run appropriate validation (pytest, CLI command, file check)
- Generate structured report: ✓ PASS / ✗ FAIL with details
- If any criterion fails: stop execution, surface validator report
- If all pass: proceed to phase closeout

**Exit criteria:**
- Can parse exit criteria from plan.md for Phase 1
- Validates: `python -m link_triage --help` works, DB schema creates, config error handling
- Generates pass/fail report with specific details
- Only advances phase when all criteria pass

---

### Phase 4: Parallelization (Speed Optimization)

**Deliverables:**
- Dependency graph analyzer (DAG-based ready check)
- Task grouping logic (phase-based, handles non-sequential IDs and F-prefix)
- Parallel Task spawns (3-5 groups max)
- Progress monitoring (TaskList polling, blocker detection)
- Upfront dependency validation + runtime stuck detection

**Approach:**
- Analyze task dependencies: for each task, check which dependencies must complete first
- Group tasks by phase number, split into chunks of max 4 tasks per group
- Identify ready tasks: status=pending, all dependencies satisfied
- Spawn 3-5 task-executor agents in parallel (single message, multiple Tool calls)
- Monitor via TaskList, wait for completions
- Handle blockers from any sub-agent (report to user or invoke ralph-loop)
- Upfront validation: check for missing dependencies, circular dependencies
- Runtime stuck detection: if no progress for 10 iterations, surface error

**Exit criteria:**
- Can execute Phase 2 of link-triage-pipeline with parallel groups
- Spawns 3 groups simultaneously (Groups A, B, C)
- Group D waits for dependencies before starting
- Total execution time reduced by ~40-50% vs sequential
- Stuck detection catches dependency issues within 50 seconds

---

### Phase 5: TDD Enforcement (Quality Process)

**Deliverables:**
- Enhanced task-executor agent with TDD steps
- Test-first workflow (red → green cycle)
- Acceptance criteria validation before commit

**Approach:**
- Task executor reads task acceptance criteria
- Writes tests FIRST covering all criteria (using pytest, unittest.mock for APIs)
- Runs tests → expects failure (red phase)
- Implements minimal code to pass tests
- Runs tests → expects success (green phase)
- Validates acceptance criteria met (all checklist items satisfied)
- Commits code + tests atomically with detailed message

**Exit criteria:**
- Task executor for task 2.5 (Jina client) writes tests/test_extractor.py first
- Tests fail initially (no implementation exists)
- Implementation passes tests
- Commit includes both link_triage/extractor.py and tests/test_extractor.py
- Commit message lists acceptance criteria and test files

---

### Phase 6: Traceability & Debugging (Observability)

**Deliverables:**
- Run log format + writer: `output/runs/{date}-{uuid}.log`
- Enhanced commit messages (acceptance criteria, tests, task ID, phase)
- Session log entries (orchestrator decisions at phase boundaries)
- Log templates: run-log-entry.txt, session-log-entry.txt

**Approach:**
- Create run log file at execution start with unique run ID
- Log all orchestrator events: INIT, PHASE, SPAWN, COMPLETE, BLOCKED, RALPH, VALIDATE, FIX, ERROR
- Enhance commit template with: acceptance criteria list, task ID, phase name, test files
- Append session log to status.md with: timestamps, decisions, blockers, phase completions
- Use structured format for easy grepping and agent parsing

**Exit criteria:**
- Run log captures full execution trace (can reconstruct all decisions)
- Git log shows task-per-commit with full context
- Session log in status.md shows phase transitions and key events
- Troubleshooting agent (or human) can diagnose failures from logs alone
- Build-to-design verification complete (all major design requirements mapped to implementation)

---

### Phase 7: Polish & CLI (Production Ready)

**Deliverables:**
- CLI options in skill.md: `--start-phase N`, `--dry-run`, `--max-parallel N`
- Pause/resume capability (checkpoint state, graceful stop)
- Error handling refinement (clear messages, actionable guidance)
- Documentation: README.md with architecture, usage, troubleshooting

**Approach:**
- Parse CLI arguments in main skill prompt
- Implement `--start-phase N`: skip to phase N, load checkpoint state
- Implement `--dry-run`: simulate without commits or file writes
- Implement `--max-parallel N`: cap parallel groups (default 5)
- Add graceful pause: save checkpoint state, wait for in-progress tasks
- Add resume: read checkpoint, continue from last phase
- Refine error messages: include context, suggest fixes, surface actionable next steps
- Write README with: purpose, architecture diagram, invocation examples, troubleshooting guide

**Exit criteria:**
- `/execute-plan --start-phase 3` resumes from Phase 3
- `/execute-plan --dry-run` simulates without commits
- `/execute-plan --max-parallel 3` caps parallelization
- Can pause execution mid-phase and resume later
- README provides complete usage guide

---

## Milestones

| Milestone | Phases | Deliverable | Validation |
|-----------|--------|-------------|------------|
| **M1: Proof of Concept** | 1-2 | Sequential execution + ralph-loop | Execute Phase 1 of link-triage-pipeline, 13+ commits, ralph review |
| **M2: Quality Gates** | 3 | Exit criteria validation | Phase 1 validator checks CLI/DB/config criteria, blocks on fail |
| **M3: Speed Optimization** | 4 | Parallel execution | Phase 2 with 3 parallel groups, ~50% time reduction |
| **M4: Process Enforcement** | 5 | TDD workflow | Task 2.5 produces tests-first commit with both code + tests |
| **M5: Observability** | 6 | Full traceability | Diagnose task failure from logs alone (no live session needed) |
| **M6: Production Ready** | 7 | CLI polish + docs | All CLI options work, pause/resume functional, README complete |

---

## Testing Strategy

### Frameworks

**Manual validation** (primary approach for MVP):
- Execute skill on link-triage-pipeline (real project)
- Verify outputs: commit count, task status, log quality
- Test error paths: blockers, ralph issues, phase failures

**Tools:**
- Git log analysis: `git log --grep="task-"`, `git bisect`
- Log inspection: `cat output/runs/{uuid}.log`, `grep BLOCKED`
- TaskList monitoring: `/tasks` command in Claude Code

**Coverage target:**
- All 7 phases validated end-to-end on link-triage-pipeline
- Error paths tested manually: blocker scenarios, ralph High issues, validation failures

### What Gets Tested

| Test Type | Coverage | Method |
|-----------|----------|--------|
| **Phase execution** | All 7 phases | Execute on link-triage-pipeline, verify commits/logs |
| **Ralph integration** | Phases 2-7 | Inject code with High issues, verify fix task creation |
| **Validator** | Phases 3-7 | Manually fail exit criteria, verify blocking |
| **Parallelization** | Phases 4-7 | Verify 3-5 groups spawn simultaneously |
| **TDD workflow** | Phases 5-7 | Verify tests written before implementation |
| **Traceability** | Phases 6-7 | Diagnose staged failures from logs |
| **CLI options** | Phase 7 | Test --start-phase, --dry-run, --max-parallel |

### Browser Testing

**Not applicable.** This is a skill (orchestration logic), not a browser-based application.

### Two-Tier Testing Model

**Tier 1: Real-world validation** (manual execution on link-triage-pipeline)
- Primary validation method
- Tests actual orchestration behavior
- Validates integration with ralph-loop, ACM MCP, git

**Tier 2: Automated tests** (future enhancement, post-MVP)
- Unit tests for parsers (plan.md, tasks.md, ralph output)
- Unit tests for dependency graph logic
- Unit tests for task grouping algorithm
- Framework: pytest (if implemented)

**MVP decision:** Tier 1 only. Tier 2 can be added post-delivery if needed.

---

## Parallelization Opportunities

### Phase 1: Core Orchestrator
**Parallelization:** None (sequential execution by design)

### Phase 2-3: Ralph Loop + Validator
**Parallelization:** Sequential (validator runs after ralph)

### Phase 4: Parallelization Implementation
**Parallelization:** This phase ADDS parallelization capability
- Can execute 3-5 task groups concurrently
- Independent tasks within a phase run in parallel
- Dependent tasks run sequentially

### Phase 5-7: TDD, Traceability, Polish
**Parallelization:** Inherits Phase 4 capability
- All testing phases use parallel execution
- 40-50% time reduction expected

---

## Risk Areas

### Risk 1: Ralph-Loop Output Parsing
**Challenge:** Ralph output format might vary, causing parse failures

**Mitigation:**
- Design includes robust parser with error detection (Phase 2)
- Parser checks for: empty output, error patterns, missing severity tags
- Fallback: surface unparsed output to user for manual review
- Never skip quality gates silently

### Risk 2: Task Grouping with Complex Dependencies
**Challenge:** Non-sequential IDs, F-prefix fix tasks, circular dependencies

**Mitigation:**
- Phase-based grouping handles non-sequential IDs (design decision D3)
- Upfront validation detects circular dependencies before execution
- Stuck detection (10 iterations without progress) prevents infinite loops
- Clear error messages with dependency graph context

### Risk 3: Context Overflow with 5 Parallel Agents
**Challenge:** 5 concurrent task executors might exceed token limits

**Mitigation:**
- Use Sonnet (cheaper) for task executors, not Opus
- Monitor token usage during Phase 4 testing
- Can reduce max-parallel to 3 if needed (--max-parallel flag in Phase 7)
- Each executor works on 1-4 tasks (limited scope)

### Risk 4: Phase Validator False Positives/Negatives
**Challenge:** Exit criteria might be ambiguous or incorrectly validated

**Mitigation:**
- Natural language parsing with heuristics (simpler than YAML, user-friendly)
- Validator logs exact commands run and outputs
- If validation fails, surface full report to user for review
- User can override with manual approval if false positive

### Risk 5: Git Commit Failures
**Challenge:** Merge conflicts, permissions issues, disk full

**Mitigation:**
- Auto-retry once (transient failures)
- If still failing: surface to user with full error context
- Recommend fix, pause execution
- User can resume after resolving git issue

### Risk 6: Infinite Ralph Cycles
**Challenge:** Ralph might keep finding High issues, creating infinite fix loop

**Mitigation:**
- Max 3 ralph cycles per phase (hard limit)
- After 3 cycles: surface to user even if High issues remain
- User decides: accept issues and proceed, fix manually, or abort
- Prevents runaway execution

---

## Decision Log

### D1: Storage Location
**Decision:** ACM repo skill (`acm/skills/execute-plan/`), not a plugin

**Rationale:** Faster iteration during development, can migrate to plugin later if broadly useful

### D2: Ralph Invocation
**Decision:** Use existing ralph-loop plugin via Skill tool

**Rationale:** Reuses battle-tested review mechanism, clean separation of concerns

### D3: Commit Ownership
**Decision:** Task executor commits directly (not orchestrator)

**Rationale:** More autonomous, faster feedback, template passed in executor context

### D4: Run Log Format
**Decision:** Plain text log file at `output/runs/{date}-{uuid}.log`

**Rationale:** Easy to tail/grep/parse, lightweight, agent-readable

### D5: TaskList Management
**Decision:** Create all 66 tasks upfront (TaskCreate × 66)

**Rationale:** Full visibility from start, user can see total scope, easy progress tracking

### D6: Testing Approach
**Decision:** Manual validation on link-triage-pipeline (no automated tests initially)

**Rationale:** Matches ACM MVP pattern, faster to implement, can add tests later if needed

### D7: Exit Criteria Format
**Decision:** Natural language in plan.md (user-confirmed)

**Rationale:** Simpler for users to write, heuristic parser sufficient for MVP

### D8: Max Parallel
**Decision:** 5 groups max (user-confirmed)

**Rationale:** Design default, faster execution, can reduce to 3 if context issues

### D9: Ralph Cycle Limit
**Decision:** 3 cycles max (user-confirmed)

**Rationale:** Prevents infinite loops, matches ACM-REVIEW-SPEC.md (2-10 cycles)

### D10: Fix Task Numbering
**Decision:** F-prefix (1.F1, 1.F2) for fix tasks (user-confirmed)

**Rationale:** Avoids ID collisions with planned tasks, clear distinction

---

## Phase Dependencies

```
Phase 1 (Core Orchestrator)
    ↓ (sequential execution works)
Phase 2 (Ralph Loop Integration)
    ↓ (quality gates in place)
Phase 3 (Phase Validator)
    ↓ (exit criteria enforced)
Phase 4 (Parallelization)
    ↓ (speed optimized)
Phase 5 (TDD Enforcement)
    ↓ (quality process enforced)
Phase 6 (Traceability)
    ↓ (observability complete)
Phase 7 (Polish & CLI)
    ↓
Production Ready
```

**Critical path:** All phases sequential (each builds on previous)

**No parallel work:** Each phase must complete before next starts

---

## Success Criteria (Overall)

**Must have (all 7 phases):**
- ✅ Execute all 5 phases of link-triage-pipeline (66 tasks)
- ✅ Atomic commit per task (~66+ commits with fix tasks)
- ✅ Ralph-loop at each phase boundary (5 invocations)
- ✅ Phase validator checks exit criteria (5 validations)
- ✅ Parallel execution (3-5 groups for independent tasks)
- ✅ TDD enforced (tests before implementation)
- ✅ Full traceability (git log + run log + session log)
- ✅ CLI options (start-phase, dry-run, max-parallel)
- ✅ Pause/resume capability

**Performance target:**
- Complete 66-task plan in ~8 hours (vs ~16 hours sequential)
- ~50% time reduction for phases with parallelizable tasks

**Quality target:**
- 0 Critical issues, <2 High issues per phase (after ralph cycles)
- All phase exit criteria pass
- All commits include tests (TDD enforcement)

---

## Issue Log

| # | Issue | Source | Severity | Status | Resolution |
|---|-------|--------|----------|--------|------------|
| 1 | Build-to-design verification not explicitly included in phase deliverables/exit criteria | Ralph-Develop | High | Resolved | Added verification step to Phase 6 exit criteria and Phase 7 task 7.0 |
| 2 | Artifact paths use generic names (plan.md) instead of actual names (execute-plan-plan.md) | Ralph-Develop | High | Resolved | Updated all references: plan.md → execute-plan-plan.md, tasks.md → execute-plan-tasks.md, manifest.md → execute-plan-manifest.md, capabilities.md → execute-plan-capabilities.md |
| — | **Cycle 2 complete** | Ralph-Develop | — | Complete | 0 Critical, 0 High issues. All review dimensions pass. Plan ready for Build. |

---

## Next Steps

After plan approval:
1. Tasks.md created with 48 tasks (7 phases × ~6-7 tasks each, plus build-to-design verification)
2. Present for HARD GATE approval (Phase 4: Review Loop)
3. Upon approval: proceed to Phase 5 (Environment Setup) → Phase 6 (Build)

**Exit signal for Phase 3:** Plan drafted. Ready for review.
