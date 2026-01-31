---
name: external-review
description: Run Phase 2 external review — calls external LLMs via MCP, synthesizes feedback within Ralph Loop cycles
user_invocable: true
arguments:
  - name: stage
    description: "Override stage detection (discover|design|develop)"
    required: false
  - name: artifact
    description: "Override artifact path"
    required: false
  - name: models
    description: "Comma-separated model IDs (e.g., kimi-k2,gemini)"
    required: false
---

# External Review Skill

You are executing an automated Phase 2 external review. External LLM models will review the artifact and you will synthesize their feedback.

## Step 1: Resolve Configuration

### Stage Detection
1. If `--stage` argument provided, use it
2. Otherwise, read `status.md` in the project root and extract the current stage
3. Valid stages: `discover`, `design`, `develop`

### Artifact Resolution
1. If `--artifact` argument provided, use the absolute path
2. Otherwise, use the stage default from `config.yaml`:
   - discover → `docs/discover-brief.md`
   - design → `docs/design.md`
   - develop → `docs/design.md`
3. Resolve path relative to project root

### Prompt Resolution
1. Try ACM MCP server: `acm-server.get_review_prompt(stage, "external")`
2. Fallback: read directly from `config.yaml` prompt path (relative to skill dir)

### Model Resolution
1. If `--models` argument provided, split by comma
2. Otherwise, use `default_models` from `config.yaml`
3. Verify models exist via MCP: `external-review.list_models()`

## Step 2: Confirm Before Execute

Display the resolved configuration and wait for user confirmation:

```
External Review Configuration
─────────────────────────────
Stage:     {stage}
Artifact:  {artifact_path}
Prompt:    {prompt_source}
Models:    {model_list} (parallel)
Cycles:    min 1 per reviewer, max 10

Proceed? (y/n):
```

**Do NOT proceed without explicit user confirmation.**

## Step 3: Execute Review Cycle

For each cycle (up to max 10):

### 3a. Call External Models

Use the MCP tool to call all models in parallel:

```
external-review.review(
  models: ["{model_1}", "{model_2}"],
  artifact_path: "{absolute_artifact_path}",
  prompt: "{review_prompt_content}"
)
```

### 3b. Process Responses

For each model response:
1. **Extract issues** — identify distinct problems flagged
2. **Deduplicate** — same issue from multiple models counts once
3. **Consensus weight** — issues from multiple models = higher confidence
4. **Classify severity** using ACM-REVIEW-SPEC definitions:
   - **Critical**: Must resolve. Blocks next stage or fundamentally flawed.
   - **High**: Should resolve. Significant gap or weakness.
   - **Low**: Minor. Polish, cosmetic, or implementation detail.
5. **Classify complexity**:
   - **Low**: Direct edit, no research, clear fix
   - **Medium**: Design thinking, small refactor, clear path
   - **High**: Needs research, investigation, architectural rethinking

### 3c. Apply Action Matrix

| Severity | Complexity | Action |
|----------|------------|--------|
| Critical | Low | Auto-fix |
| Critical | Medium | Auto-fix |
| Critical | High | **Flag for user** — stop and ask |
| High | Low | Auto-fix |
| High | Medium | Auto-fix |
| High | High | **Flag for user** — stop and ask |
| Low | Any | Log only |

### 3d. Update Artifact

After applying fixes:
1. Update the artifact content with fixes
2. Add entries to the **Issue Log** section:
   ```
   | # | Issue | Source | Severity | Complexity | Status | Resolution |
   |---|-------|--------|----------|------------|--------|------------|
   | N | [description] | External-{model_id} | Critical | Medium | Resolved | [what was done] |
   ```
3. Add/update the **Review Log** section with cycle summary

### 3e. Check Stop Conditions

After each cycle, evaluate:
- **If Critical or High issues found**: Fix (or flag), run another cycle
- **If no Critical or High (and minimum met)**: Review complete
- **If past 4 cycles with Critical issues**: Stop — structural problem signal
- **If same issue persists 3+ cycles**: Stop — stuck signal
- **If at cycle 10**: Hard stop

## Step 4: Complete

When review is complete:
1. Update artifact frontmatter status if applicable
2. Log final review summary
3. Report results:
   ```
   External review complete.
     Cycles: {N}
     Issues resolved: {N} ({N} auto-fixed, {N} user-resolved)
     Issues logged: {N} (Low severity)
   ```

## Invocation via Ralph Loop

This skill is designed to work within the Ralph Loop. The standard invocation:

```bash
/ralph-loop:ralph-loop "$(cat ~/code/_shared/acm/prompts/{stage}-external-review-prompt.md)" \
  --max-iterations 10 \
  --completion-promise "EXTERNAL_REVIEW_COMPLETE"
```

The skill handles context assembly; Ralph Loop handles the iteration mechanics.
