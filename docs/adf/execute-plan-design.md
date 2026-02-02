---
type: "design"
artifact: "execute-plan-skill"
version: "0.2"
status: "approved"
created: "2026-02-02"
updated: "2026-02-02"
stage: "develop"
phase: "design"
review_cycles: 2
issues_resolved: "High: 3 (task grouping, stuck detection, ralph parsing)"
final_assessment: "0 Critical, 0 High, 2 Medium (non-blocking), 1 Low - Ready for implementation"
---

# Design: Execute-Plan Orchestration Skill

## Summary

Autonomous development orchestration skill that executes approved `plan.md` + `tasks.md` during Develop stage Build phase. Uses centralized orchestration pattern with parallel task executors, DAG-based dependency resolution, phase-level checkpointing, and ralph-loop quality gates.

**Scope:** Narrow skill (not general ACM orchestrator) - single purpose: automate plan execution with TDD, atomic commits, and quality reviews.

---

## Architecture Overview

### System Context

```
User invokes /execute-plan
    ↓
Orchestrator Agent (main coordinator)
    ↓
Phase Execution Loop (1 to N phases)
    ↓
├─→ Dependency Analysis (DAG-based "ready check")
├─→ Task Grouping (sequential IDs, max 3-5 groups)
├─→ Spawn Task Executors (parallel via Task tool)
├─→ Monitor Progress (TaskList polling)
├─→ Phase Boundary: Ralph Loop Review
├─→ Phase Exit Criteria Validation
└─→ Checkpoint & Advance
    ↓
Final Report (status.md update, completion summary)
```

**Key decisions:**
- Centralized orchestration (LangGraph pattern)
- Phase-level checkpointing (Temporal.io pattern)
- DAG dependency resolution (Airflow/Bazel pattern)
- Parallel task groups (GitHub Actions pattern)

---

## Core Components

### 1. Orchestrator Agent

**Role:** Phase-level coordinator

**Responsibilities:**
- Parse plan.md (phases) + tasks.md (tasks with dependencies)
- Create TaskList (TaskCreate × N tasks at start)
- For each phase:
  - Identify ready tasks (dependencies satisfied)
  - Group independent tasks (3-5 parallel max)
  - Spawn task executors via Task tool
  - Monitor via TaskList until phase complete
  - Invoke ralph-loop at phase boundary
  - Validate phase exit criteria
  - Checkpoint state, advance to next phase
- Surface only critical blockers to user

**Stopping conditions:**
- Critical ralph-loop issues
- Infrastructure failures (API unreachable, DB down)
- Unresolvable test failures (after ralph-loop attempts)
- Phase exit criteria fail validation
- User invokes `/pause-execution`

**Integration points:**
- ACM MCP: `get_stage()`, `get_review_prompt()`, `check_project_health()`
- Ralph Loop plugin: `ralph-loop:ralph-loop` skill invocation
- Task tools: TaskCreate, TaskUpdate, TaskList
- Git: Atomic commits via Bash tool

---

### 2. Task Executor Agent

**Role:** Task worker with TDD enforcement

**Responsibilities:**
- Receive 1-4 related tasks from orchestrator
- For each task (sequential execution):
  1. Understand context (read plan.md, design.md, existing code)
  2. Write tests FIRST (TDD red phase)
  3. Implement code to pass tests (TDD green phase)
  4. Validate acceptance criteria met
  5. Commit atomically (code + tests)
  6. Update TaskList status (TaskUpdate)
- Report completion or blockers to orchestrator

**Error handling:**
- Test failures: Retry 1 time (2 attempts total), then report blocker
- Missing dependencies: Report immediately, don't assume/improvise
- Infrastructure issues: Report immediately, no retry

**TDD Protocol:**
```
Write tests → Run (fail/red) → Implement → Run (pass/green) → Commit
```

**Commit message template:**
```
feat(task-X.Y): <description>

<acceptance criteria list>

Acceptance criteria met: ✓
Task ID: X.Y
Phase: X (<phase name>)
Tests: <test file paths>

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

---

### 3. Phase Validator Agent

**Role:** Exit criteria verification

**Responsibilities:**
- Parse phase exit criteria from plan.md
- Check each criterion programmatically:
  - Test-based: Run pytest, check pass rate
  - Execution-based: Run CLI commands, check exit codes
  - Artifact-based: Verify files exist, contain required content
- Generate pass/fail report
- Signal orchestrator: proceed or block

**Example validation:**
```
Phase 1 Exit Criteria Validation

✓ `python -m link_triage --help` shows usage (exit code 0)
✓ DB schema creates successfully (3 tables created)
✗ Config loader handles missing files gracefully
  - Error: FileNotFoundError not caught in config.py:23
  - Expected: ConfigurationError with clear message

