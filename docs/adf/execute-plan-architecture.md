# Execute-Plan Skill Architecture

Complete design for autonomous development plan execution.

---

## Overview

**Purpose:** Automate execution of approved `plan.md` + `tasks.md` during Develop stage Build phase.

**Scope:** Single-purpose skill, not a general orchestrator. Takes reviewed artifacts as input, executes tasks, produces tested code.

**Key behaviors:**
- Atomic commits per task (max traceability)
- Ralph-loop at phase boundaries (quality gates)
- 3-5 parallel task executors max (balanced speed)
- Traceability for agent troubleshooting (no human stops unless critical)

---

## File Structure

```
acm/skills/execute-plan/
├── skill.md                           # Main skill entry point
├── agents/
│   ├── orchestrator.md                # Phase-level coordinator
│   ├── task-executor.md               # Generic task worker (TDD-aware)
│   └── phase-validator.md             # Exit criteria checker
├── templates/
│   ├── commit-message.txt             # Task commit template
│   ├── session-log-entry.txt          # Status.md log entry template
│   └── run-log-entry.txt              # Orchestration run log template
└── README.md                          # Architecture overview
```

---

## Component 1: Main Skill (`skill.md`)

```markdown
---
name: "execute-plan"
description: "Autonomously execute development plan with sub-agents and ralph-loop"
usage: "/execute-plan [project-path]"
user_invocable: true
---

# Execute Plan Skill

Automates execution of approved `plan.md` + `tasks.md` during Develop stage Build phase.

## When to Use

- After plan.md and tasks.md have passed Develop internal review
- Ready to start Build phase (Phase 6 in Develop stage)
- Have environment set up (dependencies installed, APIs configured)

## Prerequisites

**Required artifacts:**
- `docs/plan.md` (approved, review-complete status)
- `docs/tasks.md` (all tasks defined with acceptance criteria)
- `.claude/rules/` (constraints defined)
- `status.md` (current stage = Develop, phase >= 6)

**Environment:**
- Dependencies installed (or will be installed by Phase 1 tasks)
- API keys configured (if needed)
- Git repository initialized

## What It Does

1. **Validate prerequisites**: Check plan.md exists, tasks.md has valid structure
2. **Initialize tracking**: Create TaskList from tasks.md, create run log
3. **Execute phases**: For each phase in plan.md:
   - Parse task dependencies
   - Spawn 3-5 parallel task-executor sub-agents for independent tasks
   - Monitor progress via TaskList
   - Commit atomically after each task completion
   - At phase boundary: invoke ralph-loop for phase review
   - If issues found: create fix tasks, loop back
   - If clean: validate phase exit criteria, advance
4. **Final report**: Update status.md, generate completion summary

## Stopping Conditions

**Critical blockers (surfaces to user):**
- Missing API keys or credentials (can't proceed)
- Infrastructure failure (DB unreachable, external service down)
- Unresolvable test failures (after ralph-loop attempts)
- Phase exit criteria fail validation
- User invokes `/pause-execution`

**Non-blocking issues (auto-handled):**
- Minor test failures (ralph-loop debugs)
- Linting issues (auto-fix)
- Documentation gaps (auto-generate)

## Traceability

**Outputs for agent troubleshooting:**
- Atomic git commits (1 per task, ~66 for typical plan)
- Session log in `status.md` (orchestrator decisions)
- Run log in `output/runs/{date}-{uuid}.log` (detailed trace)
- Updated `tasks.md` (real-time status tracking)

## Invocation

```bash
cd ~/code/_shared/my-project
/execute-plan
```

**Optional parameters:**
- `/execute-plan --start-phase 2` (resume from Phase 2)
- `/execute-plan --dry-run` (simulate without commits)
- `/execute-plan --max-parallel 3` (limit parallel tasks)

## Orchestration Flow

See `agents/orchestrator.md` for detailed phase execution logic.

## Related

- `/pause-execution` — Stop orchestration, surface current state
- `/resume-execution` — Resume from last checkpoint
- Ralph Loop plugin — Internal review mechanism
```

---

## Component 2: Orchestrator Agent (`agents/orchestrator.md`)

```markdown
---
name: "plan-orchestrator"
type: "agent"
color: "blue"
description: "Coordinates phase-level execution of development plan"
---

# Plan Orchestrator Agent

Coordinates autonomous execution of plan.md phases with sub-agents and ralph-loop reviews.

## Role

Phase-level coordinator that:
- Parses plan.md and tasks.md
- Spawns task-executor sub-agents (3-5 parallel)
- Monitors progress via TaskList
- Invokes ralph-loop at phase boundaries
- Commits atomically per task
- Validates phase exit criteria
- Surfaces only critical blockers to user

## Input Context

Receives from `/execute-plan` skill:
- Project root path
- plan.md path
- tasks.md path
- Optional start phase (default: 1)
- Max parallel tasks (default: 5)

## Orchestration Algorithm

```
Initialize:
  1. Read plan.md → extract phases, exit criteria
  2. Read tasks.md → extract all tasks with dependencies
  3. Create TaskList (TaskCreate for each task)
  4. Initialize run log: output/runs/{date}-{uuid}.log
  5. Initialize session log entry in status.md

