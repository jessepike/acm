---
type: "specification"
description: "Defines the external-review skill — automated Phase 2 review via external LLM APIs"
version: "1.0.0"
updated: "2026-01-31"
scope: "acm"
lifecycle: "draft"
location: "acm/ACM-EXTERNAL-REVIEW-SKILL-SPEC.md"
implements: "ACM-REVIEW-SPEC v1.2.0"
---

# ACM External Review Skill Specification

## Purpose

Define the `external-review` skill — an MCP-based automation that executes Phase 2 external reviews by calling external LLM APIs (Kimi K2, Gemini, DeepSeek, etc.) within Ralph Loop cycles, with Claude Code as the orchestrating synthesizer.

## Problem Statement

Phase 2 external review currently requires manual effort:
1. Copy artifact + prompt to external model interface
2. Copy response back to Claude Code
3. Repeat for each model
4. Manually trigger synthesis

This friction discourages external review usage. Automation removes the friction while preserving the review quality.

---

## Design Goals

| Goal | Description |
|------|-------------|
| **One-command execution** | User runs `/external-review`, everything else is inferred or configured |
| **Confirm before execute** | Show resolved configuration, wait for user confirmation |
| **Same rules apply** | Cycle rules, severity, complexity, action matrix from ACM-REVIEW-SPEC |
| **Provider-abstracted** | Swap models by editing config, not code |
| **Parallel execution** | Multiple models called simultaneously |
| **Claude Code synthesizes** | External models provide feedback; Claude Code decides actions |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                     EXTERNAL REVIEW SYSTEM                          │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ~/.claude/                                                         │
│  └── models.yaml ─────────┐    (API keys, user-specific, gitignored)│
│                           │                                         │
│  acm/skills/external-review/                                        │
│  ├── SKILL.md             │                                         │
│  ├── config.yaml ─────────┼──▶ ┌─────────────────────────────────┐ │
│  └── server/              │    │       MCP SERVER                │ │
│      ├── external_review_server.py     (external-review)         │ │
│      └── providers/       │    │                                 │ │
│          ├── base.py      │    │  Tools:                         │ │
│          ├── openai_compat.py  │  • list_models()                │ │
│          ├── google.py    │    │  • review(models[], artifact,   │ │
│          └── moonshot.py ◀┘    │          prompt) → parallel     │ │
│                                │          calls → aggregated     │ │
│                                └─────────────────────────────────┘ │
│                                              │                      │
│  acm/prompts/                                │                      │
│  ├── external-review-prompt.md              │                      │
│  ├── design-external-review-prompt.md       │                      │
│  └── develop-external-review-prompt.md      │                      │
│                                              ▼                      │
│  ┌───────────────────────────────────────────────────────────────┐ │
│  │                      CLAUDE CODE                              │ │
│  │  ┌─────────────────────────────────────────────────────────┐ │ │
│  │  │  Ralph Loop (external review cycle)                     │ │ │
│  │  │                                                         │ │ │
│  │  │  1. Resolve stage, artifact, prompt, models             │ │ │
│  │  │  2. Display configuration, wait for confirmation        │ │ │
│  │  │  3. Call MCP: review(["kimi-k2","gemini"], ...)        │ │ │
│  │  │  4. Receive aggregated feedback from all models         │ │ │
│  │  │  5. Synthesize (cross-reference, consensus weight)      │ │ │
│  │  │  6. Classify severity/complexity per ACM-REVIEW-SPEC    │ │ │
│  │  │  7. Auto-fix Low/Medium complexity, flag High to user   │ │ │
│  │  │  8. Update artifact + Issue Log + Review Log            │ │ │
│  │  │  9. Check stop conditions → loop or exit                │ │ │
│  │  └─────────────────────────────────────────────────────────┘ │ │
│  └───────────────────────────────────────────────────────────────┘ │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Skill Structure

