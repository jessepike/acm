---
type: "capability-manifest"
artifact: "execute-plan-skill"
version: "1.0.0"
created: "2026-02-02"
stage: "develop"
phase: "capability-assessment"
---

# Execute-Plan Skill: Software Dependencies Manifest

## Summary

The execute-plan orchestration skill has **zero external software dependencies**. It is implemented entirely as Claude Code agent prompts (markdown files) and orchestrates existing infrastructure.

---

## Dependencies

### Runtime Dependencies

**None.** The skill is pure orchestration logic.

### Development Tools

| Tool | Purpose | Installation | Version |
|------|---------|--------------|---------|
| git | Atomic commits per task | Pre-installed (system) | Any modern version |
| Claude Code CLI | Host environment | Already installed | v2.1.3+ |

### Claude Code Built-in Tools

The skill uses Claude Code's native tool suite:

| Tool | Purpose |
|------|---------|
| Task | Spawn sub-agents (orchestrator, task-executor, phase-validator) |
| TaskCreate | Initialize task list from tasks.md |
| TaskUpdate | Update task status (pending → in-progress → completed) |
| TaskList | Monitor progress, check completion |
| Bash | Execute git commands for commits |
| Read | Read plan.md, tasks.md, design.md, existing code |
| Write | Create run logs, session logs |
| Edit | Update tasks.md status, status.md session log |
| Skill | Invoke ralph-loop plugin for reviews |

### MCP Servers

| Server | Purpose | Required | Installation |
|--------|---------|----------|--------------|
| ACM MCP | get_stage, get_review_prompt, check_project_health | Yes | Already installed |

### External Services

**None.** All orchestration is local.

---

## Installation Instructions

**No installation required.** The skill is self-contained within the ACM repo at:

```
acm/skills/execute-plan/
├── skill.md                    # Main entry point
├── agents/
│   ├── orchestrator.md         # Phase coordinator
│   ├── task-executor.md        # Task worker
│   └── phase-validator.md      # Exit criteria validator
└── templates/
    ├── commit-message.txt      # Git commit template
    ├── session-log-entry.txt   # Status.md log format
    └── run-log-entry.txt       # Run log format
```

---

## Environment Prerequisites

| Requirement | Check Command | Expected Result |
|-------------|---------------|-----------------|
| Git installed | `git --version` | git version 2.x+ |
| Claude Code CLI | `claude --version` | v2.1.3+ |
| ACM MCP server | Query via MCP tools | Responds to get_stage |
| Ralph Loop plugin | Check installed_plugins.json | ralph-loop present |

---

## Verification

After skill creation, verify environment:

```bash
# Check git
git --version

# Check Claude Code version
claude --version

# Check ACM MCP server
# (Will be tested via actual tool calls during build)

# Check ralph-loop plugin
cat ~/.claude/installed_plugins.json | grep ralph-loop
```

---

## Notes

- This skill has no package.json, requirements.txt, or Cargo.toml
- It is not a standalone application — it is orchestration logic
- All "dependencies" are existing Claude Code infrastructure
- The skill will be invoked via `/execute-plan` within Claude Code sessions
