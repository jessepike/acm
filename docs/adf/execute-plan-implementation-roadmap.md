# Execute-Plan Implementation Roadmap

## Overview

This document outlines the implementation path for the `/execute-plan` skill, from MVP to full-featured autonomous development orchestration.

---

## Implementation Phases

### **Phase 1: Core Orchestrator** (Week 1)
*Minimal viable orchestration without parallelization*

**Goal:** Single-threaded task execution with basic traceability

**Deliverables:**
1. Main skill file: `acm/skills/execute-plan/skill.md`
2. Orchestrator agent: `acm/skills/execute-plan/agents/orchestrator.md`
3. Basic task executor agent (no TDD yet): `agents/task-executor.md`
4. Commit per task (template)
5. Session log updates (status.md)

**Features:**
- Parse plan.md + tasks.md
- Create TaskList (all 66 tasks)
- Execute tasks sequentially (one at a time)
- Atomic commits per task
- Basic error handling (report blockers to user)
- No ralph-loop integration yet
- No parallelization yet

**Exit Criteria:**
- Can execute Phase 1 (Foundation) of link-triage-pipeline
- All 13 tasks complete with 13 commits
- Tasks.md updated with status
- Session log in status.md reflects progress

**Validation:**
```bash
cd ~/code/_shared/link-triage-pipeline
/execute-plan --start-phase 1 --end-phase 1
# Should produce 13 commits, all Phase 1 tasks done
```

---

### **Phase 2: Ralph Loop Integration** (Week 2)
*Add phase boundary reviews*

**Goal:** Quality gates at phase transitions

**Deliverables:**
1. Ralph-loop invocation logic in orchestrator
2. Issue parser (Critical/High/Medium/Low)
3. Fix task creation workflow
4. Phase review cycle tracking

**Features:**
- At phase boundary: invoke ralph-loop
- Parse ralph output for severity
- If Critical: stop, surface to user
- If High: create fix tasks, loop back
- If clean: proceed to phase validator
- Track ralph cycles (1, 2, 3...)

**Exit Criteria:**
- Can execute Phase 1 with ralph-loop review at end
- If ralph finds High issues: creates fix tasks automatically
- Re-reviews after fixes
- Only advances phase when clean

**Validation:**
```bash
cd ~/code/_shared/link-triage-pipeline
/execute-plan --start-phase 1 --end-phase 1
# Should invoke ralph-loop at Phase 1 boundary
# If issues found: should create fix tasks and re-review
```

---

### **Phase 3: Phase Validator** (Week 3)
*Automated exit criteria checking*

**Goal:** Validate phase exit criteria before advancing

**Deliverables:**
1. Phase validator agent: `agents/phase-validator.md`
2. Exit criteria parsers (test-based, execution-based, artifact-based)
3. Validation report generator

**Features:**
- Parse phase exit criteria from plan.md
- Run tests, commands, checks per criterion
- Generate pass/fail report
- Stop if any criterion fails

**Exit Criteria:**
- Can validate Phase 1 exit criteria programmatically
- Reports which criteria passed/failed
- Only advances if all pass

**Validation:**
```bash
cd ~/code/_shared/link-triage-pipeline
/execute-plan --start-phase 1 --end-phase 1
# Should validate:
# ✓ python -m link_triage --help works
# ✓ DB schema creates
# ✓ Config loader handles missing files
```

---

### **Phase 4: Parallelization** (Week 4)
*Spawn multiple task executors for independent tasks*

**Goal:** Speed up execution with parallel sub-agents

**Deliverables:**
1. Dependency graph analyzer
2. Task grouping logic (independent task detection)
3. Parallel Task tool invocations (3-5 max)
4. Progress monitoring (TaskList polling)

**Features:**
- Analyze dependencies for current phase
- Group independent tasks (no inter-dependencies)
- Spawn 3-5 task executors in parallel
- Monitor via TaskList until all complete
- Handle blockers from any sub-agent

**Exit Criteria:**
- Can execute Phase 2 with 3 parallel groups
- Groups A, B, C run simultaneously
- Group D waits for A-C to complete
- Total time reduced by ~50%

