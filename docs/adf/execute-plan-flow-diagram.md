# Execute-Plan Flow Diagram

## High-Level Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    User Invokes                             │
│                    /execute-plan                            │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│               Orchestrator Agent                            │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ 1. Parse plan.md (5 phases)                          │   │
│  │ 2. Parse tasks.md (66 tasks)                         │   │
│  │ 3. Create TaskList (TaskCreate × 66)                 │   │
│  │ 4. Initialize run log + session log                  │   │
│  └──────────────────────────────────────────────────────┘   │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              PHASE EXECUTION LOOP                           │
│                                                             │
│  For Phase 1 to 5:                                          │
│                                                             │
│  ┌────────────────────────────────────────────────────┐    │
│  │  Task Analysis & Grouping                          │    │
│  │  • Analyze dependency graph                        │    │
│  │  • Group independent tasks (max 3-5 per group)     │    │
│  └────────────────┬───────────────────────────────────┘    │
│                   │                                         │
│                   ▼                                         │
│  ┌────────────────────────────────────────────────────┐    │
│  │  Spawn Task Executors (Parallel)                   │    │
│  │  ╔══════════════╗  ╔══════════════╗  ╔═══════════╗ │    │
│  │  ║ Task Exec #1 ║  ║ Task Exec #2 ║  ║ Task Exc#3║ │    │
│  │  ║ Tasks 1.1-1.4║  ║ Tasks 1.5-1.7║  ║ Task 1.8  ║ │    │
│  │  ╚══════════════╝  ╚══════════════╝  ╚═══════════╝ │    │
│  └────────────────┬───────────────────────────────────┘    │
│                   │                                         │
│                   ▼                                         │
│  ┌────────────────────────────────────────────────────┐    │
│  │  Monitor Progress (TaskList)                       │    │
│  │  • Wait for task completions                       │    │
│  │  • Handle blockers → ralph-loop if needed          │    │
│  │  • Atomic commit per task                          │    │
│  └────────────────┬───────────────────────────────────┘    │
│                   │                                         │
│                   ▼                                         │
│  ┌────────────────────────────────────────────────────┐    │
│  │  All Phase Tasks Complete?                         │    │
│  │           NO → Loop back to Task Analysis          │    │
│  │           YES → Continue to Phase Boundary         │    │
│  └────────────────┬───────────────────────────────────┘    │
│                   │                                         │
│                   ▼                                         │
│  ┌────────────────────────────────────────────────────┐    │
│  │  PHASE BOUNDARY: Ralph Loop Review                 │    │
│  │  ┌──────────────────────────────────────────────┐  │    │
│  │  │ 1. Invoke ralph-loop with phase context      │  │    │
│  │  │ 2. Review all completed phase work           │  │    │
│  │  │ 3. Parse issues (Critical/High/Medium/Low)   │  │    │
│  │  │                                               │  │    │
│  │  │ IF Critical → STOP, surface to user          │  │    │
│  │  │ IF High → Create fix tasks, loop back        │  │    │
│  │  │ IF Clean → Continue to validation            │  │    │
│  │  └──────────────────────────────────────────────┘  │    │
│  └────────────────┬───────────────────────────────────┘    │
│                   │                                         │
│                   ▼                                         │
│  ┌────────────────────────────────────────────────────┐    │
│  │  Phase Exit Criteria Validation                    │    │
│  │  ╔════════════════════════════════════════════╗    │    │
│  │  ║  Phase Validator Agent                    ║    │    │
│  │  ║  • Run exit criteria checks               ║    │    │
│  │  ║  • Generate pass/fail report              ║    │    │
│  │  ║  PASS → Proceed                           ║    │    │
│  │  ║  FAIL → STOP, surface to user             ║    │    │
│  │  ╚════════════════════════════════════════════╝    │    │
│  └────────────────┬───────────────────────────────────┘    │
│                   │                                         │
│                   ▼                                         │
│  ┌────────────────────────────────────────────────────┐    │
│  │  Phase Closeout                                    │    │
│  │  • Commit "chore(phase-N): complete Phase N"       │    │
│  │  • Update tasks.md (mark all done)                 │    │
│  │  • Update status.md session log                    │    │
│  │  • Log to run log                                  │    │
│  └────────────────┬───────────────────────────────────┘    │
│                   │                                         │
│                   ▼                                         │
│              Next Phase?                                    │
│           YES → Loop to Phase N+1                           │
│           NO → Continue to Completion                       │
│                                                             │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│               FINAL REPORT                                  │
│  • Update status.md: "Build phase complete"                 │
│  • Generate completion summary                              │
│  • Surface to user: Ready for Develop internal review       │
└─────────────────────────────────────────────────────────────┘
```

---

## Task Executor Sub-Agent Flow

```
┌─────────────────────────────────────────────────────────────┐
│           Spawned by Orchestrator                           │
│           With: Task IDs, acceptance criteria, paths        │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│  For Each Assigned Task (sequential):                       │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ 1. UNDERSTAND CONTEXT                                │  │
│  │    • Read plan.md, design.md sections               │  │
│  │    • Read existing code in affected files           │  │
│  │    • Identify dependencies                          │  │
│  └──────────────────┬───────────────────────────────────┘  │
│                     │                                       │
│                     ▼                                       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ 2. WRITE TESTS FIRST (TDD)                           │  │
│  │    • Write test cases for acceptance criteria        │  │
│  │    • Mock external APIs                              │  │
│  │    • Run tests → RED (should fail)                   │  │
│  └──────────────────┬───────────────────────────────────┘  │
│                     │                                       │
│                     ▼                                       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ 3. IMPLEMENT                                          │  │
│  │    • Write code to pass tests                        │  │
│  │    • Follow design patterns                          │  │
│  │    • Respect .claude/rules/ constraints              │  │
│  │    • Run tests → GREEN (should pass)                 │  │
│  └──────────────────┬───────────────────────────────────┘  │
│                     │                                       │
│                     ▼                                       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ 4. VALIDATE                                           │  │
│  │    • Check each acceptance criterion                 │  │
│  │    • Run full test suite                             │  │
│  │    • Verify no regressions                           │  │
│  └──────────────────┬───────────────────────────────────┘  │
│                     │                                       │
│                     ▼                                       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │          Tests Passing?                              │  │
│  │            NO → Retry (2 attempts max)               │  │
│  │            Still NO → Report blocker to orchestrator │  │
│  │            YES → Continue                            │  │
│  └──────────────────┬───────────────────────────────────┘  │
│                     │                                       │
│                     ▼                                       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ 5. COMMIT (Atomic)                                    │  │
│  │    • Stage: code + tests                             │  │
│  │    • Generate commit message (template)              │  │
│  │    • Commit with Co-Authored-By                      │  │
│  └──────────────────┬───────────────────────────────────┘  │
│                     │                                       │
│                     ▼                                       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ 6. UPDATE STATUS                                      │  │
│  │    • TaskUpdate(taskId, status="completed")          │  │
│  │    • Report to orchestrator: commit hash, files      │  │
│  └──────────────────┬───────────────────────────────────┘  │
│                     │                                       │
│                     ▼                                       │
│              More Tasks?                                    │
│           YES → Loop to next task                           │
│           NO → Agent completes                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Ralph Loop Integration