```
acm/skills/external-review/
├── SKILL.md                          # Instructions, usage, when to invoke
├── config.yaml                       # Stage→prompt mapping, artifact conventions, defaults
└── server/
    ├── external_review_server.py     # MCP server implementation
    ├── providers/
    │   ├── __init__.py
    │   ├── base.py                   # Abstract provider interface
    │   ├── openai_compat.py          # OpenAI-compatible (DeepSeek, Together, etc.)
    │   ├── google.py                 # Gemini
    │   └── moonshot.py               # Kimi K2 (OpenAI-compatible but may need specifics)
    └── requirements.txt

~/.claude/
└── models.yaml                       # API keys — user-specific, NEVER in git
```

---

## Configuration Files

### models.yaml (User-specific, ~/.claude/models.yaml)

```yaml
# API credentials for external review models
# This file contains secrets — NEVER commit to git

models:
  kimi-k2:
    provider: moonshot
    endpoint: https://api.moonshot.cn/v1
    model: kimi-k2-0905
    api_key_env: MOONSHOT_API_KEY      # Or inline: api_key: "sk-..."
    
  gemini:
    provider: google
    endpoint: https://generativelanguage.googleapis.com/v1beta
    model: gemini-2.0-flash
    api_key_env: GOOGLE_API_KEY
    
  deepseek:
    provider: openai_compat
    endpoint: https://api.deepseek.com/v1
    model: deepseek-chat
    api_key_env: DEEPSEEK_API_KEY

# Optional: model-specific settings
settings:
  kimi-k2:
    temperature: 0.6
    min_p: 0.01
  gemini:
    temperature: 0.7
  deepseek:
    temperature: 0.7
```

### config.yaml (Skill defaults, acm/skills/external-review/config.yaml)

```yaml
# External Review Skill Configuration
# Versioned with skill — safe to commit

version: "1.0.0"
implements: "ACM-REVIEW-SPEC v1.2.0"

# Stage → prompt mapping (relative to acm/)
prompts:
  discover: "../prompts/external-review-prompt.md"
  design: "../prompts/design-external-review-prompt.md"
  develop: "../prompts/develop-external-review-prompt.md"

# Stage → default artifact path (relative to project root)
artifacts:
  discover: "docs/brief.md"
  design: "docs/design-brief.md"
  develop: "docs/implementation-spec.md"

# Default models if --models not specified
default_models:
  - kimi-k2
  - gemini

# Cycle rules (embedded from ACM-REVIEW-SPEC v1.2.0)
cycles:
  min: 2
  max: 10
  structural_problem_signal: 4    # If past N cycles and still finding Critical
  stuck_signal: 3                 # If same issue persists for N iterations

# Execution settings
execution:
  parallel: true                  # Call models in parallel
  timeout_seconds: 120            # Per-model timeout
  retry_attempts: 2               # Retry on transient failure
```

---

## MCP Server Specification

### Tools

#### `list_models`

Returns available models from `models.yaml`.

**Parameters:** None

**Response:**
```json
{
  "models": [
    {
      "id": "kimi-k2",
      "provider": "moonshot",
      "model": "kimi-k2-0905",
      "available": true
    },
    {
      "id": "gemini",
      "provider": "google", 
      "model": "gemini-2.0-flash",
      "available": true
    }
  ]
}
```

#### `review`

Sends artifact + prompt to specified models in parallel, returns aggregated responses.

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `models` | string[] | Yes | Model IDs from models.yaml |
| `artifact_content` | string | Yes | Full text of artifact being reviewed |
| `prompt` | string | Yes | Review prompt with instructions |
| `timeout` | number | No | Override default timeout (seconds) |

**Response:**
```json
{
  "reviews": [
    {
      "model": "kimi-k2",
      "status": "success",
      "response": "## Review Feedback\n\n### Critical Issues\n...",
      "tokens_used": { "input": 2341, "output": 892 },
      "latency_ms": 4521,
      "timestamp": "2026-01-31T14:23:45Z"
    },
    {
      "model": "gemini",
      "status": "success",
      "response": "## Review Feedback\n\n### Critical Issues\n...",
      "tokens_used": { "input": 2341, "output": 756 },
      "latency_ms": 3892,
      "timestamp": "2026-01-31T14:23:44Z"
    }
  ],
  "models_called": ["kimi-k2", "gemini"],
  "parallel": true,
  "total_latency_ms": 4521
}
```