**Validation:**
```bash
cd ~/code/_shared/link-triage-pipeline
/execute-plan --start-phase 2 --end-phase 2 --max-parallel 3
# Should spawn 3 task executors simultaneously
# Should complete Phase 2 in ~2 hours (vs 4 sequential)
```

---

### **Phase 5: TDD Enforcement** (Week 5)
*Task executor writes tests first*

**Goal:** Ensure test-driven development protocol

**Deliverables:**
1. Enhanced task executor with TDD steps
2. Test validation (red → green cycle)
3. Acceptance criteria checker

**Features:**
- Task executor writes tests FIRST
- Runs tests (should fail - red phase)
- Implements code to pass tests
- Runs tests (should pass - green phase)
- Validates acceptance criteria before commit

**Exit Criteria:**
- Task executor for task 2.5 writes test_extractor.py first
- Tests fail initially
- Implementation passes tests
- Commits both code + tests atomically

**Validation:**
```bash
cd ~/code/_shared/link-triage-pipeline
/execute-plan --start-phase 2 --end-phase 2
# Watch git log: each commit should include test file
# Tests should be written BEFORE implementation
```

---

### **Phase 6: Traceability & Debugging** (Week 6)
*Full observability for agent troubleshooting*

**Goal:** Rich logs for future agent investigation

**Deliverables:**
1. Run log format + writer
2. Detailed commit messages (template)
3. Session log entries (orchestrator decisions)
4. Troubleshooting agent (optional: for testing)

**Features:**
- Run log: `output/runs/{date}-{uuid}.log`
- Detailed trace: spawn, complete, block, ralph, validate
- Commit messages: acceptance criteria, tests, task ID
- Session log: phase transitions, issues, timings

**Exit Criteria:**
- Can reconstruct full execution from logs
- Troubleshooting agent can diagnose task failures

**Validation:**
```bash
cd ~/code/_shared/link-triage-pipeline
/execute-plan
# After completion:
cat output/runs/2026-02-02-abc123.log | grep BLOCKED
# Should show any blockers with context
```

---

### **Phase 7: Polish & CLI** (Week 7)
*User-friendly commands and options*

**Goal:** Production-ready skill with all features

**Deliverables:**
1. CLI options: `--start-phase`, `--dry-run`, `--max-parallel`
2. `/pause-execution` command
3. `/resume-execution` command
4. Error handling refinement
5. Documentation

**Features:**
- `/execute-plan --start-phase 2` (resume from phase)
- `/execute-plan --dry-run` (simulate without commits)
- `/pause-execution` (graceful stop, surface current state)
- `/resume-execution` (continue from last checkpoint)

**Exit Criteria:**
- All CLI options work
- Can pause and resume execution
- Dry-run mode simulates without changes

**Validation:**
```bash
cd ~/code/_shared/link-triage-pipeline
/execute-plan --dry-run
# Should simulate execution without commits
/execute-plan --start-phase 3
# Should resume from Phase 3
```

---

## Technical Decisions

### 1. Where to Store the Skill?

**Option A: ADF repo** (`acm/skills/execute-plan/`)
- ✅ Centralized, part of ADF framework
- ✅ Easy to iterate and version with ACM
- ✅ Natural integration with ACM MCP
- ❌ Not reusable outside ADF projects

**Option B: Plugin** (`~/.claude/plugins/acm-orchestrator/`)
- ✅ Installable, reusable across projects
- ✅ Follows plugin architecture patterns
- ❌ More overhead to set up
- ❌ Harder to iterate during development

**Recommendation: Start with Option A (ACM repo skill)**
- Faster iteration during initial development
- Can migrate to plugin later if broadly useful

---

### 2. How to Invoke Ralph Loop?

**Option A: Via Skill tool**
```python
Skill(
  skill="ralph-loop:ralph-loop",
  args="--artifact docs/plan.md --focus 'Phase 1 work'"
)
```
- ✅ Uses existing ralph-loop plugin
- ✅ Clean separation of concerns
- ❌ Requires ralph-loop plugin installed

**Option B: Direct agent spawn**
```python
Task(
  subagent_type="ralph-reviewer",
  prompt="Review Phase 1 completed work..."
)
```
- ✅ More control over review context
- ❌ Duplicates ralph-loop logic