```
┌─────────────────────────────────────────────────────────────┐
│         Orchestrator at Phase Boundary                      │
│         OR Task Executor hits blocker                       │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              Invoke Ralph Loop                              │
│                                                             │
│  Phase Review Context:                                      │
│  • Phase number + name                                      │
│  • All completed task IDs                                   │
│  • Changed files (git diff)                                 │
│  • Review prompt from ADF MCP                               │
│                                                             │
│  Task Debug Context:                                        │
│  • Task ID + description                                    │
│  • Test output (failures)                                   │
│  • Code under test                                          │
│  • Request: "Why is this failing?"                          │
│                                                             │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              Ralph Loop Reviews                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │ Cycle 1:                                             │  │
│  │ • Analyze code, tests, design alignment              │  │
│  │ • Identify issues (Critical/High/Medium/Low)         │  │
│  │ • Generate structured report                         │  │
│  └──────────────────────────────────────────────────────┘  │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────┐
│            Parse Ralph Loop Output                          │
│                                                             │
│  CRITICAL Issues:                                           │
│  → STOP execution                                           │
│  → Surface to user with report                              │
│  → User decides next steps                                  │
│                                                             │
│  HIGH Issues:                                               │
│  → Create fix tasks (add to current phase)                  │
│  → Loop back to task execution                              │
│  → Re-review after fixes (ralph-loop cycle 2)               │
│                                                             │
│  MEDIUM/LOW Issues:                                         │
│  → Log warnings                                             │
│  → Continue (acceptable for MVP)                            │
│                                                             │
│  CLEAN (No issues):                                         │
│  → Proceed to phase validation                              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Stopping Conditions Decision Tree

```
                    Issue Detected
                          │
                          ▼
        ┌─────────────────────────────────┐
        │   What type of issue?           │
        └─────────────┬───────────────────┘
                      │
        ┌─────────────┼─────────────────────┐
        │             │                     │
        ▼             ▼                     ▼
  ┌─────────┐  ┌─────────────┐      ┌──────────┐
  │Infrastructure│ Task Failure│      │ Critical │
  │   Issue   │  │             │      │ from     │
  │           │  │             │      │ Ralph    │
  └─────┬─────┘  └──────┬──────┘      └────┬─────┘
        │               │                   │
        ▼               ▼                   │
  Is it transient?  Attempts < 2?           │
     YES: Retry       YES: Retry            │
     NO: ↓            NO: ↓                 │
        │               │                   │
        └───────────────┴───────────────────┘
                        │
                        ▼
              ┌─────────────────────┐
              │  STOP EXECUTION     │
              │  Surface to user    │
              │  with context       │
              └─────────────────────┘