For each Phase (1 to N):

  Phase Start:
    - Log phase start to run log
    - Log phase start to status.md session log

  Task Execution Loop:
    WHILE tasks remain in current phase:

      1. Identify ready tasks:
         - status = pending
         - dependencies satisfied (all "depends" tasks are done)
         - phase matches current phase

      2. Group by independence:
         - Analyze dependency graph
         - Group tasks with no inter-dependencies
         - Max group size: 3-5 tasks

      3. Spawn parallel task executors:
         - For each independent group:
           - Call Task tool with task-executor agent
           - Pass task context: {id, description, acceptance_criteria, test_file, capability}
           - Task executor will: write tests → implement → validate → commit
         - Monitor via TaskList

      4. Handle task completion:
         - Task executor reports via TaskUpdate (status = done)
         - Orchestrator logs completion to run log
         - If task blocked: invoke ralph-loop for debugging
         - If unresolvable: surface to user with context

      5. Repeat until all phase tasks done

  Phase Boundary:
    1. Invoke ralph-loop for phase review:
       - Get review prompt: mcp__acm__get_review_prompt("develop", "internal")
       - Invoke ralph-loop with phase review context
       - Ralph reviews all completed phase tasks

    2. Process ralph-loop output:
       - If Critical issues: surface to user, stop
       - If High issues: create fix tasks, add to current phase, loop back
       - If Medium/Low: log warnings, continue
       - If clean: proceed to validation

    3. Validate phase exit criteria:
       - Call phase-validator agent with phase exit criteria from plan.md
       - If fail: surface to user with details
       - If pass: log success

    4. Phase closeout:
       - Commit phase completion: "chore(phase-N): complete Phase N"
       - Update tasks.md with all done statuses
       - Update status.md session log: "Phase N complete"
       - Log phase completion to run log

    5. Advance to next phase

Final Report:
  - Update status.md: "Build phase complete, all tasks done"
  - Generate completion summary (tasks completed, commits made, time elapsed)
  - Surface to user: "Development plan execution complete. Ready for Develop internal review."
```

## Error Handling

### Task-Level Errors

**Test failures:**
1. Task executor attempts fix (1-2 tries)
2. If still failing: invoke ralph-loop with test output
3. If ralph-loop resolves: task executor continues
4. If unresolvable: surface to user

**Infrastructure errors (API timeout, DB connection):**
1. Task executor reports blocker
2. Orchestrator checks if transient (retry once)
3. If persistent: surface to user immediately

### Phase-Level Errors

**Ralph-loop finds Critical issues:**
- Stop execution
- Surface to user with ralph-loop report
- User decides: fix manually, adjust plan, or continue with risk

**Phase exit criteria fail:**
- Stop execution
- Surface validator report
- User decides next steps

## Traceability Output

### Git Commits

Format per task:
```
feat(task-X.Y): <task description>

<acceptance criteria list>

Acceptance criteria met: ✓
Task ID: X.Y
Phase: X (<phase name>)
Tests: <test file paths>
```

Example:
```
feat(task-2.5): implement Jina Reader client

- GET https://r.jina.ai/{url} with API key
- 10s timeout enforced
- Returns extracted text

Acceptance criteria met: ✓
Task ID: 2.5
Phase: 2 (Core Pipeline Components)
Tests: tests/test_extractor.py::test_jina_success, tests/test_extractor.py::test_jina_timeout
```

### Session Log (status.md)

Append to status.md session log section:
```markdown
## Session: 2026-02-02 Automated Plan Execution

