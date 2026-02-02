---
name: "execute-plan"
type: "skill"
user_invocable: true
description: "Autonomous development orchestration — executes approved plan.md + tasks.md with parallel task executors, TDD enforcement, ralph-loop quality gates, and complete traceability"
version: "1.0.0"
created: "2026-02-02"
color: "green"
---

# Execute-Plan Orchestration Skill

Autonomous development orchestration skill that executes an approved `plan.md` + `tasks.md` with parallel task execution, quality gates, and complete traceability.

## Usage

```bash
/execute-plan [--start-phase N] [--dry-run] [--max-parallel N]
```

### Arguments

- `--start-phase N` — Resume from phase N (requires checkpoint state)
- `--dry-run` — Simulate execution without commits or file writes
- `--max-parallel N` — Cap parallel groups at N (default: 5)

### Prerequisites

Before invoking:
1. Project must have `docs/plan.md` (approved)
2. Project must have `docs/tasks.md` (approved)
3. Project must be a git repository
4. Working directory must be project root

## What It Does

1. **Parses plan.md** — Extracts phases, exit criteria, milestones
2. **Parses tasks.md** — Extracts 66+ tasks with dependencies
3. **Initializes TaskList** — Creates Claude Code task tracking
4. **Executes phases sequentially**:
   - Spawns 3-5 parallel task-executor agents for independent tasks
   - Each executor: writes tests first → implements → validates → commits
   - Waits for all tasks in phase to complete
5. **Quality gates** (at phase boundaries):
   - Invokes ralph-loop for internal review
   - Critical/High issues → creates fix tasks, re-runs
   - Max 3 ralph cycles per phase
6. **Validates exit criteria**:
   - Runs tests, checks files, validates artifacts
   - Blocks phase transition if criteria not met
7. **Produces traceability**:
   - Atomic git commits per task (with acceptance criteria)
   - Run log: `output/runs/{date}-{uuid}.log`
   - Session log: appended to `status.md`

## Architecture

### Three Specialized Agents

| Agent | Role | Count |
|-------|------|-------|
| orchestrator | Phase coordinator | 1 |
| task-executor | Task worker (TDD enforced) | 3-5 parallel |
| phase-validator | Exit criteria checker | 1 per phase |

### Execution Flow

```
orchestrator
  ├─→ spawns task-executor (group 1: tasks 1.1-1.4)
  ├─→ spawns task-executor (group 2: tasks 1.5-1.8)
  ├─→ spawns task-executor (group 3: tasks 1.9-1.12)
  ├─→ waits for all groups
  ├─→ invokes ralph-loop (phase boundary review)
  │   └─→ if High issues → creates F-prefix fix tasks → re-review
  ├─→ invokes phase-validator (exit criteria check)
  │   └─→ if fail → blocks, reports gaps
  └─→ proceeds to next phase
```

## Outputs

### Git Commits
- One commit per task
- Format: `feat(phase-N): <task-description>\n\nAcceptance: <criteria>\n\nTask: <id>\nTests: <test-file-paths>`

### Run Log
- Location: `output/runs/{date}-{uuid}.log`
- Events: INIT, PHASE, SPAWN, COMPLETE, BLOCKED, RALPH, VALIDATE, FIX, ERROR

### Session Log
- Location: `status.md` (appended)
- Format: timestamp, event type, orchestrator decisions, blockers, phase summaries

## Examples

### Full execution
```bash
/execute-plan
```

### Resume from Phase 3
```bash
/execute-plan --start-phase 3
```

### Dry run (no changes)
```bash
/execute-plan --dry-run
```

### Limit parallelization
```bash
/execute-plan --max-parallel 3
```

## Capabilities Used

- **Claude Code tools**: Task, TaskCreate, TaskUpdate, TaskList, Bash, Read, Write, Edit
- **Skills**: ralph-loop:ralph-loop (phase boundary review)
- **MCP**: acm-server (stage details, review prompts)
- **Git**: Atomic commits, traceability

## Validation Target

Initially validated on **link-triage-pipeline** (66 tasks, 5 phases).

## Notes

- Designed for ADF Develop stage automation
- Progressive phases: Core → Quality → Speed → Process → Observability → Production
- YAGNI: Only implements what's needed for plan execution
- Manual validation approach (no unit tests initially)