Result: FAIL (1/3 criteria failed)
Recommendation: Fix config.py error handling before Phase 2
```

---

## Dependency Resolution (DAG-Based)

**Research basis:** Airflow, Bazel, Argo Workflows use DAG (Directed Acyclic Graph) for dependency management.

**Our approach: Simple "ready check"** (no complex topological sort)

```python
def get_ready_tasks(phase_tasks, completed_task_ids):
    """Returns tasks with all dependencies satisfied"""
    ready = []
    for task in phase_tasks:
        if task.status == "pending":
            # Check if all dependencies are in completed set
            deps_satisfied = all(dep in completed_task_ids for dep in task.depends)
            if deps_satisfied:
                ready.append(task)
    return ready
```

**Example Phase 2 dependencies:**
```
Task 2.1: depends on 1.8 → ready if 1.8 done
Task 2.2: depends on 2.1 → ready if 2.1 done
Task 2.5: depends on 1.8 → ready if 1.8 done (parallel with 2.1)
Task 2.11: depends on 1.10 → ready if 1.10 done
```

**Result:**
- When Phase 2 starts: 2.1, 2.5, 2.9, 2.11 are "ready" (all deps satisfied)
- After 2.1 done: 2.2 becomes ready
- No need for topological sort - just check deps on each iteration

**Edge cases:**
- Circular dependencies: Detected by upfront validation (see below)
- Cross-phase dependencies: Handled naturally (all previous phase tasks done)
- Missing dependency: Detected by upfront validation and stuck detection (see below)

**Upfront dependency validation:**
```python
def validate_dependencies(all_tasks):
    """Validate all dependencies exist before starting execution

    Catches invalid dependencies early instead of silent hang.
    """
    task_ids = {t.id for t in all_tasks}
    errors = []

    for task in all_tasks:
        for dep in task.depends:
            if dep not in task_ids:
                errors.append(
                    f"Task {task.id} depends on nonexistent task '{dep}'"
                )

    if errors:
        raise InvalidDependencyError(
            f"Found {len(errors)} invalid dependencies:\n" +
            "\n".join(errors)
        )

    # Check for circular dependencies (simple cycle detection)
    for task in all_tasks:
        visited = set()
        if has_circular_dependency(task, all_tasks, visited):
            raise CircularDependencyError(
                f"Circular dependency detected involving task {task.id}"
            )

def has_circular_dependency(task, all_tasks, visited):
    """Detect circular dependencies via DFS"""
    if task.id in visited:
        return True

    visited.add(task.id)
    task_map = {t.id: t for t in all_tasks}

    for dep_id in task.depends:
        if dep_id in task_map:
            dep_task = task_map[dep_id]
            if has_circular_dependency(dep_task, all_tasks, visited.copy()):
                return True

    return False
```

**Runtime stuck detection:**
```python
def execute_phase_with_stuck_detection(phase_tasks):
    """Execute phase tasks with stuck state detection

    Prevents infinite loop if tasks never become ready due to bugs.
    """
    MAX_ITERATIONS_WITHOUT_PROGRESS = 10
    iterations_since_progress = 0
    completed_task_ids = set()

    while has_pending_tasks(phase_tasks):
        ready = get_ready_tasks(phase_tasks, completed_task_ids)

        if len(ready) == 0:
            # No tasks ready - either waiting for dependencies or stuck
            iterations_since_progress += 1

            if iterations_since_progress >= MAX_ITERATIONS_WITHOUT_PROGRESS:
                # No progress in 10 iterations = stuck state
                pending = [t for t in phase_tasks if t.status == "pending"]
                raise StuckStateError(
                    f"No progress after {MAX_ITERATIONS_WITHOUT_PROGRESS} iterations. "
                    f"Pending tasks: {[t.id for t in pending]}. "
                    f"Their dependencies: {[(t.id, t.depends) for t in pending]}. "
                    f"This likely indicates a bug in dependency resolution or "
                    f"tasks.md has errors that passed validation."
                )

            # Brief wait before retry
            time.sleep(5)
        else:
            # Progress made, reset counter
            iterations_since_progress = 0

            # Execute ready tasks
            for task_group in group_tasks(ready):
                spawn_task_executor(task_group)

            # Wait for completions, update completed set
            wait_for_task_completions()
            completed_task_ids.update([t.id for t in phase_tasks if t.status == "completed"])

    return completed_task_ids
```

**Rationale for stuck detection:**
- Upfront validation catches obvious errors (missing tasks, circular deps)
- Runtime detection catches subtle bugs or edge cases that passed validation
- 10 iterations × 5 seconds = 50 seconds max wait before surfacing error
- Prevents silent infinite loop, surfaces actionable error message

---

## Task Grouping Strategy

**Research basis:** GitHub Actions parallel jobs, Bazel package-level granularity.

**Our approach: Phase-based grouping** (fixed from sequential ID heuristic)

```python
def group_tasks(ready_tasks):
    """Group tasks by phase number into execution batches

    Handles non-sequential IDs (gaps from removed/consolidated tasks)
    and dynamically-added fix tasks (e.g., 1.14, 1.15 after 1.13)
    """
    groups = []
    tasks_by_phase = {}

    # Group all tasks by phase (e.g., all 2.X together)
    for task in ready_tasks:
        phase = extract_phase_number(task.id)
        if phase not in tasks_by_phase:
            tasks_by_phase[phase] = []
        tasks_by_phase[phase].append(task)

    # Split each phase's tasks into groups of max 4
    for phase, phase_tasks in sorted(tasks_by_phase.items()):
        sorted_tasks = sorted(phase_tasks, key=lambda t: extract_task_number(t.id))

        # Create groups of 4 tasks each
        for i in range(0, len(sorted_tasks), 4):
            group = sorted_tasks[i:i+4]
            groups.append(group)

    return groups[:5]  # Max 5 parallel groups