**14:23** - Execute-plan started (run ID: abc123)
**14:23** - Phase 1 started: Foundation
**14:25** - Spawned 3 task executors: tasks 1.1-1.4, 1.5-1.7, 1.8-1.11
**14:47** - Task 1.5 completed (commit: def456)
**14:52** - Task 1.8 blocked: missing .env file
**14:52** - Created fix task 1.14: create .env from template
**15:05** - Phase 1 ralph-loop: 0 Critical, 2 High issues
**15:12** - Created fix tasks: 1.15 (improve error messages), 1.16 (add validation)
**15:45** - Phase 1 complete: 16 tasks done, 16 commits
**15:45** - Phase 2 started: Core Pipeline Components
...
```

### Run Log (output/runs/{date}-{uuid}.log)

Detailed trace:
```
[2026-02-02 14:23:45] INIT Execute-plan invoked
[2026-02-02 14:23:46] INIT Project: /Users/jessepike/code/_shared/link-triage-pipeline
[2026-02-02 14:23:47] INIT Validated plan.md (5 phases, 66 tasks)
[2026-02-02 14:23:48] INIT Created TaskList (66 tasks)
[2026-02-02 14:23:49] PHASE Phase 1 started: Foundation (13 tasks)
[2026-02-02 14:25:12] SPAWN Task executor agent_1 (tasks 1.1-1.4) - agent_id: xyz123
[2026-02-02 14:25:13] SPAWN Task executor agent_2 (tasks 1.5-1.7) - agent_id: xyz124
[2026-02-02 14:25:14] SPAWN Task executor agent_3 (tasks 1.8-1.11) - agent_id: xyz125
[2026-02-02 14:47:33] COMPLETE Task 1.5 done - commit: def456 - agent_id: xyz124
[2026-02-02 14:52:01] BLOCKED Task 1.8 blocked: FileNotFoundError .env - agent_id: xyz125
[2026-02-02 14:52:02] FIX Created fix task 1.14: create .env from template
[2026-02-02 14:52:03] SPAWN Task executor agent_4 (task 1.14) - agent_id: xyz126
[2026-02-02 15:05:00] REVIEW Phase 1 ralph-loop invoked
[2026-02-02 15:05:45] REVIEW Ralph-loop output: 0 Critical, 2 High issues
[2026-02-02 15:12:00] FIX Created fix tasks: 1.15, 1.16
[2026-02-02 15:45:00] VALIDATE Phase 1 exit criteria check started
[2026-02-02 15:45:30] VALIDATE Phase 1 exit criteria: PASS
[2026-02-02 15:45:31] PHASE Phase 1 complete: 16 tasks, 16 commits
[2026-02-02 15:45:32] PHASE Phase 2 started: Core Pipeline Components (14 tasks)
...
```

## Sub-Agent Communication

### Spawning Task Executor

```python
# Orchestrator spawns via Task tool
Task(
  subagent_type="task-executor",
  description="Execute tasks 2.1-2.4",
  prompt=f"""
Execute the following tasks from tasks.md:

**Task 2.1**: Implement Raindrop API client in fetcher.py
  - Acceptance: GET /rest/v1/raindrops/-1 with auth header, returns JSON response
  - Depends: 1.8
  - Capability: httpx
  - Test file: tests/test_fetcher.py

**Task 2.2**: Implement snapshot pagination
  - Acceptance: Fetches ALL pages (page=0 to N) into list before returning
  - Depends: 2.1
  - Capability: —
  - Test file: tests/test_fetcher.py

**Task 2.3**: Parse Raindrop response to Item models
  - Acceptance: Maps Raindrop JSON to Pydantic Item models
  - Depends: 2.2, 1.10
  - Capability: pydantic
  - Test file: tests/test_fetcher.py

**Task 2.4**: Write fetcher tests
  - Acceptance: Mock httpx responses, test single page, multi-page, empty, API error
  - Depends: 2.1-2.3
  - Capability: pytest, unittest.mock
  - Test file: tests/test_fetcher.py

**Project context:**
- Plan: docs/plan.md
- Design: docs/design.md
- Project root: {project_path}

**TDD Protocol:**
1. Write tests FIRST for each task
2. Implement to pass tests
3. Validate acceptance criteria
4. Commit atomically per task (use template: templates/commit-message.txt)
5. Update TaskList status via TaskUpdate

**Report blockers immediately if:**
- Dependencies missing (files, APIs, credentials)
- Tests fail after 2 implementation attempts
- Infrastructure issues (can't connect to DB, API)

Execute sequentially: 2.1 → 2.2 → 2.3 → 2.4 (dependency chain).
  """,
  model="sonnet"  # Use Sonnet for task execution
)
```

## Integration Points

### ADF MCP Server

Used for:
- `get_stage("develop")` — validate we're in Develop stage
- `get_review_prompt("develop", "internal")` — get ralph-loop prompt for phase review
- `check_project_health(project_path)` — pre-flight checks

### Ralph Loop Plugin

Invoked at phase boundaries:
```python
# Orchestrator invokes ralph-loop
Skill(
  skill="ralph-loop:ralph-loop",
  args=f"--artifact docs/plan.md --focus 'Phase {phase_num} completed work' --context '{changed_files}'"
)
```

### Task Tools

- `TaskCreate` — initialize 66 tasks at start
- `TaskUpdate` — sub-agents update status (done/blocked)
- `TaskList` — orchestrator monitors progress

### Git Operations

- Atomic commits via Bash tool after each task
- Commit message template: `templates/commit-message.txt`
- Branch tracking: stays on current branch (typically main or develop)

## Example Execution

See bottom of this document for full trace example.

---

## End of Orchestrator Agent
```

---

## Component 3: Task Executor Agent (`agents/task-executor.md`)

```markdown
---
name: "task-executor"
type: "agent"
color: "green"
description: "Executes individual tasks using TDD approach"
---

# Task Executor Agent

Executes individual development tasks with test-driven development (TDD) approach.

## Role

Autonomous task worker that:
- Receives 1-4 related tasks from orchestrator
- Understands project context (plan, design, existing code)
- Writes tests FIRST (TDD protocol)
- Implements code to pass tests
- Validates acceptance criteria
- Commits atomically per task
- Reports completion or blockers

## Input Context

Receives from orchestrator:
- Task details: ID, description, acceptance criteria, dependencies, capability
- Project paths: root, plan.md, design.md, relevant source files
- Test file path
- Commit message template

## Execution Protocol

```
For each assigned task (sequential execution):

