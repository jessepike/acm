# Execute-Plan Orchestration Skill

Autonomous development orchestration skill that executes an approved `plan.md` + `tasks.md` with parallel task execution, quality gates, and complete traceability.

## Purpose

Automate the execution of ACM Develop stage plans. Given an approved plan and task breakdown, this skill:
- Spawns parallel task workers
- Enforces TDD workflow
- Runs quality gates (ralph-loop) at phase boundaries
- Validates exit criteria before proceeding
- Produces complete audit trail (git commits, run logs, session logs)

## Architecture

### Three Specialized Agents

| Agent | Role | File | Color |
|-------|------|------|-------|
| orchestrator | Phase-level coordinator | `agents/orchestrator.md` | Blue |
| task-executor | Task-level worker | `agents/task-executor.md` | Orange |
| phase-validator | Exit criteria checker | `agents/phase-validator.md` | Yellow |

### Orchestration Pattern

```
User invokes: /execute-plan

orchestrator (Phase Coordinator)
  ├─→ Parses plan.md (5 phases) and tasks.md (66 tasks)
  ├─→ Initializes Claude Code TaskList
  ├─→ For each phase:
  │   ├─→ Spawns 3-5 task-executor agents in parallel
  │   │   └─→ Each executor: tests first → implement → validate → commit
  │   ├─→ Waits for phase completion
  │   ├─→ Invokes ralph-loop for internal review
  │   │   └─→ If High issues: creates F-prefix fix tasks, re-runs
  │   └─→ Invokes phase-validator for exit criteria
  │       └─→ If FAIL: blocks, reports gaps
  └─→ Proceeds to next phase

Outputs:
  ├─→ Git: Atomic commits per task
  ├─→ Run log: output/runs/{date}-{uuid}.log
  └─→ Session log: appended to status.md
```

## Invocation

### Basic Usage

```bash
/execute-plan
```

Executes the full plan from start to finish.

### Resume from Phase

```bash
/execute-plan --start-phase 3
```

Resume from Phase 3 after a pause. Requires `.execute-plan-state.json` checkpoint.

### Dry Run

```bash
/execute-plan --dry-run
```

Simulate execution without making any changes. Useful for:
- Validating plan/tasks parse correctly
- Understanding execution flow
- Estimating task grouping

### Limit Parallelization

```bash
/execute-plan --max-parallel 3
```

Cap parallel groups at 3 (default: 5). Use for:
- Resource-constrained environments
- Debugging parallel execution issues
- Reducing context usage

## Prerequisites

Before invoking `/execute-plan`, ensure:

1. **Approved artifacts**:
   - `docs/plan.md` exists (Phase 3 output, HARD GATE approved)
   - `docs/tasks.md` exists (Phase 3 output, HARD GATE approved)

2. **Git repository**:
   - Working directory is a git repo
   - No uncommitted changes (commit or stash first)

3. **Project root**:
   - Invoke from project root (not a subdirectory)

## Outputs

### Git Commits

One commit per task with full traceability:

```
feat(phase-2): Implement ralph output parser

Acceptance:
- Extracts severity (Critical/High/Medium/Low) via regex
- Handles errors gracefully

Task: 2.2
Tests: tests/test_ralph_parser.py

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

### Run Log

Located at `output/runs/{date}-{uuid}.log`:

```
[2026-02-02T10:30:00] INFO: Execution started
[2026-02-02T10:30:01] INIT: Parsed 5 phases, 66 tasks
[2026-02-02T10:30:02] INIT: TaskList initialized (66 tasks created)
[2026-02-02T10:30:03] PHASE: Phase 1 started (14 tasks)
[2026-02-02T10:30:04] SPAWN: task-executor-1 (tasks: 1.1, 1.2, 1.3, 1.4)
[2026-02-02T10:30:04] SPAWN: task-executor-2 (tasks: 1.5, 1.6, 1.7, 1.8)
[2026-02-02T10:30:04] SPAWN: task-executor-3 (tasks: 1.9, 1.10, 1.11, 1.12)
[2026-02-02T10:35:20] COMPLETE: task-executor-1 (4 tasks done, 4 commits)
[2026-02-02T10:36:45] COMPLETE: task-executor-2 (4 tasks done, 4 commits)
[2026-02-02T10:38:10] COMPLETE: task-executor-3 (4 tasks done, 4 commits)
[2026-02-02T10:38:15] RALPH: Invoking ralph-loop for Phase 1 review
[2026-02-02T10:42:30] RALPH: Review complete - 0 Critical, 0 High, 2 Low
[2026-02-02T10:42:35] VALIDATE: Invoking phase-validator for Phase 1
[2026-02-02T10:43:00] VALIDATE: Phase 1 PASS (all criteria met)
[2026-02-02T10:43:01] PHASE: Phase 1 complete (14 tasks, 14 commits, 1 ralph cycle)
```

### Session Log

Appended to `status.md`:

```markdown
**2026-02-02 10:30** — EXECUTE: Started execute-plan orchestration (5 phases, 66 tasks)
**2026-02-02 10:43** — PHASE: Phase 1 complete (14 tasks, 14 commits, ralph clean)
**2026-02-02 11:15** — PHASE: Phase 2 complete (6 tasks, 8 commits including 2 fixes, 2 ralph cycles)
**2026-02-02 12:00** — PAUSE: Execution paused at phase 3
```

## Quality Gates

### Ralph Loop (Phase Boundaries)

After each phase completes, the orchestrator invokes ralph-loop for internal review:

**Severity Handling**:
- **Critical**: Stop execution, report to user, require manual intervention
- **High**: Create F-prefix fix tasks (e.g., 1.F1, 1.F2), re-run ralph (max 3 cycles)
- **Medium/Low**: Log only, proceed to next phase
- **Clean**: Proceed to phase validator

**F-Prefix Fix Tasks**:

When ralph-loop finds High issues, the orchestrator creates fix tasks:

```
Task ID: 1.F1 (Phase 1, Fix cycle 1, issue #1)
Description: Fix High issue - Missing error handling in parser
Acceptance: Error handling added, ralph review passes
```

Fix tasks are executed before proceeding, then ralph-loop re-runs.

**Max Cycles**:

Each phase allows up to 3 ralph cycles. If cycle 3 still has Critical/High issues:
- Stop execution
- Report to user with full context
- Require manual intervention

### Phase Validator (Exit Criteria)

After ralph-loop passes (0 Critical/High), the phase-validator checks exit criteria from `plan.md`:

**Validation Types**:

| Type | Example Criterion | Validation Method |
|------|-------------------|-------------------|
| Test-based | "All tests passing" | Run pytest, check pass rate |
| Execution-based | "CLI --help works" | Execute command, check exit code |
| Artifact-based | "README.md exists" | Check file, verify content |

**Blocking Behavior**:

If any criterion FAILS:
- Block phase transition
- Report gaps to user
- Do NOT proceed to next phase

Example failure report:

```
Phase 2 Validation Report
═════════════════════════

✓ PASS: All tests passing (23/23 tests passed)
✗ FAIL: CLI --help works (command failed: ModuleNotFoundError)
✓ PASS: Templates created (all 3 templates verified)

──────────────────────────
Overall: FAIL (2/3 criteria met)

Blocking Issue:
- CLI --help command fails due to missing module imports
  Suggested fix: Install dependencies or fix import paths
```

## TDD Workflow

Starting in Phase 5 (TDD Enforcement), task-executor agents follow a strict tests-first workflow:

1. **Write tests first** (before any implementation):
   ```python
   # tests/test_feature.py
   def test_feature():
       assert feature.works() == True
   ```

2. **Red phase**: Run tests, verify they FAIL
   ```bash
   pytest tests/test_feature.py  # Should fail
   ```

3. **Implement**: Write minimal code to satisfy acceptance criteria
   ```python
   # src/feature.py
   def works():
       return True
   ```

4. **Green phase**: Run tests, verify they PASS
   ```bash
   pytest tests/test_feature.py  # Should pass
   ```

5. **Commit both**: Stage implementation + tests, commit atomically

## Traceability

### Three Audit Trails

| Trail | Location | Purpose |
|-------|----------|---------|
| Git commits | Git history | One commit per task with full acceptance criteria |
| Run log | `output/runs/{uuid}.log` | All execution events (INIT, PHASE, SPAWN, RALPH, VALIDATE, etc.) |
| Session log | `status.md` | High-level orchestrator decisions and phase summaries |

### Troubleshooting from Logs

To diagnose issues:

1. **Check git log** for commit history:
   ```bash
   git log --oneline --grep="Task:"
   ```

2. **Check run log** for execution events:
   ```bash
   grep "ERROR\|BLOCKED" output/runs/*.log
   ```

3. **Check session log** in `status.md` for decisions:
   ```
   ## Session Log
   **2026-02-02 11:15** — BLOCKED: Task 2.5 blocked on unmet dependency 2.3
   **2026-02-02 11:20** — DECISION: Created fix task 2.F1 for ralph High issue
   ```

## Parallelization

The orchestrator spawns 3-5 parallel task-executor agents per phase:

**Task Grouping Algorithm**:

1. Identify ready tasks (all dependencies satisfied)
2. Group by phase number (e.g., all tasks starting with "2.")
3. Split into chunks of 1-4 related tasks
4. Respect `--max-parallel` limit (default: 5)
5. Spawn all groups in single message (multiple Tool calls)

**Example**: Phase 2 has 6 tasks (2.1, 2.2, 2.3, 2.4, 2.5, 2.6)

```
Group 1: [2.1, 2.2] → task-executor-1
Group 2: [2.3, 2.4] → task-executor-2
Group 3: [2.5, 2.6] → task-executor-3
```

All three spawn simultaneously, work in parallel, report completion independently.

## Pause & Resume

**Pause**: If execution is interrupted (Ctrl+C, user request):

1. Orchestrator waits for in-progress tasks (5 min timeout)
2. Saves checkpoint state to `.execute-plan-state.json`
3. Reports: "Execution paused. Resume with: /execute-plan --start-phase N"

**Resume**: Re-run with `--start-phase N`:

1. Reads checkpoint state
2. Updates TaskList with completed tasks
3. Resumes from next phase
4. Continues execution

## Validation Target

This skill was initially developed and validated against **link-triage-pipeline**:
- 66 tasks across 5 phases
- Real-world ACM Develop stage project
- Provides end-to-end validation of orchestration logic

## Troubleshooting

### "Plan or tasks file not found"

**Cause**: Missing `docs/plan.md` or `docs/tasks.md`

**Fix**: Ensure you've completed Develop Phase 3 (Planning) and received HARD GATE approval.

### "Checkpoint not found" (with --start-phase)

**Cause**: No `.execute-plan-state.json` file

**Fix**: Either:
- Run full execution from start (remove `--start-phase`)
- Verify you're in the correct project directory

### "Task dependency not satisfied"

**Cause**: Missing or circular dependency in `tasks.md`

**Fix**: Review task dependencies in `tasks.md`, ensure all referenced task IDs exist.

### "Ralph loop exceeded max cycles"

**Cause**: Phase still has Critical/High issues after 3 ralph cycles

**Fix**:
- Review ralph-loop output in run log
- Manually address the blocking issues
- Re-run from paused phase after fixes

### "Phase validation failed"

**Cause**: Exit criteria not met (tests failing, files missing, commands failing)

**Fix**:
- Review phase-validator report in run log
- Address the specific failures listed
- Re-run validation

## Examples

### Full Execution (Clean Run)

```bash
# From project root with approved plan.md + tasks.md
cd ~/code/my-project
/execute-plan

# Execution proceeds through all phases
# Produces: 66 commits, 1 run log, session log entries
# Output: "Execution complete - all 5 phases done"
```

### With Ralph Fixes

```bash
/execute-plan

# Phase 2 ralph-loop finds 2 High issues
# Orchestrator creates: 2.F1, 2.F2
# Executes fix tasks
# Re-runs ralph-loop → clean
# Proceeds to phase-validator
```

### Pause & Resume

```bash
# Start execution
/execute-plan

# User interrupts during Phase 3
^C

# Orchestrator: "Execution paused. Resume with: /execute-plan --start-phase 3"

# Later, resume from Phase 3
/execute-plan --start-phase 3

# Execution continues from Phase 3
```

### Dry Run (No Changes)

```bash
/execute-plan --dry-run

# Parses plan.md and tasks.md
# Logs: "Would spawn task-executor-1 with tasks 1.1-1.4"
# Logs: "Would invoke ralph-loop for Phase 1"
# Output: "DRY RUN complete - no changes made"
```

## Files

```
skills/execute-plan/
├── skill.md                    # Main entry point (user-invocable)
├── README.md                   # This file
├── agents/
│   ├── orchestrator.md         # Phase coordinator (blue)
│   ├── task-executor.md        # Task worker (orange)
│   └── phase-validator.md      # Exit criteria checker (yellow)
└── templates/
    ├── commit-message.txt      # Git commit template
    ├── session-log-entry.txt   # Status.md log format
    └── run-log-entry.txt       # Run log format
```

## Capabilities Used

- **Claude Code tools**: Task, TaskCreate, TaskUpdate, TaskList, Bash, Read, Write, Edit
- **Skills**: ralph-loop:ralph-loop (phase boundary review)
- **MCP**: acm-server (stage details, review prompts)
- **Git**: Atomic commits, traceability

## Design Decisions

| # | Decision | Rationale |
|---|----------|-----------|
| D1 | Centralized orchestration (LangGraph pattern) | Single orchestrator coordinates all agents — simple, debuggable, traceable |
| D2 | DAG-based dependency resolution (Airflow/Bazel pattern) | "Ready check" at phase start — supports dependencies across phases |
| D3 | Phase-level checkpointing (Temporal.io pattern) | Not task-level — reduces checkpoint frequency, simpler resume logic |
| D4 | 3-5 parallel groups max | Balances speed vs system load — prevents context overflow |
| D5 | F-prefix for fix tasks | Avoids ID collisions — 1.F1 vs 1.4 keeps numbering clean |
| D6 | Max 3 ralph cycles per phase | Prevents infinite loops — forces human intervention if persistent issues |
| D7 | TDD enforced in Phase 5+ | Progressive implementation — lets core foundation stabilize first |
| D8 | Three specialized agents | Single-responsibility — orchestrator coordinates, executors implement, validator checks |
| D9 | Atomic commits per task | Full traceability — git log shows complete audit trail |
| D10 | Three audit trails (git/run/session) | Observability layers — git=what, run=how, session=why |

## Notes

- This is a **narrow skill** for ACM Develop stage automation, not a general-purpose orchestrator
- Zero external dependencies — pure markdown agent prompts
- Designed for MVP/commercial full-scope projects (apps, workflows, artifacts)
- Future enhancement: ML-based natural language criterion parsing for phase-validator