def extract_phase_number(task_id):
    """Extract phase number from task ID: '2.5' → 2, '1.F3' → 1"""
    return int(task_id.split('.')[0])

def extract_task_number(task_id):
    """Extract task number for sorting: '2.5' → 5, '1.F3' → 1003 (F prefix = 1000+)"""
    parts = task_id.split('.')
    task_part = parts[1]

    if task_part.startswith('F'):
        # Fix tasks sort after regular tasks: F3 → 1003
        return 1000 + int(task_part[1:])
    else:
        return int(task_part)
```

**Example Phase 2 grouping (sequential IDs):**
```
Ready tasks: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 2.10

Phase 2 tasks grouped into chunks of 4:
- Group A: 2.1, 2.2, 2.3, 2.4
- Group B: 2.5, 2.6, 2.7, 2.8
- Group C: 2.9, 2.10

Spawn 3 task executors in parallel (one per group)
```

**Example with non-sequential IDs (gaps from removed tasks):**
```
Ready tasks: 2.1, 2.3, 2.5, 2.7, 2.9, 2.10, 2.11, 2.12

Phase 2 tasks grouped into chunks of 4:
- Group A: 2.1, 2.3, 2.5, 2.7 (sorted by task number)
- Group B: 2.9, 2.10, 2.11, 2.12

Spawn 2 task executors in parallel
```

**Example with fix tasks:**
```
Ready tasks: 1.13, 1.F1, 1.F2 (F tasks added after ralph-loop)

Phase 1 tasks grouped:
- Group A: 1.13, 1.F1, 1.F2 (fix tasks sort after regular)

Spawn 1 task executor
```

**Rationale:**
- Phase-based grouping handles non-sequential IDs gracefully
- Max 4 tasks per group = reasonable sub-agent scope
- Max 5 parallel groups = balance speed vs context overflow
- Sorting ensures logical execution order within groups

**Edge cases handled:**
- Non-sequential ready tasks (2.1, 2.5, 2.9): Grouped by phase, sorted by task number
- Single ready task: Single group, no parallelization needed
- More than 5 groups: Take first 5, rest wait for next iteration
- Fix tasks (1.F1, 1.F2): Sort after regular tasks (1000+ offset)

---

## Parallelization Strategy

**Research basis:**
- LangGraph: 2.2x faster than CrewAI with centralized orchestration
- Bazel: Up to 90% build time reduction with parallel execution
- GitHub Actions: Parallel jobs for independent tests/builds

**Our approach: 3-5 parallel task groups max**

```
Orchestrator spawns multiple Task tools in single message:

Task(subagent_type="task-executor", prompt="Execute tasks 2.1-2.4", ...)
Task(subagent_type="task-executor", prompt="Execute tasks 2.5-2.8", ...)
Task(subagent_type="task-executor", prompt="Execute tasks 2.9-2.10", ...)

All three run concurrently, orchestrator monitors via TaskList.
```

**Example timeline (Phase 2):**
```
Time    Group A (2.1-2.4)    Group B (2.5-2.8)    Group C (2.9-2.10)
────────────────────────────────────────────────────────────────────
14:00   Start               Start               Start
14:30   2.1 done            2.5 done            2.9 done
15:00   2.2 done            2.6 done            2.10 done ✓
15:30   2.3 done            2.7 done
16:00   2.4 done ✓          2.8 done ✓

Total: ~2 hours (vs 4 hours sequential)
```

**Constraints:**
- Max 5 parallel groups (token/context limits)
- Task executors must not touch same files (avoid conflicts)
- Sequential IDs heuristic naturally separates by module

**Benefits:**
- ~50% time reduction for independent phases (2, 3, 4)
- Phases 1 and 5 (Foundation, Testing) less parallelizable, but still benefit

---

## Ralph Loop Integration

**Phase boundary review:** After all phase tasks complete, before advancing.

**Invocation:**
```python
# Orchestrator at phase boundary
review_prompt = mcp__acm__get_review_prompt(
    stage="develop",
    phase="internal"
)

Skill(
    skill="ralph-loop:ralph-loop",
    args=f"--artifact docs/plan.md --focus 'Phase {N} completed work: {changed_files}'"
)
```

**Output parsing:**
```
Expected ralph-loop output format:

## Review Findings

[Critical] Database schema missing foreign key constraints
- Impact: Data integrity risk
- Location: link_triage/db.py:45

