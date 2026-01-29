---
type: "specification"
description: "Defines content and purpose of Global CLAUDE.md"
version: "1.0.1"
updated: "2026-01-24"
scope: "acm"
lifecycle: "reference"
location: "ack-src/acm/ACM-GLOBAL-CLAUDE-MD-SPEC.md"
---

# ACM Global CLAUDE.md Specification

## Purpose

Define what belongs in `~/.claude/CLAUDE.md` — the universal guardrails layer that applies to ALL projects regardless of domain, complexity, or stack.

## Design Principles

**Irreducible:** Only include what is truly universal. If it depends on project type, complexity, or domain — it belongs at project level.

**Guardrails, not workflow:** Global defines safety constraints and communication norms. It does NOT prescribe how to plan, structure tasks, or organize work.

**Minimal:** Small enough to fit comfortably in context without crowding out project-specific guidance. Target: <50 lines.

## Content Categories

### 1. Safety Constraints

Non-negotiable rules that prevent harm across all contexts.

| Constraint | Rationale |
|------------|-----------|
| Never commit secrets, credentials, or API keys | Security — prevents accidental exposure |
| Confirm before destructive operations | Safety — delete/drop/overwrite are irreversible |
| Ask when uncertain rather than assume | Quality — prevents compounding errors |

### 2. Commit Hygiene

Universal standards for version control integrity.

| Standard | Rationale |
|----------|-----------|
| Atomic commits (one logical change) | Traceability — clean history, easy rollback |
| Conventional format: `type(scope): description` | Consistency — readable, parseable commit log |
| Verify before commit (lint, test, build) | Quality — don't commit broken code |

### 3. Communication Style

Norms for agent-human interaction.

| Norm | Rationale |
|------|-----------|
| Concise — bullets over paragraphs | Efficiency — respect human attention |
| Flag blockers immediately | Transparency — don't spin wheels silently |
| State assumptions explicitly | Clarity — enables correction before execution |

### 4. Rules Protection

Governance boundary between human and agent authority.

| Rule | Rationale |
|------|-----------|
| Never modify `.claude/rules/` without explicit human approval | Governance — rules are human-controlled |

## Out of Scope (Project-Level)

The following belong in `.claude/CLAUDE.md` or `.claude/rules/`, NOT global:

- Plan/phase/task structure
- Stage model (Discover → Design → Setup → Develop → Deliver)
- Stack-specific conventions
- Domain terminology
- Architecture patterns
- Token budgets
- Artifact templates
- Testing conventions

## File Structure

Global CLAUDE.md uses a flat structure with XML constraint tags for priority signaling:

```markdown
# Global Context

<constraints>
[Non-negotiable safety rules — highest priority]
</constraints>

## [Category]
[Standards and norms — regular priority]
```

The `<constraints>` block signals to the agent that these rules are inviolable.

## Governance

| Aspect | Rule |
|--------|------|
| Who modifies | Human only |
| Change process | Manual edit |
| Version tracking | Optional (low churn expected) |
| Location | `~/.claude/CLAUDE.md` |

## Validation Checklist

Before deploying Global CLAUDE.md:

- [ ] All content is truly universal (applies to any project)
- [ ] No project-specific or domain-specific guidance
- [ ] No workflow prescriptions (plans, phases, tasks)
- [ ] Under 50 lines
- [ ] Constraints block contains only safety-critical items

## References

- Source: TIER1_KIT_SPEC.md (extracted and simplified)
- Parent: ACM-GLOBAL-PRIMITIVES-v0.1.md