**Error Response:**
```json
{
  "reviews": [
    {
      "model": "kimi-k2",
      "status": "error",
      "error": "API rate limit exceeded",
      "retries_attempted": 2
    }
  ]
}
```

### Provider Interface

```python
# base.py
from abc import ABC, abstractmethod
from dataclasses import dataclass

@dataclass
class ReviewResponse:
    status: str                    # "success" | "error"
    response: str | None           # Model response text
    error: str | None              # Error message if failed
    tokens_used: dict | None       # {"input": N, "output": N}
    latency_ms: int

class BaseProvider(ABC):
    """Abstract base class for LLM providers."""
    
    @abstractmethod
    async def review(
        self,
        artifact_content: str,
        prompt: str,
        model: str,
        settings: dict
    ) -> ReviewResponse:
        """Send review request to provider."""
        pass
    
    @abstractmethod
    async def health_check(self) -> bool:
        """Verify API connectivity."""
        pass
```

---

## User Experience

### Invocation

```bash
# Use defaults (models from config, auto-detect stage/artifact)
/external-review

# Specify models
/external-review --models kimi-k2,gemini

# Override stage detection
/external-review --stage design

# Override artifact path
/external-review --artifact docs/custom-brief.md

# Full override
/external-review --stage design --artifact docs/design-brief.md --models kimi-k2,gemini,deepseek
```

### Confirmation Flow

```
> /external-review

External Review Configuration
─────────────────────────────
Stage:     Design
Artifact:  docs/design-brief.md
Prompt:    acm/prompts/design-external-review-prompt.md
Models:    kimi-k2, gemini (parallel)
Cycles:    min 2, max 10

Proceed? (y/n): y

Starting external review cycle 1/10...
  → Calling kimi-k2... done (4.2s)
  → Calling gemini... done (3.8s)

Synthesizing feedback from 2 models...

Issues found:
  • [Critical/Medium] Missing error handling for API timeout — auto-fixing
  • [High/Low] Success criteria not measurable — auto-fixing  
  • [High/High] Unclear data model for user sessions — flagging for user

Auto-fixed 2 issues. 1 issue requires your input.

───────────────────────────────────────────────────────────
Flagged Issue: Unclear data model for user sessions
Severity: High | Complexity: High

Multiple reviewers flagged this:
  • kimi-k2: "Session state structure undefined, could cause inconsistency"
  • gemini: "No schema for session data, blocking for implementation"

This needs investigation. Options:
  1. Define session schema in design-brief.md
  2. Defer to implementation with explicit spike task
  3. Mark as out-of-scope with rationale

Your decision: 
```

### Cycle Progression

After user resolves flagged issues, cycle continues:

```
Continuing external review cycle 2/10...
  → Calling kimi-k2... done (3.9s)
  → Calling gemini... done (4.1s)

Synthesizing feedback from 2 models...

Issues found:
  • [Low/N/A] Consider adding sequence diagram — logged only

No Critical or High issues found. Minimum cycles (2) reached.

External review complete.
  Cycles: 2
  Issues resolved: 3 (2 auto-fixed, 1 user-resolved)
  Issues logged: 1 (Low severity)

Updating artifact status to 'external-review-complete'...
Done.
```

---

## Integration with Ralph Loop

The skill invokes Ralph Loop with the external review prompt. The prompt instructs Claude Code to:

1. Call the MCP `review` tool with configured models
2. Process aggregated responses
3. Apply ACM-REVIEW-SPEC rules (severity, complexity, action matrix)
4. Update artifact
5. Check stop conditions

**Ralph Loop invocation pattern:**