[High] Config loader doesn't validate required fields
- Impact: Runtime errors possible
- Location: link_triage/config.py:23

[Medium] Missing docstrings on public functions
- Impact: Developer experience
```

**Parser (with robust error handling):**
```python
def parse_ralph_output(output_text):
    """Extract severity + issues from ralph-loop output

    Robust error handling prevents false negatives (skipping quality gates).
    """
    if not output_text or len(output_text.strip()) < 10:
        raise RalphParseError(
            "Ralph-loop returned empty or near-empty output. "
            "Review may have failed silently."
        )

    # Check for error indicators in output
    error_patterns = [
        "error:", "failed:", "unable to", "exception:",
        "could not", "cannot", "failure:", "crashed"
    ]
    lower_output = output_text.lower()
    if any(pattern in lower_output for pattern in error_patterns):
        # Ralph-loop encountered an error during review
        raise RalphExecutionError(
            f"Ralph-loop failed during execution. "
            f"Output preview: {output_text[:300]}"
        )

    # Extract issues using expected format
    issues = []
    pattern = r'\[(Critical|High|Medium|Low)\] (.+?)(?=\n- |\n\[|\Z)'
    matches = list(re.finditer(pattern, output_text, re.DOTALL))

    if len(matches) == 0:
        # No severity tags found - either clean or unexpected format
        # Check for explicit success indicators
        success_indicators = [
            "review complete", "no issues found", "no issues detected",
            "review passed", "clean", "0 issues"
        ]
        if any(indicator in lower_output for indicator in success_indicators):
            # Explicitly clean review
            return []
        else:
            # Unexpected format - don't assume clean
            raise RalphParseError(
                f"Ralph-loop output doesn't match expected format. "
                f"Expected severity tags [Critical], [High], etc. "
                f"Output preview: {output_text[:300]}"
            )

    # Parse matched issues
    for match in matches:
        severity = match.group(1)
        description = match.group(2).strip()
        issues.append({
            "severity": severity,
            "description": description,
            "raw": match.group(0)  # Keep raw text for debugging
        })

    return issues

class RalphParseError(Exception):
    """Raised when ralph-loop output can't be parsed"""
    pass

class RalphExecutionError(Exception):
    """Raised when ralph-loop execution failed"""
    pass
```

**Decision logic (with error handling):**
```python
try:
    issues = parse_ralph_output(ralph_response)

    critical_count = sum(1 for i in issues if i["severity"] == "Critical")
    high_count = sum(1 for i in issues if i["severity"] == "High")

    if critical_count > 0:
        # Critical issues - stop execution, surface to user
        stop_execution()
        surface_to_user(ralph_report)
    elif high_count > 0:
        # High issues - create fix tasks, loop back
        fix_tasks = create_fix_tasks(issues, severity="High")
        add_to_current_phase(fix_tasks)
        loop_back_to_task_execution()
        # After fixes, re-invoke ralph-loop (cycle 2)
    else:
        # Clean or only Medium/Low issues - proceed
        proceed_to_phase_validation()

except RalphExecutionError as e:
    # Ralph-loop failed to execute (API error, crash, etc.)
    log_error(f"Ralph-loop execution failed: {e}")
    # Don't skip quality gate - surface to user
    stop_execution()
    surface_to_user(
        f"Ralph-loop failed during Phase {phase_num} review. "
        f"Cannot proceed without quality gate. Error: {e}"
    )

except RalphParseError as e:
    # Ralph-loop output format unexpected
    log_error(f"Ralph-loop output parsing failed: {e}")
    # Don't assume clean - surface to user for manual review
    stop_execution()
    surface_to_user(
        f"Ralph-loop output format unexpected for Phase {phase_num}. "
        f"Manual review required. Error: {e}"
    )
```

**Fix task generation:**
```python
def create_fix_tasks(issues, severity):
    """Auto-generate fix tasks from ralph-loop issues"""
    fix_tasks = []
    last_task_id = get_last_phase_task_id()  # e.g., 1.13

    for i, issue in enumerate([iss for iss in issues if iss["severity"] == severity], start=1):
        task_id = f"{last_task_id.split('.')[0]}.{int(last_task_id.split('.')[1]) + i}"

        fix_task = {
            "id": task_id,
            "description": f"Fix: {issue['description']}",
            "acceptance_criteria": f"Address ralph-loop {severity}: {issue['description']}",
            "depends": [],
            "status": "pending"
        }

        fix_tasks.append(fix_task)
        TaskCreate(taskId=task_id, subject=fix_task["description"], ...)

    return fix_tasks
