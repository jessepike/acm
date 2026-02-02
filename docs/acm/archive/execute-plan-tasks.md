---
type: "task-list"
artifact: "execute-plan-skill"
version: "1.0.0"
created: "2026-02-02"
stage: "develop"
phase: "planning"
current_phase: "Phase 1: Core Orchestrator"
---

# Execute-Plan Skill: Task List

## Handoff

*No handoff yet — planning phase*

**Next phase requires:**
- Plan.md and tasks.md approved via HARD GATE
- Proceed to Phase 5 (Environment Setup) after approval
- No software installation needed (pure markdown skill)

---

## Active Tasks

### Phase 1: Core Orchestrator (Foundation)

| ID | Task | Status | Acceptance Criteria | Testing | Depends | Capability |
|----|------|--------|---------------------|---------|---------|------------|
| 1.1 | Create directory structure | pending | Directories exist: `skills/execute-plan/`, `agents/`, `templates/` | Manual: verify dirs | — | Bash |
| 1.2 | Create skill.md main entry | pending | File exists with frontmatter, user_invocable: true, usage instructions | Manual: verify content | 1.1 | Write |
| 1.3 | Create commit-message.txt template | pending | Template with placeholders: TASK_ID, DESCRIPTION, ACCEPTANCE_CRITERIA, TESTS | Manual: verify format | 1.1 | Write |
| 1.4 | Create session-log-entry.txt template | pending | Template with TIMESTAMP, EVENT_TYPE, EVENT_DESCRIPTION | Manual: verify format | 1.1 | Write |
| 1.5 | Create run-log-entry.txt template | pending | Template with TIMESTAMP, LOG_LEVEL, MESSAGE | Manual: verify format | 1.1 | Write |
| 1.6 | Create orchestrator.md agent (shell) | pending | Agent file with frontmatter (name, type: agent, color: blue), basic structure | Manual: verify structure | 1.1 | Write |
| 1.7 | Implement plan.md parser in orchestrator | pending | Parses 5 phases, extracts phase names, descriptions, exit criteria | Manual: parse link-triage plan.md | 1.6 | Read |
| 1.8 | Implement tasks.md parser in orchestrator | pending | Parses 66 tasks, extracts ID, description, depends, acceptance criteria | Manual: parse link-triage tasks.md | 1.6 | Read |
| 1.9 | Implement TaskList initialization | pending | Creates TaskCreate for all 66 tasks, stores task metadata | Manual: verify TaskList | 1.8 | TaskCreate |
| 1.10 | Implement sequential task execution | pending | Executes tasks one at a time, waits for completion, updates status | Manual: run Phase 1 task 1.1 | 1.9 | Task, TaskUpdate |
| 1.11 | Create task-executor.md agent (basic) | pending | Agent file with TDD placeholder (implement in Phase 5), commits per task | Manual: verify structure | 1.1 | Write |
| 1.12 | Implement commit logic in task-executor | pending | Stages files, uses commit template, includes task ID, acceptance criteria | Manual: verify commit msg | 1.11, 1.3 | Bash |
| 1.13 | Implement status.md session log updates | pending | Appends session log entries using template, shows phase transitions | Manual: verify status.md | 1.6, 1.4 | Edit |
| 1.14 | Test Phase 1 on link-triage-pipeline | pending | Executes Phase 1 (13 tasks), produces 13 commits, updates tasks.md | Manual: run full Phase 1 | 1.10, 1.12, 1.13 | All |

---

## Upcoming

### Phase 2: Ralph Loop Integration (Quality Gates)

| ID | Task | Status | Acceptance Criteria | Testing | Depends | Capability |
|----|------|--------|---------------------|---------|---------|------------|
| 2.1 | Add ralph-loop invocation to orchestrator | pending | Calls Skill tool with ralph-loop:ralph-loop at phase boundary | Manual: verify call | 1.6 | Skill |
| 2.2 | Implement ralph output parser | pending | Extracts severity (Critical/High/Medium/Low) via regex, handles errors | Manual: test with sample output | 2.1 | Read |
| 2.3 | Implement decision logic | pending | Critical → stop, High → create fix tasks, Medium/Low → log, Clean → proceed | Manual: test all paths | 2.2 | — |
| 2.4 | Implement fix task creation | pending | Creates tasks with F-prefix (1.F1, 1.F2), adds to current phase | Manual: verify F-prefix | 2.3 | TaskCreate |
| 2.5 | Implement ralph cycle tracking | pending | Tracks cycles 1, 2, 3 per phase, stops at 3 max, logs cycle count | Manual: verify max 3 | 2.3 | — |
| 2.6 | Test ralph integration | pending | Run Phase 1, inject High issue, verify fix task creation + re-review | Manual: full integration test | 2.4, 2.5 | All |