```bash
/ralph-loop:ralph-loop "$(cat acm/skills/external-review/assembled-prompt.md)" \
  --max-iterations 10 \
  --completion-promise "EXTERNAL_REVIEW_COMPLETE"
```

The assembled prompt includes:
- Stage context
- Artifact content
- External review instructions
- MCP tool usage instructions
- Synthesis rules
- Stop conditions

---

## Cycle Rules (from ACM-REVIEW-SPEC v1.2.0)

### Minimum Cycles
- **Phase 2 (External):** Minimum 2 cycles. Always.

### Stop Conditions
After each cycle:
> "Did this cycle surface any Critical or High severity issues?"

- **If yes:** Fix issues (or flag High complexity to user), run another cycle
- **If no (and minimum met):** Review phase complete

### Maximum Cycles
- **Hard maximum:** 10 cycles
- **Structural problem signal:** If past 4 cycles and still finding Critical issues, stop and flag
- **Stuck signal:** If same issue persists for 3+ iterations, stop and flag

---

## Severity & Complexity Definitions (from ACM-REVIEW-SPEC v1.2.0)

### Severity

| Severity | Definition | Action |
|----------|------------|--------|
| **Critical** | Must resolve. Blocks next stage or fundamentally flawed. | Fix before proceeding |
| **High** | Should resolve. Significant gap or weakness. | Fix before proceeding |
| **Low** | Minor. Polish, cosmetic, or implementation detail. | Log only |

### Complexity

| Complexity | Definition | Examples |
|------------|------------|----------|
| **Low** | Direct edit, no research, clear fix | Fix typo, add missing field |
| **Medium** | Design thinking, small refactor, clear path | Restructure section, add table |
| **High** | Needs research, investigation, architectural rethinking | Evaluate alternatives, resolve conflicts |

### Action Matrix

| Severity | Complexity | Action |
|----------|------------|--------|
| Critical | Low | Auto-fix |
| Critical | Medium | Auto-fix |
| Critical | High | **Flag for user** |
| High | Low | Auto-fix |
| High | Medium | Auto-fix |
| High | High | **Flag for user** |
| Low | Any | Log only |

---

## Cross-Reviewer Synthesis

When processing responses from multiple models:

1. **Extract issues** from each model's response
2. **Deduplicate** — same issue flagged by multiple models counts once
3. **Consensus weight** — issues flagged by multiple models are higher confidence
4. **Classify severity** — apply definitions, not model's assessment
5. **Classify complexity** — based on fix effort, not model's opinion
6. **Apply action matrix** — auto-fix or flag based on classification

### Consensus Rules

| Flagged By | Treatment |
|------------|-----------|
| All models | High confidence — likely real issue |
| Majority of models | Medium confidence — investigate |
| Single model | Lower confidence — verify before acting |

Single-model issues that aren't clearly blocking may be logged rather than acted on.

---

## Artifact Updates

After each cycle, update:

### Issue Log

| # | Issue | Source | Severity | Complexity | Status | Resolution |
|---|-------|--------|----------|------------|--------|------------|
| N | [description] | External-Kimi-K2, External-Gemini | Critical | Medium | Resolved | [what was done] |

### Review Log

```markdown
### Phase 2: External Review

**Date:** 2026-01-31
**Mechanism/Reviewers:** External-Kimi-K2, External-Gemini (parallel, 2 cycles)
**Issues Found:** 1 Critical, 2 High, 1 Low
**Complexity Assessment:** 1 Low, 2 Medium, 1 High
**Actions Taken:**
- **Auto-fixed (2 issues):**
  - Missing error handling (Critical/Medium) — Added timeout handling section
  - Non-measurable success criteria (High/Low) — Rewrote with specific metrics
- **Flagged for user (1 issue):**
  - Unclear session data model (High/High) — User chose to define schema
- **Logged only (1 issue):**
  - Consider sequence diagram (Low/N/A) — Deferred to implementation

**Cross-Reviewer Consensus:**
- Session data model flagged by both reviewers (high confidence)
- Error handling flagged by kimi-k2 only but clearly blocking

**Outcome:** Phase 2 complete, design approved for Develop
```