```

**Example:**
```
Phase 1 complete → Ralph-loop finds 2 High issues
→ Create tasks 1.14, 1.15 (fix tasks)
→ Add to Phase 1 task list
→ Execute 1.14, 1.15
→ Re-invoke ralph-loop (cycle 2)
→ If clean: proceed to phase validation
```

**Max ralph cycles per phase: 3** (avoid infinite loops)

---

## State Management & Checkpointing

**Research basis:** Temporal.io (automatic state capture), LangGraph (checkpoint persistence).

**Our approach: Phase-level checkpointing** (not task-level, too granular for MVP)

**State file:** `output/runs/{run-id}.state.json`

```json
{
  "run_id": "2026-02-02-abc123",
  "phase": 2,
  "completed_tasks": ["1.1", "1.2", ..., "2.1", "2.2"],
  "in_progress": ["2.3", "2.5"],
  "ralph_cycles": {
    "1": 2,
    "2": 0
  },
  "last_updated": "2026-02-02T15:30:00Z"
}
```

**Checkpoint frequency:** After each phase completion

**Rationale:**
- Phase-level = 5 checkpoints for 66-task plan (low overhead)
- Task-level = 66 checkpoints (high overhead, diminishing returns)
- Trade-off: Max lost work on failure = one phase (acceptable for MVP)

**Resume logic:**
```python
def resume_execution(run_id):
    """Resume from last checkpoint"""
    state = read_json(f"output/runs/{run_id}.state.json")

    # TaskList already has all tasks, update to match checkpoint
    for task_id in state["completed_tasks"]:
        TaskUpdate(taskId=task_id, status="completed")

    # Resume from next phase
    start_phase = state["phase"] + 1
    execute_phases(start_from=start_phase)
```

**Pause logic:**
```python
def pause_execution():
    """Graceful stop, save state"""
    # Set flag, wait for current task executors to finish
    wait_for_in_progress_tasks(timeout=300)  # 5 min max

    # Save current state
    checkpoint_phase(current_phase, completed_tasks, run_id)

    surface_to_user("Execution paused. Resume with /resume-execution {run_id}")
```

---

## Error Handling & Recovery

**Research basis:** GitHub Actions retry patterns, CI/CD fail-fast strategies.

**Our approach: Simple retry + surface blockers**

### Task-Level Errors

```python
def execute_task_with_retry(task):
    """Execute task with 1 retry"""
    for attempt in range(1, 3):  # Attempts: 1, 2
        try:
            result = task_executor.execute(task)
            return result  # Success

        except TestFailure as e:
            if attempt == 2:
                return TaskResult(status="BLOCKED", reason="Tests failing after 2 attempts", error=e)
            # Else: retry

        except InfrastructureError as e:
            # Don't retry infrastructure issues (API down, DB unreachable)
            return TaskResult(status="BLOCKED", reason="Infrastructure failure", error=e)

        except DependencyMissing as e:
            # Missing file, module, dependency
            return TaskResult(status="BLOCKED", reason="Missing dependency", error=e)

    return TaskResult(status="BLOCKED", reason="Max retries exceeded")
```

**Retry policy:**
- Test failures: 1 retry (2 attempts total)
- Infrastructure failures: 0 retries (stop immediately)
- Dependency issues: 0 retries (surface immediately)

**Rationale:**
- Test failures might be flaky (retry worth it)
- Infrastructure failures unlikely to resolve in 30 seconds (don't waste time)
- Dependency issues require human intervention (can't auto-fix)

### Ralph-Loop Errors

```python
def handle_ralph_failure(error):
    """Ralph-loop invocation failed"""
    # API error, timeout, invalid response
    log_warning(f"Ralph-loop failed: {error}")

    # Decision: Proceed without review (log warning) or stop?
    # Recommendation: STOP (don't skip quality gate)
    return TaskResult(status="BLOCKED", reason="Ralph-loop failed", error=error)
```

### Phase Validator Errors

```python
def handle_validator_failure(error):
    """Phase validator failed to run"""
    log_warning(f"Phase validator failed: {error}")

    # Decision: Proceed without validation or stop?
    # Recommendation: STOP (don't skip exit criteria)
    return TaskResult(status="BLOCKED", reason="Phase validation failed", error=error)
```

### Git Commit Errors

```python
def handle_commit_failure(error):
    """Git commit failed"""
    # Possible: merge conflict, permissions, disk full

    # Auto-retry once (might be transient)
    if auto_retry_git_commit():
        return  # Success on retry

    # Still failing: surface to user
    return TaskResult(status="BLOCKED", reason="Git commit failed", error=error)
```

**Summary:**
- Fail fast on infrastructure/validation failures
- Give tests one retry (flakiness tolerance)
- Surface all blockers with context to user

---

## Traceability System

**Three-layer output for agent troubleshooting:**

### 1. Git Commit History

**Per-task commits:**
```bash
git log --oneline --grep="task-"

2p3q4r5 chore(phase-1): complete Phase 1 - Foundation
1o2p3q4 feat(task-1.15): add config.yaml validation
0n1o2p3 feat(task-1.14): improve config error messages
9m0n1o2 feat(task-1.13): wire config + DB init into CLI
8l9m0n1 feat(task-1.12): create CLI stub with argparse
...
```

**Commit message includes:**
- Task ID, description
- Acceptance criteria (what was validated)
- Test file paths
- Co-authored-by for tracking

**Use case:** Agent can `git bisect` to find which task introduced a bug.

### 2. Run Log

**File:** `output/runs/{date}-{uuid}.log`

**Format:**
```
[timestamp] LOG_LEVEL MESSAGE