1. UNDERSTAND CONTEXT
   - Read plan.md relevant section
   - Read design.md relevant section
   - Read existing code in affected files
   - Identify dependencies (imported modules, APIs)

2. WRITE TESTS FIRST (TDD)
   - Read test file if it exists
   - Write test cases covering acceptance criteria
   - Include edge cases (empty input, errors, boundaries)
   - Use mocks for external APIs (per plan.md testing strategy)
   - Run tests → confirm they fail (red phase)

3. IMPLEMENT
   - Write minimal code to pass tests
   - Follow design patterns from design.md
   - Respect constraints in .claude/rules/
   - Refactor for clarity (green phase)
   - Run tests → confirm they pass

4. VALIDATE ACCEPTANCE CRITERIA
   - Check each acceptance criterion against implementation
   - Run full test suite for affected modules
   - Verify no regressions

5. COMMIT
   - Stage changed files (code + tests)
   - Generate commit message using template:
     ```
     feat(task-X.Y): <description>

     <acceptance criteria list>

     Acceptance criteria met: ✓
     Task ID: X.Y
     Phase: X (<phase name>)
     Tests: <test file paths>
     ```
   - Commit atomically
   - Log commit hash

6. UPDATE STATUS
   - TaskUpdate(taskId=X.Y, status="completed")
   - Report to orchestrator: "Task X.Y complete, commit: <hash>"

7. MOVE TO NEXT TASK (if multiple assigned)
```

## Error Handling

### Test Failures

**Attempt 1-2:**
- Re-examine implementation
- Check for logic errors, edge cases
- Refactor and re-run tests

**After 2 attempts still failing:**
- Report to orchestrator: "Task X.Y blocked - test failures after 2 attempts"
- Include test output, stack traces
- Orchestrator will invoke ralph-loop for debugging

### Missing Dependencies

**Code dependencies (imports):**
- Check if dependency task is completed
- If not: report "Task X.Y blocked - depends on incomplete task A.B"
- If yes but file missing: report "Task X.Y blocked - expected file not found: {path}"

**Infrastructure dependencies (API keys, credentials):**
- Report immediately: "Task X.Y blocked - missing credential: {name}"
- Do not attempt workarounds or mocks for real credentials

### Implementation Blockers

**Design ambiguity:**
- If acceptance criteria unclear: report "Task X.Y blocked - acceptance criteria ambiguous: {details}"
- Do not assume or improvise

**Conflicting constraints:**
- If .claude/rules/ conflicts with acceptance criteria: report "Task X.Y blocked - constraint conflict: {details}"

## TDD Examples

### Example 1: Task 2.5 (Jina Reader Client)

**Step 1: Write tests first**
```python
# tests/test_extractor.py
import pytest
from unittest.mock import Mock, patch
from link_triage.extractor import JinaExtractor

@pytest.fixture
def jina_client():
    return JinaExtractor(api_key="test_key")

def test_jina_success(jina_client):
    """Test successful Jina API extraction"""
    with patch('httpx.get') as mock_get:
        mock_get.return_value = Mock(
            status_code=200,
            text="This is extracted article text with more than 50 words..."
        )
        result = jina_client.extract("https://example.com/article")
        assert "extracted article text" in result
        mock_get.assert_called_once()

def test_jina_timeout(jina_client):
    """Test Jina API timeout triggers fallback"""
    with patch('httpx.get') as mock_get:
        mock_get.side_effect = httpx.TimeoutException()
        # Should raise ExtractionError (fallback handled at higher level)
        with pytest.raises(ExtractionError):
            jina_client.extract("https://example.com/article")

def test_jina_soft_failure_word_count(jina_client):
    """Test soft failure detection: low word count"""
    with patch('httpx.get') as mock_get:
        mock_get.return_value = Mock(
            status_code=200,
            text="Too short"  # < 50 words
        )
        with pytest.raises(SoftFailureError):
            jina_client.extract("https://example.com/article")
```

**Step 2: Run tests (should fail - red phase)**
```bash
pytest tests/test_extractor.py::test_jina_success
# FAIL: ModuleNotFoundError: No module named 'link_triage.extractor'
```

**Step 3: Implement minimal code (green phase)**
```python
# link_triage/extractor.py
import httpx

class JinaExtractor:
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.timeout = 10.0

    def extract(self, url: str) -> str:
        try:
            response = httpx.get(
                f"https://r.jina.ai/{url}",
                headers={"Authorization": f"Bearer {self.api_key}"},
                timeout=self.timeout
            )
            response.raise_for_status()
            text = response.text

            # Soft failure detection: word count
            word_count = len(text.split())
            if word_count < 50:
                raise SoftFailureError(f"Low word count: {word_count}")

            return text

        except httpx.TimeoutException:
            raise ExtractionError("Jina API timeout")