**Recommendation: Option A (Skill tool)**
- Reuses existing, battle-tested ralph-loop
- Orchestrator just coordinates, doesn't reimplement

---

### 3. How to Handle Commits?

**Option A: Task executor commits directly**
- Task executor calls Bash tool with git commit
- ✅ Immediate feedback per task
- ✅ Clear ownership (executor owns its commit)
- ❌ Executor needs commit template logic

**Option B: Orchestrator commits after task**
- Task executor reports completion
- Orchestrator stages + commits
- ✅ Centralized commit logic
- ❌ Added coordination overhead

**Recommendation: Option A (Executor commits)**
- Faster, more autonomous
- Commit template can be passed in executor context

---

### 4. How to Store Run Logs?

**Format:**
```
output/runs/{date}-{uuid}.log
```

**Structure:**
```
[timestamp] LOG_LEVEL MESSAGE
```

**Log levels:**
- `INIT` - Initialization
- `PHASE` - Phase transitions
- `SPAWN` - Sub-agent spawned
- `COMPLETE` - Task completed
- `BLOCKED` - Task blocked
- `RALPH` - Ralph-loop invoked
- `VALIDATE` - Phase validation
- `FIX` - Fix task created
- `ERROR` - Error occurred

**Recommendation: Plain text log file**
- Easy to tail, grep, analyze
- Lightweight, no dependencies
- Agent-readable (can parse with Read tool)

---

### 5. TaskList Management

**Creation:**
- Orchestrator creates all 66 tasks at start (TaskCreate × 66)
- Tasks start as `status=pending`

**Updates:**
- Task executor updates via TaskUpdate(taskId, status="completed")
- Orchestrator updates via TaskUpdate for blockers, fix tasks

**Querying:**
- Orchestrator polls TaskList to monitor progress
- User can run `/tasks` to see live status

**Recommendation: TaskCreate all upfront**
- Full visibility from start
- User can see total scope
- Easy to track progress percentage

---

## Integration Points

### ADF MCP Server

**Tools Used:**
- `get_stage("develop")` - Validate current stage
- `get_review_prompt("develop", "internal")` - Get ralph-loop prompt
- `check_project_health(path)` - Pre-flight checks

**Invocation:**
```python
# In orchestrator
review_prompt = mcp__acm__get_review_prompt(
  stage="develop",
  phase="internal"
)
```

---

### Ralph Loop Plugin

**Invocation at Phase Boundary:**
```python
# In orchestrator after all phase tasks complete
Skill(
  skill="ralph-loop:ralph-loop",
  args=f"--artifact docs/plan.md --focus 'Phase {phase_num} completed work'"
)
```

**Parsing Ralph Output:**
- Look for severity tags: `[Critical]`, `[High]`, `[Medium]`, `[Low]`
- Extract issue descriptions
- Count by severity

**Decision Logic:**
```python
if critical_count > 0:
    stop_execution()
    surface_to_user(ralph_report)
elif high_count > 0:
    fix_tasks = create_fix_tasks(high_issues)
    add_to_phase(fix_tasks)
    loop_back_to_task_execution()
else:
    proceed_to_phase_validation()
```

---

### Git Operations

**Per-Task Commit:**
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

**Phase Completion Commit:**
```bash
git commit --allow-empty -m "chore(phase-2): complete Phase 2 - Core Pipeline Components

Tasks completed: 14
Commits: 14
Ralph-loop cycles: 1
Issues resolved: 2 High"
```

---

## Testing Strategy

### Unit Testing (Phase-by-Phase)

**Phase 1: Core Orchestrator**
- Test: Parse plan.md correctly (5 phases extracted)
- Test: Parse tasks.md correctly (66 tasks extracted)
- Test: TaskCreate called 66 times
- Test: Sequential task execution (one after another)
- Mock: Task tool responses

**Phase 2: Ralph Loop Integration**
- Test: Ralph-loop invoked at phase boundary
- Test: Critical issues → stop execution
- Test: High issues → create fix tasks
- Test: Clean review → proceed to validation
- Mock: Ralph-loop Skill responses