Log levels: INIT, PHASE, SPAWN, COMPLETE, BLOCKED, RALPH, VALIDATE, FIX, ERROR
```

**Example:**
```
[2026-02-02 14:23:45] INIT Execute-plan started (run ID: abc123)
[2026-02-02 14:23:49] PHASE Phase 1 started: Foundation (13 tasks)
[2026-02-02 14:25:12] SPAWN Task executor agent_1 (tasks 1.1-1.4) - agent_id: xyz123
[2026-02-02 14:47:33] COMPLETE Task 1.5 done - commit: def456 - agent_id: xyz124
[2026-02-02 14:52:01] BLOCKED Task 1.9 blocked: FileNotFoundError .env - agent_id: xyz125
[2026-02-02 15:05:00] RALPH Phase 1 ralph-loop invoked
[2026-02-02 15:05:45] RALPH Ralph-loop output: 0 Critical, 2 High issues
[2026-02-02 15:12:00] FIX Created fix tasks: 1.14, 1.15
[2026-02-02 16:17:20] VALIDATE Phase 1 exit criteria: ALL PASS (3/3)
[2026-02-02 16:17:35] PHASE Phase 1 complete (15 tasks, 15 commits, 1h 53min)
```

**Use case:** Agent can trace exact orchestrator decisions, timings, blockers.

### 3. Session Log (status.md)

**Appended to status.md:**
```markdown
## Session: 2026-02-02 Automated Plan Execution

**Run ID:** 2026-02-02-abc123

**14:23** - Execute-plan started
**14:24** - Phase 1 started: Foundation (13 tasks)
**15:18** - Task 1.9 blocked: config error handling (ralph-loop invoked)
**15:55** - Phase 1 tasks complete (13/13)
**15:56** - Phase 1 ralph-loop: 2 High issues, created fix tasks 1.14-1.15
**16:17** - Phase 1 exit criteria: PASS
**16:17** - Phase 1 complete: 15 commits
**16:18** - Phase 2 started: Core Pipeline Components (14 tasks)
...
```

**Use case:** High-level summary of orchestrator progress, visible to user.

---

## Integration Points

### ADF MCP Server

**Tools used:**
```python
# Pre-flight check
mcp__acm__get_stage("develop")  # Verify we're in Develop stage

# Phase boundary
review_prompt = mcp__acm__get_review_prompt(
    stage="develop",
    phase="internal"
)

# Optional health check
mcp__acm__check_project_health(project_path)
```

### Ralph Loop Plugin

**Invocation:**
```python
Skill(
    skill="ralph-loop:ralph-loop",
    args=f"--artifact docs/plan.md --focus 'Phase {N} completed work'"
)
```

**Expected output:** Structured text with severity tags `[Critical]`, `[High]`, etc.

**Output format handling:**
- Parser expects severity tags: `[Critical]`, `[High]`, `[Medium]`, `[Low]`
- Detects error patterns: "error:", "failed:", "unable to", "exception:"
- Requires explicit success indicators if no issues found: "review complete", "no issues found", "clean"
- Raises `RalphParseError` if format unexpected (prevents false negatives)
- Raises `RalphExecutionError` if ralph-loop failed during execution

**Robust error handling ensures quality gates are never silently skipped.**

### Task Tools (Claude Code Built-in)

**TaskCreate:** Initialize all 66 tasks at start
```python
for task in all_tasks:
    TaskCreate(
        taskId=task.id,
        subject=task.description,
        description=task.acceptance_criteria,
        activeForm=f"Executing {task.description}"
    )
```

**TaskUpdate:** Sub-agents report completion
```python
TaskUpdate(taskId="2.5", status="completed")
```

**TaskList:** Orchestrator monitors progress
```python
task_list = TaskList()
completed = [t for t in task_list if t.status == "completed"]
in_progress = [t for t in task_list if t.status == "in_progress"]
```

### Git Operations

**Per-task commit:**
```bash
git add link_triage/extractor.py tests/test_extractor.py
git commit -m "$(cat <<'EOF'
feat(task-2.5): implement Jina Reader client

- GET https://r.jina.ai/{url} with API key
- 10s timeout enforced
- Returns extracted text

Acceptance criteria met: ✓
Task ID: 2.5
Phase: 2 (Core Pipeline Components)
Tests: tests/test_extractor.py

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
EOF
)"
```

**Phase completion commit:**
```bash
git commit --allow-empty -m "chore(phase-2): complete Phase 2 - Core Pipeline Components