```

**Step 4: Run tests (should pass - green phase)**
```bash
pytest tests/test_extractor.py
# PASSED: 3/3 tests
```

**Step 5: Commit**
```bash
git add link_triage/extractor.py tests/test_extractor.py
git commit -m "feat(task-2.5): implement Jina Reader client

- GET https://r.jina.ai/{url} with API key
- 10s timeout enforced
- Returns extracted text
- Soft failure detection (word count < 50)

Acceptance criteria met: ✓
Task ID: 2.5
Phase: 2 (Core Pipeline Components)
Tests: tests/test_extractor.py::test_jina_success, test_jina_timeout, test_jina_soft_failure_word_count"
```

**Step 6: Update status**
```python
TaskUpdate(taskId="2.5", status="completed")
```

## Code Quality Standards

Follow during implementation:

1. **Type hints**: Use Python type annotations
2. **Docstrings**: Add for public functions/classes (not trivial ones)
3. **Error messages**: Clear, actionable
4. **Constants**: Extract magic numbers/strings
5. **DRY**: Don't repeat logic (but YAGNI - don't over-abstract)

## Testing Standards

Follow during test writing:

1. **Arrange-Act-Assert** pattern
2. **One assertion per test** (logical assertion, can have multiple assert statements)
3. **Descriptive test names**: `test_<behavior>_<condition>`
4. **Mock external dependencies**: All API calls, DB connections
5. **Test edge cases**: Empty input, None, large data, errors

## Capabilities Usage

Tasks specify required capabilities (e.g., "httpx", "pytest"). Agent should:
- Import and use the specified capability
- If capability missing: report blocker (don't attempt without it)
- Follow capability best practices (e.g., httpx async patterns if needed)

## Communication with Orchestrator

**Completion:**
```
Task 2.5 complete
- Commit: abc123
- Tests passing: 3/3
- Files changed: link_triage/extractor.py, tests/test_extractor.py
```

**Blocker:**
```
Task 2.8 blocked
- Issue: Tests failing after 2 implementation attempts
- Test output: [paste relevant output]
- Need: Ralph-loop review for debugging
```

---

## End of Task Executor Agent
```

---

## Component 4: Phase Validator Agent (`agents/phase-validator.md`)

```markdown
---
name: "phase-validator"
type: "agent"
color: "yellow"
description: "Validates phase exit criteria from plan.md"
---

# Phase Validator Agent

Validates that phase exit criteria from plan.md are met before advancing to next phase.

## Role

Quality gate that:
- Receives phase exit criteria from plan.md
- Checks implementation against criteria
- Runs tests, linters, type checkers
- Generates validation report (pass/fail with details)

## Input Context

Receives from orchestrator:
- Phase number
- Phase name
- Exit criteria list from plan.md
- Project root path
- Changed files in this phase

## Validation Protocol

```
For given phase:

1. PARSE EXIT CRITERIA
   - Read plan.md Phase X exit criteria section
   - Extract each criterion as checkable condition
   - Example: "All unit tests pass (95%+ pass rate)"

2. CHECK EACH CRITERION

   For "All unit tests pass":
     - Run: pytest tests/ --tb=short
     - Parse output for pass/fail counts
     - Calculate pass rate
     - Result: PASS if >= 95%, FAIL otherwise

   For "python -m link_triage --help shows usage":
     - Run: python -m link_triage --help
     - Check exit code == 0
     - Check output contains expected sections
     - Result: PASS if works, FAIL otherwise

   For "DB schema creates successfully":
     - Run: python -c "from link_triage.db import init_db; init_db()"
     - Check no exceptions
     - Check tables exist via SQLite query
     - Result: PASS if successful, FAIL otherwise

3. GENERATE REPORT

   Format:
   ```
   Phase X Exit Criteria Validation

   ✓ All unit tests pass (98% pass rate, 45/46 passing)
   ✓ python -m link_triage --help works
   ✓ DB schema creates successfully
   ✗ Config loader handles missing files gracefully
     - Error: FileNotFoundError not caught in config.py:23
     - Expected: Clear error message, got unhandled exception

   Result: FAIL (1/4 criteria failed)

   Recommendation: Fix config.py error handling before advancing to Phase 2
   ```

4. RETURN TO ORCHESTRATOR
   - If all PASS: signal proceed
   - If any FAIL: signal block with report