Other Issue Types (continue):
• Minor test failures → ralph-loop debug
• Linting issues → auto-fix
• Documentation gaps → auto-generate
• Medium/Low ralph issues → log warnings
```

---

## Traceability Outputs

```
                    User Wants to Troubleshoot
                              │
                              ▼
            ┌─────────────────────────────────┐
            │   What went wrong with task X?  │
            └────────────┬────────────────────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Git History  │  │ Run Log      │  │ Session Log  │
│              │  │              │  │ (status.md)  │
│ git log      │  │ output/runs/ │  │              │
│ --grep=      │  │ {uuid}.log   │  │ Orchestrator │
│ "task-X"     │  │              │  │ decisions    │
│              │  │ Detailed     │  │ at phase     │
│ Shows:       │  │ trace of     │  │ boundaries   │
│ • When       │  │ spawns,      │  │              │
│ • What       │  │ completions, │  │ Shows:       │
│   changed    │  │ blockers,    │  │ • Timings    │
│ • Tests      │  │ ralph-loops  │  │ • Decisions  │
│ • Commit     │  │              │  │ • Issues     │
└──────────────┘  └──────────────┘  └──────────────┘
        │                │                │
        └────────────────┴────────────────┘
                         │
                         ▼
              ┌─────────────────────┐
              │  Troubleshoot Agent │
              │  Analyzes all three │
              │  sources to diagnose│
              │  and report         │
              └─────────────────────┘
```

---

## Parallelization Example: Phase 2

```
Phase 2: Core Pipeline Components (14 tasks)

Dependency Analysis:
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  Independent Groups (can parallelize):                      │
│                                                             │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────┐ │
│  │ Group A:         │  │ Group B:         │  │ Group C: │ │
│  │ 2.1-2.4          │  │ 2.5-2.8          │  │ 2.9-2.10 │ │
│  │ Raindrop Fetcher │  │ Content Extractor│  │ URL      │ │
│  │ Depends: 1.8     │  │ Depends: 1.8     │  │ Normaliz │ │
│  └──────────────────┘  └──────────────────┘  └──────────┘ │
│                                                             │
│  Sequential (depends on above):                             │
│  ┌──────────────────┐                                      │
│  │ Group D:         │                                      │
│  │ 2.11-2.14        │                                      │
│  │ LLM Classifier   │                                      │
│  │ Depends: 1.10    │                                      │
│  └──────────────────┘                                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘

Execution Timeline:
─────────────────────────────────────────────────────────────
Time    Group A         Group B         Group C      Group D
─────────────────────────────────────────────────────────────
14:00   Start (2.1)     Start (2.5)     Start (2.9)  Waiting
14:15   2.1 done        2.5 done        2.9 done     Waiting
14:30   2.2 done        2.6 done        2.10 done    Waiting
14:45   2.3 done        2.7 done        [complete]   Waiting
15:00   2.4 done        2.8 done        [complete]   Start (2.11)
15:15   [complete]      [complete]      [complete]   2.11 done
15:30                                                 2.12 done
15:45                                                 2.13 done
16:00                                                 2.14 done
─────────────────────────────────────────────────────────────

Total time: ~2 hours (vs ~4 hours if fully sequential)
Max parallel: 3 groups (fits 3-5 guideline)
```

---

## End of Flow Diagrams