Tasks completed: 14
Commits: 14
Ralph-loop cycles: 1"
```

---

## Design Decisions

### D1: Centralized Orchestration vs Distributed Agents

**Decision:** Centralized orchestration (main agent coordinates sub-agents)

**Rationale:**
- LangGraph benchmarks: Centralized 2.2x faster than distributed (CrewAI)
- Simpler to reason about (single source of truth)
- Easier to debug (one coordinator, clear state)
- Matches our scale (66 tasks, not 1000s)

**Alternative considered:** Peer-to-peer agent handoff (more complex, no benefit at our scale)

### D2: DAG Resolution - Simple vs Topological Sort

**Decision:** Simple "are dependencies done?" check (not full topological sort)

**Rationale:**
- Tasks.md dependencies are simple (A depends on B, no complex graphs)
- No need for Kahn's algorithm or similar
- 50 lines vs 200 lines (YAGNI)
- Can add topological sort later if needed

**Alternative considered:** Full DAG library (nx.topological_sort) - overkill for MVP

### D3: Task Grouping - Sequential IDs vs Manual Hints

**Decision:** Sequential ID heuristic (2.1-2.4 = one group)

**Rationale:**
- Tasks.md already uses sequential IDs for related tasks
- No extra annotation needed in tasks.md
- Simple to implement (~100 lines)
- Can override with manual hints later if needed

**Alternative considered:** Add "group: A" column to tasks.md - more explicit, more overhead

### D4: Parallelization - Max 3-5 Groups

**Decision:** Max 5 parallel task executor groups

**Rationale:**
- LangGraph/research: Diminishing returns beyond 5
- Context window limits (5 sub-agents = manageable)
- Most phases have 3-4 natural independent groups
- Balance speed (50% reduction) vs overhead

**Alternative considered:** Max 10 parallel - context overflow risk

### D5: Checkpointing - Phase-Level vs Task-Level

**Decision:** Phase-level checkpointing (5 checkpoints for 66 tasks)

**Rationale:**
- Low overhead (5 state writes vs 66)
- Acceptable lost work on failure (max one phase)
- Temporal.io pattern: Checkpoint at logical boundaries
- Can add task-level later if needed

**Alternative considered:** Task-level checkpointing - 13x more overhead for marginal benefit

### D6: Error Recovery - 1 Retry vs Exponential Backoff

**Decision:** 1 retry (2 attempts total), then surface blocker

**Rationale:**
- Test failures might be flaky (retry worth it)
- Infrastructure failures won't resolve quickly (don't waste time)
- Simple logic, easy to reason about
- Can add exponential backoff later if needed

**Alternative considered:** Exponential backoff (2, 4, 8 seconds) - more complex, marginal benefit

### D7: Ralph Loop - Per Phase vs Per Task

**Decision:** Ralph-loop at phase boundaries only (5 invocations)

**Rationale:**
- Phase = logical unit of work (foundation, core pipeline, etc.)
- Per-task ralph = 66 invocations (too expensive, too slow)
- Batch review catches more cross-task issues
- Aligns with ACM phase review model

**Alternative considered:** Per-task ralph - 13x more expensive, diminishing returns

### D8: Commit Granularity - Per Task vs Per Phase

**Decision:** Atomic commit per task (66 commits for 66 tasks)

**Rationale:**
- Zero friction when automated
- Maximum traceability for git bisect, revert
- Commit = task completion proof
- User requested this approach

**Alternative considered:** Per-phase commits (5 total) - cleaner git log, less traceability

---

## Risk Assessment

### High Risks (All Mitigated)

**R1: Task grouping fails with non-sequential IDs** ✅ **RESOLVED**
- **Fix:** Replaced sequential ID check with phase-based grouping
- **Implementation:** `group_tasks()` now groups by phase number, handles gaps and fix tasks
- **Impact:** Parallelization now works correctly even with task numbering gaps

**R2: Invalid dependencies cause infinite loop** ✅ **RESOLVED**
- **Fix:** Added upfront dependency validation + runtime stuck detection
- **Implementation:** `validate_dependencies()` checks for missing/circular deps, `execute_phase_with_stuck_detection()` surfaces stuck state after 10 iterations
- **Impact:** Errors surface within 50 seconds instead of hanging forever

**R3: Ralph-loop output parsing causes false negatives** ✅ **RESOLVED**
- **Fix:** Added robust error detection and format validation
- **Implementation:** `parse_ralph_output()` now detects execution errors, validates format, requires explicit success indicators
- **Impact:** Quality gates no longer skipped on unexpected output

**R4: Task executor hallucinates tests**
- **Mitigation:** Provide clear test examples in executor context, validate test file exists before marking done
- **Fallback:** Ralph-loop catches missing/bad tests at phase boundary

**R5: Ralph-loop generates infinite fix cycles**
- **Mitigation:** Max 3 ralph cycles per phase, after 3 → surface to user even if High issues remain
- **Fallback:** User can override with `/skip-review` flag

**R6: Parallelization causes file conflicts**
- **Mitigation:** Phase-based grouping naturally separates by phase, reducing conflict likelihood
- **Fallback:** Git merge conflict → surfaces as blocker, orchestrator stops
- **Note:** Can add file conflict detection in post-MVP if needed

### Medium Risks

**R4: Phase validator false positives**
- **Mitigation:** Unambiguous exit criteria in plan.md, validator logs exact commands/outputs
- **Fallback:** User can review validator report, override if disagreement

**R5: Context overflow with 5 parallel agents**
- **Mitigation:** Use Sonnet for task executors (cheaper, faster), monitor token usage
- **Fallback:** Reduce max parallel to 3 if overflow occurs

**R6: State corruption in checkpoint file**
- **Mitigation:** JSON validation on write/read, include timestamp + run_id
- **Fallback:** Resume from previous phase checkpoint

### Low Risks

**R7: Dependency resolution misses edge case**
- **Mitigation:** Simple "deps done" check is robust for acyclic graphs
- **Fallback:** Task never becomes "ready", surfaces as stuck after timeout

**R8: Git commit fails (permissions, disk full)**
- **Mitigation:** Auto-retry once, catch error and surface with context
- **Fallback:** User fixes underlying issue, resumes execution

---

## Success Criteria

### MVP (Iteration 1-2)

- ✅ Execute Phase 1 (13 tasks) sequentially with atomic commits
- ✅ Ralph-loop at Phase 1 boundary, handle High issues (create fix tasks)
- ✅ Phase validator checks exit criteria programmatically
- ✅ Update tasks.md + status.md with progress
- ✅ Run log captures orchestrator decisions
- ✅ Surface blockers with context (don't silently fail)

**Validation:** Run on link-triage-pipeline Phase 1, produces 13+ commits, passes ralph-loop.

### Full Feature (Iteration 3-7)

- ✅ Execute all 5 phases (66 tasks) with 3-5 parallel task groups
- ✅ TDD enforced (tests written first, committed with code)
- ✅ Phase-level checkpointing (resume from any phase)
- ✅ Traceability (git log, run log, session log)
- ✅ Completes in ~8 hours (vs ~16 hours sequential)

**Validation:** Run on link-triage-pipeline full plan, produces ~66 commits, all tests pass, ready for Develop internal review.

---

## Open Questions for Review

1. ~~**Ralph-loop output format:**~~ **RESOLVED** - Added robust parsing with error detection for unexpected formats, explicit success indicators, and error handling.

2. **Task grouping edge cases:** ~~What if all Phase 2 tasks (2.1-2.14) become ready simultaneously?~~ **RESOLVED** - Phase-based grouping groups all Phase 2 tasks together, then splits into chunks of 4: ceil(14/4) = 4 groups.

3. **Fix task numbering:** Should fix tasks be 1.14, 1.15 (incremental) or 1.F1, 1.F2 (prefixed)? **RECOMMENDATION:** Use F-prefix (1.F1, 1.F2) to avoid collision with planned tasks, handled by `extract_task_number()` function.

4. **Phase exit criteria format:** Should plan.md use structured YAML for criteria, or is natural language + heuristic parser sufficient for MVP?

5. **Checkpoint granularity:** Is phase-level (5 checkpoints) sufficient, or should we add task-level (66 checkpoints) for better resume granularity?

6. **Error retry threshold:** Is 1 retry (2 attempts) enough for test failures, or should we do 2 retries (3 attempts)?

7. **Max parallel:** Should we cap at 3 groups (conservative) or 5 groups (faster but more context)?

8. **Ralph cycle limit:** Is 3 ralph cycles per phase enough, or should we allow more (risk: infinite loop)?

---

## Implementation Phases

### Phase 1: Core Orchestrator (Week 1)
- Parse plan.md + tasks.md
- Create TaskList
- Sequential task execution (no parallelization yet)
- Atomic commits per task
- Basic error handling

**Exit:** Can execute Phase 1 of link-triage-pipeline sequentially.

### Phase 2: Ralph Loop Integration (Week 2)
- Invoke ralph-loop at phase boundary
- Parse output for severity
- Create fix tasks for High issues
- Re-review after fixes

**Exit:** Phase 1 with ralph-loop quality gate working.

### Phase 3: Phase Validator (Week 3)
- Parse exit criteria from plan.md
- Run validation checks
- Generate pass/fail report

**Exit:** Phase 1 exit criteria validated programmatically.

### Phase 4: Parallelization (Week 4)
- Dependency graph analyzer
- Task grouping (sequential IDs)
- Parallel Task spawns (3-5 groups)

**Exit:** Phase 2 runs with 3 parallel groups.

### Phase 5: TDD Enforcement (Week 5)
- Task executor writes tests first
- Red → green cycle validation

**Exit:** Task 2.5 produces test + code commits.

### Phase 6: Traceability (Week 6)
- Run log format + writer
- Session log entries
- Troubleshooting validation

**Exit:** Agent can diagnose issues from logs.

### Phase 7: Polish (Week 7)
- CLI options (--start-phase, --dry-run)
- /pause-execution, /resume-execution
- Documentation

**Exit:** Production-ready skill.

---

## End of Design Document