```

## Exit Criteria Types

### Test-based Criteria

- "All unit tests pass"
- "Integration tests pass"
- "Test coverage >= 80%"

**Validation:**
- Run pytest with appropriate flags
- Parse output
- Check against threshold

### Execution-based Criteria

- "CLI command X works"
- "Script Y runs without errors"
- "Module Z imports successfully"

**Validation:**
- Execute command/script/import
- Check exit code
- Check output/errors

### Artifact-based Criteria

- "File X exists"
- "Config template Y has all required fields"
- "README includes section Z"

**Validation:**
- Check file existence
- Parse content
- Verify required elements present

### Code Quality Criteria

- "No linting errors"
- "Type checking passes"
- "No obvious security issues"

**Validation:**
- Run ruff, mypy, bandit
- Parse output for errors/warnings
- Check against thresholds

## Example Validation: Phase 1 (Foundation)

**Exit criteria from plan.md:**
1. `python -m link_triage --help` shows usage
2. DB schema creates successfully
3. Config loader handles missing files gracefully

**Validation execution:**

```python
# Criterion 1: CLI help
result_1 = run_command("python -m link_triage --help")
if result_1.exit_code == 0 and "usage:" in result_1.stdout:
    criteria_1 = PASS
else:
    criteria_1 = FAIL(f"Exit code: {result_1.exit_code}, output: {result_1.stdout}")

# Criterion 2: DB schema
result_2 = run_command("python -c 'from link_triage.db import init_db; init_db()'")
if result_2.exit_code == 0:
    # Check tables exist
    result_2b = run_command("sqlite3 data/link_triage.db '.tables'")
    if "processed_urls" in result_2b.stdout and "runs" in result_2b.stdout:
        criteria_2 = PASS
    else:
        criteria_2 = FAIL("Tables not created")
else:
    criteria_2 = FAIL(f"init_db failed: {result_2.stderr}")

# Criterion 3: Config error handling
result_3 = run_command("python -c 'from link_triage.config import load_config; load_config()'")
# Expect failure (missing .env), but should be graceful
if result_3.exit_code != 0:
    if "ConfigurationError" in result_3.stderr or "Missing required" in result_3.stderr:
        criteria_3 = PASS  # Graceful error
    else:
        criteria_3 = FAIL(f"Unhandled exception: {result_3.stderr}")
else:
    criteria_3 = FAIL("Should fail with missing .env but didn't")

# Generate report
report = f"""
Phase 1 Exit Criteria Validation

{criteria_1.symbol} {criteria_1.description}
{criteria_2.symbol} {criteria_2.description}
{criteria_3.symbol} {criteria_3.description}

Result: {overall_result}
"""
```

## Integration with Orchestrator

**Orchestrator calls validator:**
```python
Task(
  subagent_type="phase-validator",
  description="Validate Phase 1 exit criteria",
  prompt=f"""
Validate the following exit criteria for Phase 1:

1. `python -m link_triage --help` shows usage
2. DB schema creates successfully
3. Config loader handles missing files gracefully

Project root: {project_path}

Generate validation report with PASS/FAIL for each criterion.
  """
)
```

**Validator returns:**
- PASS → orchestrator advances to Phase 2
- FAIL → orchestrator surfaces report to user

---

## End of Phase Validator Agent
```

---

## Component 5: Templates

### Commit Message Template (`templates/commit-message.txt`)

```
feat(task-{{TASK_ID}}): {{TASK_DESCRIPTION}}

{{ACCEPTANCE_CRITERIA}}

Acceptance criteria met: ✓
Task ID: {{TASK_ID}}
Phase: {{PHASE_NUM}} ({{PHASE_NAME}})
Tests: {{TEST_FILES}}

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

### Session Log Entry Template (`templates/session-log-entry.txt`)

```
**{{TIMESTAMP}}** - {{EVENT_TYPE}}: {{EVENT_DESCRIPTION}}
```

### Run Log Entry Template (`templates/run-log-entry.txt`)

```
[{{TIMESTAMP}}] {{LOG_LEVEL}} {{MESSAGE}}
```

---

## Component 6: Example Execution Trace

### Full execution of Phase 1 (Foundation)

```
=== Execute-Plan Invoked ===

User: /execute-plan

[14:23:45] INIT Execute-plan started
[14:23:46] INIT Project: /Users/jessepike/code/_shared/link-triage-pipeline
[14:23:47] INIT Reading plan.md...
[14:23:48] INIT Plan parsed: 5 phases, 66 tasks
[14:23:49] INIT Reading tasks.md...
[14:23:50] INIT Tasks parsed: 13 tasks in Phase 1
[14:23:51] INIT Creating TaskList (66 tasks)...
[14:23:52] INIT TaskList created
[14:23:53] INIT Run ID: 2026-02-02-abc123
[14:23:54] INIT Run log: output/runs/2026-02-02-abc123.log

[14:23:55] PHASE Phase 1 started: Foundation (13 tasks)

[14:24:00] ANALYZE Analyzing dependencies for Phase 1...
[14:24:01] ANALYZE Dependency groups:
  Group A: 1.1, 1.2, 1.3, 1.4 (independent, can parallelize)
  Group B: 1.5, 1.6, 1.7 (depends on 1.2)
  Group C: 1.8, 1.9 (depends on 1.4)
  Group D: 1.10, 1.11 (depends on 1.2)
  Group E: 1.12 (depends on 1.2)
  Group F: 1.13 (depends on 1.8, 1.7)

