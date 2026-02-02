---
type: "capability-assessment"
artifact: "execute-plan-skill"
version: "1.0.0"
created: "2026-02-02"
stage: "develop"
phase: "capability-assessment"
---

# Execute-Plan Skill: Capabilities Assessment

## Registry Summary

- **Registry consulted:** ~/code/_shared/capabilities-registry/INVENTORY.md
- **Total available:** 39 capabilities (19 plugins, 16 skills, 4 tools)
- **Matched:** 2 capabilities directly used (ralph-loop skill, acm-env plugin for reference)
- **Gaps:** 1 MCP server (acm-server — part of ACM repo, not yet in registry)
- **Sub-agents:** 3 new agents to be created (orchestrator, task-executor, phase-validator)

**Analysis:** The skill primarily orchestrates existing Claude Code built-in tools (Task, TaskCreate, TaskUpdate, TaskList, Bash, Read, Write, Edit) and relies on one external skill (ralph-loop) and one MCP server (acm-server). Most capability needs are met by Claude Code's native infrastructure.

---

## MCP Servers

| Server | Purpose | Source | Install Vector |
|--------|---------|--------|----------------|
| acm-server | Stage details (`get_stage`), review prompts (`get_review_prompt`), project health checks (`check_project_health`) | ACM repo (`acm-server/`) | Local (bundled with ACM) |

**Notes:**
- acm-server is part of the ACM project at `~/code/_shared/acm/acm-server/`
- Already configured in ACM project's `.mcp.json`
- Provides orchestration-layer metadata about ACM stages, prompts, and validation

---

## Skills

| Skill | Purpose | Source | Install Level |
|-------|---------|--------|---------------|
| ralph-loop:ralph-loop | Phase boundary review — iterative quality gate with structured severity levels (Critical/High/Medium/Low) | registry: active/plugin/@anthropic/ralph-loop | User (already installed) |

**Usage:**
```python
# At phase boundaries in orchestrator
Skill(
    skill="ralph-loop:ralph-loop",
    args=f"--artifact docs/plan.md --focus 'Phase {phase_num} completed work'"
)
```

---

## Sub-Agents

The execute-plan skill orchestrates three specialized agents:

| Agent | Type | Purpose | File Location |
|-------|------|---------|---------------|
| orchestrator | Coordinator | Phase-level execution coordinator — parses plan/tasks, spawns executors, monitors progress, invokes ralph-loop, validates exit criteria | `acm/skills/execute-plan/agents/orchestrator.md` |
| task-executor | Worker | Task-level worker with TDD enforcement — writes tests first, implements code, validates acceptance criteria, commits atomically | `acm/skills/execute-plan/agents/task-executor.md` |
| phase-validator | Validator | Exit criteria checker — parses criteria from plan.md, runs tests/commands/checks, generates pass/fail reports | `acm/skills/execute-plan/agents/phase-validator.md` |

**Parallelization:**
- Orchestrator spawns 3-5 task-executor agents in parallel for independent tasks
- Each executor works on 1-4 related tasks sequentially
- Phase-validator invoked once per phase (after ralph-loop clean)

---

## CLIs & Tools

### Claude Code Built-in Tools

All core orchestration uses Claude Code's native tool suite:

| Tool | Purpose | Usage Pattern |
|------|---------|---------------|
| Task | Spawn sub-agents | `Task(subagent_type="task-executor", prompt=...)` |
| TaskCreate | Initialize task tracking | `TaskCreate(taskId="1.1", subject="...", description="...")` |
| TaskUpdate | Update task status | `TaskUpdate(taskId="1.1", status="completed")` |
| TaskList | Monitor progress | `task_list = TaskList()` |
| Bash | Execute git commands | `Bash(command="git commit -m '...'")` |
| Read | Read artifacts | `Read(file_path="docs/plan.md")` |
| Write | Create logs | `Write(file_path="output/runs/{uuid}.log", content=...)` |
| Edit | Update status | `Edit(file_path="status.md", old_string=..., new_string=...)` |
| Skill | Invoke ralph-loop | `Skill(skill="ralph-loop:ralph-loop", args="...")` |

### System CLIs

| Tool | Purpose | Install |
|------|---------|---------|
| git | Atomic commits per task, phase commits, traceability | Pre-installed (system) |

---

## Testing Capabilities

### Phase 1-3 Implementation (MVP)