### Phase 3: Phase Validator (Exit Criteria)

| ID | Task | Status | Acceptance Criteria | Testing | Depends | Capability |
|----|------|--------|---------------------|---------|---------|------------|
| 3.1 | Create phase-validator.md agent | pending | Agent file with frontmatter (name, type: agent, color: yellow), structure | Manual: verify structure | 1.1 | Write |
| 3.2 | Implement exit criteria parser | pending | Extracts criteria from plan.md (natural language), categorizes type | Manual: parse Phase 1 criteria | 3.1 | Read |
| 3.3 | Implement test-based validation | pending | Runs pytest, parses output, checks pass rate | Manual: run pytest on sample | 3.2 | Bash |
| 3.4 | Implement execution-based validation | pending | Runs CLI commands, checks exit codes, validates output | Manual: run `--help` test | 3.2 | Bash |
| 3.5 | Implement artifact-based validation | pending | Checks file existence, parses content, validates structure | Manual: check file exists | 3.2 | Read |
| 3.6 | Implement validation report generator | pending | Generates ✓ PASS / ✗ FAIL report with details, surfaces to orchestrator | Manual: verify report format | 3.3, 3.4, 3.5 | — |
| 3.7 | Test validator integration | pending | Run Phase 1, validate exit criteria, verify blocking on fail | Manual: fail criterion, verify block | 3.6, 2.6 | All |

### Phase 4: Parallelization (Speed Optimization)

| ID | Task | Status | Acceptance Criteria | Testing | Depends | Capability |
|----|------|--------|---------------------|---------|---------|------------|
| 4.1 | Implement dependency graph analyzer | pending | Identifies ready tasks (all dependencies satisfied), returns list | Manual: test with Phase 2 tasks | 1.8 | — |
| 4.2 | Implement upfront dependency validation | pending | Checks for missing dependencies, circular dependencies, raises errors | Manual: inject invalid dep | 4.1 | — |
| 4.3 | Implement task grouping logic | pending | Groups by phase number, splits into chunks of 4, handles F-prefix | Manual: verify grouping | 4.1 | — |
| 4.4 | Implement parallel Task spawns | pending | Spawns 3-5 task-executor agents in single message (multiple Tool calls) | Manual: verify parallel spawn | 4.3, 1.11 | Task |
| 4.5 | Implement TaskList monitoring | pending | Polls TaskList, waits for completions, updates ready tasks | Manual: verify polling | 4.4 | TaskList |
| 4.6 | Implement blocker detection | pending | Detects task blockers from TaskUpdate, reports or invokes ralph-loop | Manual: inject blocker | 4.5 | TaskList |
| 4.7 | Implement stuck detection | pending | Detects no progress for 10 iterations, raises error with context | Manual: inject stuck state | 4.5 | — |
| 4.8 | Test parallel execution | pending | Run Phase 2, verify 3 groups spawn, time reduction ~50% vs sequential | Manual: full Phase 2 test | 4.4, 4.5, 4.6, 4.7 | All |

### Phase 5: TDD Enforcement (Quality Process)

| ID | Task | Status | Acceptance Criteria | Testing | Depends | Capability |
|----|------|--------|---------------------|---------|---------|------------|
| 5.1 | Enhance task-executor with TDD steps | pending | Adds: 1) write tests first, 2) run (red), 3) implement, 4) run (green) | Manual: verify sequence | 1.11 | Edit |
| 5.2 | Implement "write tests first" workflow | pending | Executor writes test file before implementation, uses pytest + mock | Manual: verify test written first | 5.1 | Write |
| 5.3 | Implement red phase validation | pending | Runs tests, verifies they fail (no implementation yet) | Manual: verify red | 5.2 | Bash |
| 5.4 | Implement green phase validation | pending | Runs tests after implementation, verifies they pass | Manual: verify green | 5.2 | Bash |
| 5.5 | Implement acceptance criteria checker | pending | Validates all criteria met before commit, blocks if not satisfied | Manual: inject unmet criterion | 5.4 | — |
| 5.6 | Test TDD workflow | pending | Run task 2.5, verify: tests written, red, code, green, commit both | Manual: full TDD test | 5.5, 4.8 | All |

### Phase 6: Traceability & Debugging (Observability)