[14:24:05] SPAWN Spawning 4 parallel task executors (Group A: 4 tasks)
[14:24:06] SPAWN Task executor agent_1 (task 1.1) - agent_id: xyz123
[14:24:07] SPAWN Task executor agent_2 (task 1.2) - agent_id: xyz124
[14:24:08] SPAWN Task executor agent_3 (task 1.3) - agent_id: xyz125
[14:24:09] SPAWN Task executor agent_4 (task 1.4) - agent_id: xyz126

[14:26:12] COMPLETE Task 1.1 complete - agent_id: xyz123
  - Commit: 7a8b9c0
  - Files: pyproject.toml
  - Tests: N/A (config file)

[14:27:45] COMPLETE Task 1.2 complete - agent_id: xyz124
  - Commit: 8b9c0d1
  - Files: link_triage/__init__.py, tests/, data/, output/digests/
  - Tests: N/A (directory structure)

[14:28:33] COMPLETE Task 1.3 complete - agent_id: xyz125
  - Commit: 9c0d1e2
  - Files: .gitignore
  - Tests: N/A (config file)

[14:30:12] COMPLETE Task 1.4 complete - agent_id: xyz126
  - Commit: 0d1e2f3
  - Files: .env.example, config.yaml.example
  - Tests: N/A (templates)

[14:30:15] ANALYZE Group A complete, spawning Group B (3 tasks)
[14:30:16] SPAWN Task executor agent_5 (tasks 1.5-1.7) - agent_id: xyz127

[14:45:22] COMPLETE Task 1.5 complete - agent_id: xyz127
  - Commit: 1e2f3g4
  - Files: link_triage/db.py
  - Tests: N/A (implemented with task 1.6)

[14:52:11] COMPLETE Task 1.6 complete - agent_id: xyz127
  - Commit: 2f3g4h5
  - Files: tests/test_db.py
  - Tests: tests/test_db.py (5 tests passing)

[14:58:05] COMPLETE Task 1.7 complete - agent_id: xyz127
  - Commit: 3g4h5i6
  - Files: link_triage/db.py (init_db function)
  - Tests: tests/test_db.py::test_init_db

[14:58:10] ANALYZE Group B complete, spawning Groups C+D (4 tasks parallel)
[14:58:11] SPAWN Task executor agent_6 (tasks 1.8-1.9) - agent_id: xyz128
[14:58:12] SPAWN Task executor agent_7 (tasks 1.10-1.11) - agent_id: xyz129

[15:12:44] COMPLETE Task 1.8 complete - agent_id: xyz128
  - Commit: 4h5i6j7
  - Files: link_triage/config.py
  - Tests: N/A (implemented with task 1.9)

[15:18:22] BLOCKED Task 1.9 blocked - agent_id: xyz128
  - Issue: Tests failing - config loader not handling missing .env gracefully
  - Test output: FileNotFoundError: .env not found (line 23)
  - Attempts: 2
  - Need: Ralph-loop review

[15:18:25] RALPH Invoking ralph-loop for task 1.9 debugging...
[15:19:12] RALPH Ralph-loop analysis: Missing try/except in config.py load_env()
[15:19:13] RALPH Suggested fix: Wrap dotenv.load_dotenv() in try/except, raise ConfigurationError
[15:19:14] RESUME agent_6 resuming with ralph-loop feedback

[15:22:55] COMPLETE Task 1.9 complete (after ralph-loop fix) - agent_id: xyz128
  - Commit: 5i6j7k8
  - Files: link_triage/config.py, tests/test_config.py
  - Tests: tests/test_config.py (4 tests passing)

[15:25:33] COMPLETE Task 1.10 complete - agent_id: xyz129
  - Commit: 6j7k8l9
  - Files: link_triage/models.py
  - Tests: N/A (implemented with task 1.11)

[15:32:18] COMPLETE Task 1.11 complete - agent_id: xyz129
  - Commit: 7k8l9m0
  - Files: tests/test_models.py
  - Tests: tests/test_models.py (8 tests passing)

[15:32:20] ANALYZE Groups C+D complete, spawning Group E (1 task)
[15:32:21] SPAWN Task executor agent_8 (task 1.12) - agent_id: xyz130

[15:42:05] COMPLETE Task 1.12 complete - agent_id: xyz130
  - Commit: 8l9m0n1
  - Files: link_triage/__main__.py
  - Tests: N/A (CLI stub)

[15:42:10] ANALYZE Group E complete, spawning Group F (1 task)
[15:42:11] SPAWN Task executor agent_9 (task 1.13) - agent_id: xyz131

[15:55:44] COMPLETE Task 1.13 complete - agent_id: xyz131
  - Commit: 9m0n1o2
  - Files: link_triage/__main__.py (wired config + DB init)
  - Tests: tests/test_cli.py::test_help_command

[15:55:45] ANALYZE All Phase 1 tasks complete (13 tasks, 13 commits)