**Test approach:** Manual validation
- Execute on link-triage-pipeline Phase 1 (13 tasks)
- Verify commit count, task status, session logs
- Validate ralph-loop integration, phase validator output

**Test frameworks:** None (pure orchestration, no unit tests initially)

### Phase 6 Implementation (Traceability)

**Test approach:** Manual troubleshooting validation
- Create troubleshooting scenarios (blocker, ralph issue, phase failure)
- Verify agent can diagnose from logs alone (git log, run log, session log)

**Frameworks:**
- Git log analysis (grep, bisect)
- Plain text log parsing

### Future Testing (Post-MVP)

**Automated testing possible for:**
- Plan.md parser (validate 5 phases extracted correctly)
- Tasks.md parser (validate 66 tasks extracted with dependencies)
- Dependency graph analyzer (validate task grouping logic)
- Ralph output parser (validate severity extraction)

**Test frameworks (if automated tests added later):**
- pytest (Python tests for parser logic)
- Jest/Vitest (TypeScript tests if skill converted to plugin)

**Current decision:** Manual validation sufficient for MVP (Phases 1-7). The skill orchestrates other agents' work — testing is indirect (validate outcomes, not orchestration logic).

---

## Capability Gaps & Mitigation

### Gap 1: ACM MCP Server Not in Registry

**Status:** ACM MCP server (`acm-server`) exists but not yet registered in capabilities-registry

**Mitigation:**
- Server is part of ACM repo, already configured in `.mcp.json`
- Functional and tested (58/59 tests passing)
- Will register post-implementation (separate task)

**Blocker:** No — server is available and functional

### Gap 2: Three Sub-Agents To Be Created

**Status:** orchestrator, task-executor, phase-validator agents don't exist yet

**Mitigation:**
- All three will be created during this Develop session (Phases 1-7)
- Agent prompts are fully designed (architecture.md, design.md)
- No external dependencies — pure markdown agent definitions

**Blocker:** No — creation is the core deliverable

### Gap 3: No Automated Testing Initially

**Status:** Skill will be manually tested initially

**Mitigation:**
- Validation target: link-triage-pipeline (real project)
- Traceability outputs (logs, commits) allow post-hoc verification
- Can add automated tests post-MVP if needed

**Blocker:** No — manual validation matches ACM MVP pattern

---

## Dependencies Between Capabilities

```
execute-plan skill
    ├─→ orchestrator agent (to be created)
    │   ├─→ acm-server MCP (get_stage, get_review_prompt)
    │   ├─→ ralph-loop skill (phase boundary review)
    │   ├─→ phase-validator agent (to be created)
    │   └─→ task-executor agents (to be created, 3-5 parallel)
    │       └─→ Claude Code tools (Task, Read, Write, Bash, etc.)
    │
    └─→ Claude Code infrastructure
        ├─→ Task tools (TaskCreate, TaskUpdate, TaskList)
        ├─→ Bash tool (git operations)
        └─→ File tools (Read, Write, Edit)
```

**Critical path:**
1. ACM MCP server must be available (✓ already configured)
2. Ralph-loop plugin must be installed (✓ already installed)
3. Git must be available (✓ system tool)
4. All three agents created during this session

---

## Capability Availability Verification

Before starting implementation (Phase 5: Environment Setup), verify:

```bash
# 1. ACM MCP server responds
# (Will test via actual tool call in Phase 5)

# 2. Ralph-loop plugin installed
grep "ralph-loop" ~/.claude/installed_plugins.json

# 3. Git available
git --version

# 4. Claude Code Task tools available
# (Built-in, no check needed)
```

Expected results:
- ACM MCP server: Responds to `mcp__acm__get_stage("develop")`
- Ralph-loop: Entry in installed_plugins.json
- Git: v2.x or later
- Claude Code tools: Always available (native)

---

## Success Criteria for Phase 2

- [x] Manifest created (zero external dependencies confirmed)
- [x] Registry consulted (39 capabilities reviewed)
- [x] Capabilities documented (MCP, skills, sub-agents, tools, testing)
- [x] Registry Summary included (mandatory HARD GATE requirement)
- [x] Gaps identified with mitigation (all non-blocking)
- [x] Dependency graph mapped
- [ ] **Human approval required** to proceed to Phase 3 (Planning)

**Exit signal:** Capabilities approved by human. Ready to create plan.md and tasks.md.