| ID | Task | Status | Acceptance Criteria | Testing | Depends | Capability |
|----|------|--------|---------------------|---------|---------|------------|
| 6.1 | Implement run log writer | pending | Creates `output/runs/{date}-{uuid}.log`, writes log entries | Manual: verify log file | 1.5 | Write |
| 6.2 | Add INIT log entries | pending | Logs: execution start, project path, plan/tasks parsed, TaskList created | Manual: verify INIT entries | 6.1, 1.9 | Write |
| 6.3 | Add PHASE log entries | pending | Logs: phase start, phase complete, task counts, timings | Manual: verify PHASE entries | 6.1 | Write |
| 6.4 | Add SPAWN/COMPLETE/BLOCKED log entries | pending | Logs: task executor spawned, task done, task blocked with details | Manual: verify event entries | 6.1 | Write |
| 6.5 | Add RALPH/VALIDATE/FIX/ERROR log entries | pending | Logs: ralph invoked, validator run, fix tasks created, errors | Manual: verify all events | 6.1 | Write |
| 6.6 | Enhance commit message template | pending | Adds: acceptance criteria list, task ID, phase name, test file paths | Manual: verify commit content | 1.3 | Edit |
| 6.7 | Enhance session log entries | pending | Adds: timestamps, orchestrator decisions, blockers, phase summaries | Manual: verify status.md | 1.4 | Edit |
| 6.8 | Test troubleshooting from logs | pending | Inject failure, diagnose from git log + run log + session log alone | Manual: troubleshoot scenario | 6.2, 6.3, 6.4, 6.5, 6.6, 6.7 | All |

### Phase 7: Polish & CLI (Production Ready)

| ID | Task | Status | Acceptance Criteria | Testing | Depends | Capability |
|----|------|--------|---------------------|---------|---------|------------|
| 7.0 | Build-to-design verification | pending | All design requirements mapped to implementation: 3 agents created, DAG resolution implemented, ralph parsing working, parallelization functional | Manual: checklist vs design.md | 6.8 | Read |
| 7.1 | Implement --start-phase argument | pending | Parses arg, loads checkpoint state, resumes from phase N | Manual: test resume | 1.2 | Read |
| 7.2 | Implement --dry-run mode | pending | Simulates execution without commits or file writes, logs actions | Manual: verify no changes | 1.2 | — |
| 7.3 | Implement --max-parallel argument | pending | Parses arg, caps parallel groups at specified number (default 5) | Manual: test with 3 | 1.2 | — |
| 7.4 | Implement pause execution logic | pending | Gracefully stops, waits for in-progress tasks (5 min timeout) | Manual: invoke pause | 1.6 | TaskList |
| 7.5 | Implement checkpoint state saving | pending | Saves: run_id, phase, completed_tasks, ralph_cycles to state.json | Manual: verify state file | 7.4 | Write |
| 7.6 | Implement resume execution logic | pending | Reads checkpoint, updates TaskList, resumes from next phase | Manual: resume after pause | 7.5, 7.1 | Read |
| 7.7 | Refine error messages | pending | All errors include: context, root cause, suggested fix, actionable next steps | Manual: test all error paths | — | — |
| 7.8 | Create README.md | pending | Includes: purpose, architecture, invocation examples, troubleshooting | Manual: verify completeness | — | Write |
| 7.9 | Full end-to-end validation | pending | Run all 5 phases on link-triage-pipeline, verify all features work | Manual: full 66-task run | 7.0, 7.1, 7.2, 7.3, 7.6, 7.7, 7.8 | All |

---

## Completed

*No completed tasks yet*

---

## Task Statistics

- **Total tasks:** 48
- **Pending:** 48
- **In-progress:** 0
- **Completed:** 0
- **Blocked:** 0

**Progress:** 0% (0/48)

---

## Notes

### Testing Approach

All tasks use **manual validation** against link-triage-pipeline:
- Phase 1 validation: Execute 13 tasks sequentially
- Phase 2 validation: Inject High issue, verify ralph cycle
- Phase 3 validation: Test exit criteria validation
- Phase 4 validation: Execute 14 tasks in parallel
- Phase 5 validation: Verify TDD workflow on task 2.5
- Phase 6 validation: Troubleshoot from logs
- Phase 7 validation: Full 66-task execution with all features

### Dependencies Between Phases

- Phase 2 depends on Phase 1 (core orchestrator must work)
- Phase 3 depends on Phase 2 (validator runs after ralph)
- Phase 4 depends on Phase 1-3 (parallelization builds on base)
- Phase 5 depends on Phase 4 (TDD uses parallel execution)
- Phase 6 depends on Phase 1-5 (logs all events)
- Phase 7 depends on Phase 1-6 (polish requires all features)

**Critical path:** All phases sequential (no parallelization during build)

### Validation Target

**link-triage-pipeline** at `~/code/_shared/link-triage-pipeline/`
- Phase 1: 13 tasks (Foundation)
- Full plan: 66 tasks across 5 phases
- Provides real-world validation of orchestration logic

### F-Prefix Fix Tasks

Tasks created by ralph-loop during execution will use F-prefix:
- Example: 1.F1, 1.F2 (fix tasks for Phase 1)
- Not included in this task list (generated dynamically)
- Handled by Phase 2 fix task creation logic (task 2.4)