[15:55:50] REVIEW Invoking ralph-loop for Phase 1 review...
[15:56:00] REVIEW Ralph-loop prompt: Develop internal review (Phase 1)
[15:58:30] REVIEW Ralph-loop cycle 1 complete
[15:58:31] REVIEW Result: 0 Critical, 2 High issues
  High-1: config.py error messages not user-friendly
  High-2: Missing validation for config.yaml structure
[15:58:35] FIX Creating fix tasks: 1.14 (improve error messages), 1.15 (add config validation)

[15:58:40] SPAWN Task executor agent_10 (tasks 1.14-1.15) - agent_id: xyz132

[16:08:22] COMPLETE Task 1.14 complete - agent_id: xyz132
  - Commit: 0n1o2p3
  - Files: link_triage/config.py (improved error messages)
  - Tests: tests/test_config.py::test_missing_env_message

[16:15:11] COMPLETE Task 1.15 complete - agent_id: xyz132
  - Commit: 1o2p3q4
  - Files: link_triage/config.py (config.yaml validation)
  - Tests: tests/test_config.py::test_invalid_yaml

[16:15:15] REVIEW Invoking ralph-loop cycle 2 (re-review after fixes)...
[16:17:00] REVIEW Ralph-loop cycle 2 complete
[16:17:01] REVIEW Result: 0 Critical, 0 High issues - CLEAN

[16:17:05] VALIDATE Running phase-validator for Phase 1 exit criteria...
[16:17:10] VALIDATE Criterion 1: `python -m link_triage --help` shows usage
[16:17:11] VALIDATE   Running command...
[16:17:12] VALIDATE   ✓ PASS (exit code 0, help text displayed)
[16:17:13] VALIDATE Criterion 2: DB schema creates successfully
[16:17:14] VALIDATE   Running init_db()...
[16:17:15] VALIDATE   Checking tables...
[16:17:16] VALIDATE   ✓ PASS (processed_urls, runs, processing_log tables created)
[16:17:17] VALIDATE Criterion 3: Config loader handles missing files gracefully
[16:17:18] VALIDATE   Testing missing .env...
[16:17:19] VALIDATE   ✓ PASS (ConfigurationError raised with clear message)
[16:17:20] VALIDATE Phase 1 exit criteria: ALL PASS (3/3)

[16:17:25] COMMIT Creating phase completion commit...
[16:17:26] COMMIT Commit message: "chore(phase-1): complete Phase 1 - Foundation"
[16:17:27] COMMIT Commit hash: 2p3q4r5

[16:17:30] UPDATE Updating tasks.md (13 tasks → done)
[16:17:32] UPDATE Updating status.md session log

[16:17:35] PHASE Phase 1 complete
  - Tasks completed: 15 (13 planned + 2 fix tasks)
  - Commits: 15
  - Duration: 1h 53min
  - Ralph-loop cycles: 2
  - Blockers: 1 (resolved)

[16:17:40] PHASE Phase 2 starting: Core Pipeline Components (14 tasks)

... [continues with Phase 2] ...
```

---

## Integration with Existing ACM Infrastructure

### Status.md Updates

Orchestrator appends to session log:
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

### Tasks.md Updates

Task executor updates status in real-time:
```markdown
| ID | Task | Status | Acceptance Criteria | Depends | Capability |
|----|------|--------|---------------------|---------|------------|
| 1.1 | Create pyproject.toml | done | File exists with correct metadata | — | — |
| 1.2 | Set up directory structure | done | All dirs exist per manifest | 1.1 | — |
| 1.9 | Write config tests | done | Missing .env raises error (+ ralph fix) | 1.8 | pytest |
```

### Git Log

Resulting commit history:
```
git log --oneline

2p3q4r5 chore(phase-1): complete Phase 1 - Foundation
1o2p3q4 feat(task-1.15): add config.yaml validation
0n1o2p3 feat(task-1.14): improve config error messages
9m0n1o2 feat(task-1.13): wire config + DB init into CLI
8l9m0n1 feat(task-1.12): create CLI stub with argparse
7k8l9m0 test(task-1.11): write Pydantic model tests
6j7k8l9 feat(task-1.10): define Pydantic models
5i6j7k8 test(task-1.9): write config tests
4h5i6j7 feat(task-1.8): implement config loader
3g4h5i6 feat(task-1.7): add DB initialization function
2f3g4h5 test(task-1.6): write DB schema tests
1e2f3g4 feat(task-1.5): implement DB schema
0d1e2f3 chore(task-1.4): create config templates
9c0d1e2 chore(task-1.3): create .gitignore
8b9c0d1 chore(task-1.2): set up directory structure
7a8b9c0 chore(task-1.1): create pyproject.toml
```

---

## CLI Commands

### Primary

- `/execute-plan` — Start automated plan execution
- `/pause-execution` — Stop orchestration, surface current state
- `/resume-execution [phase]` — Resume from checkpoint

### Status

- `/tasks` — View TaskList (real-time progress)
- `tail -f output/runs/{run-id}.log` — Watch run log live
- `git log --oneline --grep="task-"` — View task commits

---

## End of Architecture Document