**Phase 3: Phase Validator**
- Test: Parse exit criteria from plan.md
- Test: Run test-based criteria (pytest)
- Test: Run execution-based criteria (CLI commands)
- Test: Generate pass/fail report
- Mock: Command execution results

**Phase 4: Parallelization**
- Test: Dependency graph analysis (correct groups)
- Test: Parallel Task spawns (3-5 at once)
- Test: Progress monitoring (TaskList polling)
- Test: Blocker from any sub-agent handled
- Mock: Task tool responses with delays

**Phase 5: TDD Enforcement**
- Test: Tests written before implementation
- Test: Red phase (tests fail initially)
- Test: Green phase (tests pass after implementation)
- Test: Commit includes both code + tests
- Mock: File writes, test execution

---

### Integration Testing (End-to-End)

**Test 1: Single Phase Execution**
```bash
# Setup: Clean repo with plan.md + tasks.md
cd ~/code/_shared/link-triage-pipeline-test
/execute-plan --start-phase 1 --end-phase 1

# Assert:
# - 13 commits created
# - All Phase 1 tasks marked done in tasks.md
# - Session log in status.md updated
# - Ralph-loop invoked once
# - Phase 1 exit criteria validated
```

**Test 2: Full Plan Execution (5 Phases)**
```bash
cd ~/code/_shared/link-triage-pipeline-test
/execute-plan

# Assert:
# - ~66 commits (varies with fix tasks)
# - All 5 phases complete
# - Ralph-loop invoked 5 times (one per phase)
# - All phase exit criteria validated
# - status.md shows completion
```

**Test 3: Blocker Handling**
```bash
# Setup: Inject a blocker (missing API key in task 2.5)
cd ~/code/_shared/link-triage-pipeline-test
/execute-plan --start-phase 2 --end-phase 2

# Assert:
# - Task 2.5 reports blocker
# - Execution stops at task 2.5
# - User receives blocker report with context
# - Can resume after fixing
```

**Test 4: Ralph High Issues**
```bash
# Setup: Inject code that ralph will flag (e.g., poor error handling)
cd ~/code/_shared/link-triage-pipeline-test
/execute-plan --start-phase 1 --end-phase 1

# Assert:
# - Ralph-loop finds High issues
# - Fix tasks created (e.g., 1.14, 1.15)
# - Orchestrator executes fix tasks
# - Ralph-loop re-reviews (cycle 2)
# - Phase advances only after clean
```

---

## Success Metrics

### Performance

- **Parallelization efficiency**: Phase 2 completes in ~50% of sequential time
- **Ralph-loop overhead**: < 5 min per phase boundary
- **Total execution time**: 66-task plan completes in < 8 hours

### Quality

- **Test coverage**: 100% of tasks include tests
- **Commit quality**: All commits follow template, include acceptance criteria
- **Ralph cleanliness**: 0 Critical issues, < 2 High issues per phase (after fixes)

### Reliability

- **Blocker handling**: All blockers surfaced to user with actionable context
- **Resume capability**: Can resume from any phase after pause
- **Traceability**: Agent can diagnose issues from logs/commits alone

---

## Risk Mitigation

### Risk 1: Task Executor Hallucinates Tests

**Mitigation:**
- Provide clear test examples in executor context
- Specify mock strategy (unittest.mock for APIs)
- Validate test file exists and has assertions before marking done

### Risk 2: Ralph-Loop Generates Infinite Cycles

**Mitigation:**
- Max ralph cycles per phase: 3
- After 3 cycles: surface to user even if High issues remain
- Track cycle count in run log

### Risk 3: Parallelization Causes Race Conditions

**Mitigation:**
- Only parallelize truly independent tasks (no shared files)
- Task executor owns its files exclusively
- Orchestrator uses TaskList (atomic updates) for status

### Risk 4: Phase Validator False Positives

**Mitigation:**
- Exit criteria must be unambiguous (from plan.md)
- Validator logs exact commands run and outputs
- User can review validator report if disagreement

### Risk 5: Context Overflow with 5 Parallel Agents