---

## Installation & Setup

### Prerequisites

- Claude Code with MCP support
- Ralph Loop plugin installed
- Python 3.11+
- API keys for desired models

### Step 1: Install Skill

```bash
# Clone/copy skill to ACM
cp -r external-review ~/code/_shared/acm/skills/

# Install Python dependencies
cd ~/code/_shared/acm/skills/external-review/server
pip install -r requirements.txt
```

### Step 2: Configure API Keys

Create `~/.claude/models.yaml`:

```yaml
models:
  kimi-k2:
    provider: moonshot
    endpoint: https://api.moonshot.cn/v1
    model: kimi-k2-0905
    api_key: "your-moonshot-api-key"
    
  gemini:
    provider: google
    endpoint: https://generativelanguage.googleapis.com/v1beta
    model: gemini-2.0-flash
    api_key: "your-google-api-key"
```

Or use environment variables:

```bash
export MOONSHOT_API_KEY="your-key"
export GOOGLE_API_KEY="your-key"
```

And reference in models.yaml:

```yaml
models:
  kimi-k2:
    api_key_env: MOONSHOT_API_KEY
```

### Step 3: Register MCP Server

Add to Claude Code MCP configuration:

```json
{
  "mcpServers": {
    "external-review": {
      "command": "python",
      "args": ["~/code/_shared/acm/skills/external-review/server/external_review_server.py"],
      "env": {}
    }
  }
}
```

### Step 4: Verify Installation

```bash
# In Claude Code
/external-review --help

# Should show available models
> MCP: list_models()
```

---

## Capability Registry Entry

```yaml
# capabilities-registry/capabilities/skills/external-review/capability.yaml

name: external-review
type: skill
description: >-
  MCP-based external review automation — calls external LLMs (Kimi K2, Gemini, DeepSeek)
  for Phase 2 review within Ralph Loop cycles. Claude Code synthesizes feedback and
  applies ACM-REVIEW-SPEC rules.
source: internal
upstream: ""
version: "1.0.0"
quality: 100
tags: [review, acm, mcp, validation, multi-model, external]
status: staging
install_level: user
added: "2026-01-31"
updated: "2026-01-31"
```

---

## Model Recommendations

| Model | Provider | Input Cost | Output Cost | Notes |
|-------|----------|------------|-------------|-------|
| **Kimi K2** | Moonshot | $0.60/M | $2.50/M | Strong reasoning, auto-caching to $0.15/M, OpenAI-compatible |
| **Gemini 2.0 Flash** | Google | $0.32/M | $2.63/M | Fast, different perspective |
| **DeepSeek V3** | DeepSeek | $0.28/M | $1.14/M | Excellent value, good reasoning |

**Default pair:** Kimi K2 + Gemini (different training data = diverse perspectives)

**Estimated cost per external review phase:** $0.02–$0.10 depending on artifact size and cycles.

---

## Security Considerations

| Concern | Mitigation |
|---------|------------|
| API keys in config | `models.yaml` at `~/.claude/`, gitignored, user-specific |
| Artifact content sent to external APIs | User confirms before execution; same trust model as manual review |
| API key exposure in logs | Server strips keys from error messages |
| Rate limiting | Configurable retry with backoff; graceful degradation |

---

## Future Enhancements

- [ ] Support for aggregator providers (OpenRouter, Together AI)
- [ ] Cost tracking and budget limits
- [ ] Response caching for identical artifact+prompt combinations
- [ ] Webhook notifications on completion
- [ ] Integration with CI/CD for automated review gates

---

## References

- ACM-REVIEW-SPEC.md (Phase 2 mechanism, severity definitions, cycle rules)
- ACM-STAGES-SPEC.md (Stage definitions, phase transitions)
- REGISTRY-SPEC.md (Capability registration)

---

## Revision History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-01-31 | Initial spec — architecture, MCP tools, UX flow, configuration |