**Mitigation:**
- Max 3-5 parallel (not 10+)
- Use Sonnet for task executors (cheaper, faster)
- Monitor token usage, reduce parallel count if needed

---

## Iteration Path

### Iteration 1: Proof of Concept (1-2 weeks)
- Phases 1-2 (Core Orchestrator + Ralph Loop)
- Test on Phase 1 of link-triage-pipeline only
- No parallelization yet
- Goal: Validate concept works end-to-end

### Iteration 2: Quality Gates (1 week)
- Phase 3 (Phase Validator)
- Test on Phases 1-2 of link-triage-pipeline
- Goal: Ensure phase boundaries enforce quality

### Iteration 3: Speed Optimization (1 week)
- Phase 4 (Parallelization)
- Test on full 5 phases of link-triage-pipeline
- Goal: Reduce execution time by 40-50%

### Iteration 4: Polish (1 week)
- Phases 5-7 (TDD, Traceability, CLI)
- Test on multiple projects (not just link-triage-pipeline)
- Goal: Production-ready, reusable skill

---

## Success Criteria for MVP (Iteration 1)

**Must Have:**
- ✅ Execute Phase 1 (13 tasks) sequentially
- ✅ Atomic commit per task (13 commits)
- ✅ Ralph-loop at phase boundary
- ✅ Update tasks.md status
- ✅ Session log in status.md

**Nice to Have:**
- Phase validator (manual validation OK for MVP)
- Parallelization (sequential OK for MVP)
- TDD enforcement (trust executor for MVP)

**Success Statement:**
"The orchestrator can autonomously execute Phase 1 of link-triage-pipeline, producing 13 commits, invoking ralph-loop for review, and advancing to Phase 2 only if clean."

---

## Next Steps

1. **Week 1**: Implement Phase 1 (Core Orchestrator)
   - Create skill file structure
   - Write orchestrator agent prompt
   - Write task executor agent prompt
   - Test on Phase 1 of link-triage-pipeline

2. **Week 2**: Add Ralph Loop Integration
   - Integrate ralph-loop Skill calls
   - Parse ralph output for severity
   - Create fix task logic
   - Test ralph cycle workflow

3. **Week 3**: Build Phase Validator
   - Write validator agent prompt
   - Implement exit criteria parsers
   - Generate validation reports
   - Test on Phase 1-2 exit criteria

4. **Weeks 4-7**: Continue with Phases 4-7 per roadmap

---

## Open Questions for Jesse

1. **Ralph-loop invocation**: Should we use existing ralph-loop plugin or build custom review logic?
   - Recommendation: Use existing plugin (battle-tested)

2. **Fix task threshold**: How many High issues trigger stop vs auto-fix?
   - Recommendation: Auto-fix up to 5 High issues, stop if > 5 or any Critical

3. **Resume granularity**: Resume from phase or from specific task?
   - Recommendation: Phase-level resume (simpler state management)

4. **Dry-run depth**: Should dry-run actually run tests or just simulate?
   - Recommendation: Simulate only (no file writes, no test execution)

5. **User notification frequency**: Log every task completion or only phases?
   - Recommendation: Phase boundaries only (reduce noise)

---

## Appendix: File Structure

```
acm/skills/execute-plan/
├── README.md                          # This roadmap + architecture overview
├── skill.md                           # Main skill entry point (user-invocable)
├── agents/
│   ├── orchestrator.md                # Phase coordinator
│   ├── task-executor.md               # Task worker (TDD-aware)
│   └── phase-validator.md             # Exit criteria checker
├── templates/
│   ├── commit-message.txt             # Commit message format
│   ├── session-log-entry.txt          # Status.md log entry format
│   └── run-log-entry.txt              # Run log format
└── tests/
    ├── test_orchestrator.py           # Unit tests for orchestrator logic
    ├── test_task_executor.py          # Unit tests for executor logic
    ├── test_phase_validator.py        # Unit tests for validator logic
    └── integration/
        ├── test_phase1_execution.py   # E2E test: Phase 1
        ├── test_full_plan.py          # E2E test: Full 5 phases
        └── test_blocker_handling.py   # E2E test: Blocker scenarios
```

---

## End of Implementation Roadmap
