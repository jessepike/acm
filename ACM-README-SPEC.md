---
type: "specification"
description: "Defines README requirements for ACM package and projects"
version: "1.0.0"
updated: "2026-01-27"
scope: "acm"
lifecycle: "reference"
location: "acm/ACM-README-SPEC.md"
---

# ACM README Specification

## Purpose

Define what README files must contain and when they must be updated. READMEs are critical orientation documents that often get neglected. This spec makes maintenance explicit.

---

## Two README Scopes

| README | Location | Purpose |
|--------|----------|---------|
| **ACM README** | `/acm/README.md` | Package overview, quick start, spec index |
| **Project README** | `{project}/README.md` | Project overview, intent link, status link |

---

## ACM README Requirements

The ACM package README (`/acm/README.md`) must contain:

### Required Sections

1. **Title & Description** — What ACM is (1-2 sentences)
2. **Quick Start** — How to deploy global CLAUDE.md and init a project
3. **Spec Index** — Table of all specs with brief descriptions
4. **Core Concepts** — Project types, stages, key artifacts
5. **Folder Structure** — What a project looks like
6. **References** — Links to detailed specs

### Update Triggers

| Trigger | Update Required |
|---------|-----------------|
| New spec created | Add to Spec Index |
| Spec renamed/removed | Update Spec Index |
| Init script changes | Update Quick Start |
| Core concept changes | Update Core Concepts |
| Folder structure changes | Update Folder Structure |

### Validation Criteria

- [ ] All current specs listed in Spec Index
- [ ] Quick Start instructions are accurate and work
- [ ] Version/date in frontmatter is current
- [ ] No dead links

---

## Project README Requirements

Each project's README (`{project}/README.md`) must contain:

### Required Sections

1. **Title** — Project name
2. **Intent** — Link to `docs/intent.md`
3. **Status** — Link to `docs/status.md`
4. **Classification** — Type and scale
5. **Quick Start** — How to run/use (populated in Design/Develop)

### Optional Sections

- Architecture overview (after Design)
- Contributing guidelines (if shared/community)
- License (if public)

### Update Triggers

| Trigger | Update Required |
|---------|-----------------|
| Project initialized | Created by init script |
| Stage completion | Update status section |
| Classification changes | Update classification |
| Quick Start becomes known | Populate Quick Start |

### Validation Criteria

- [ ] Links to intent.md and status.md work
- [ ] Classification matches CLAUDE.md
- [ ] No stale information

---

## Format

### ACM README Format

```markdown
---
type: "documentation"
description: "ACM package overview and quick start"
version: "X.Y.Z"
updated: "YYYY-MM-DD"
---

# ACM — Agentic Context Management

[1-2 sentence description]

## Quick Start

[Numbered steps to get started]

## Specifications

| Spec | Purpose |
|------|---------|
| [Spec Name](link) | [Brief description] |

## Core Concepts

[Key concepts: types, stages, artifacts]

## Folder Structure

[What a project looks like]

## References

[Additional resources]
```

### Project README Format

```markdown
# [Project Name]

## Intent

See [docs/intent.md](docs/intent.md)

## Status

See [docs/status.md](docs/status.md) for current state.

## Classification

- **Type:** [type]
- **Scale:** [scale]

## Quick Start

[How to run/use — populated during Design/Develop]
```

---

## Core Maintainable Artifacts

README is one of several artifacts that must stay current. See ACM-TAXONOMY.md for the full artifact maintenance tiers.

| Tier | Artifacts | Update Frequency |
|------|-----------|------------------|
| **Tier 1: Always** | status.md, CLAUDE.md | Every session |
| **Tier 2: Stage-Critical** | intent.md, brief, README | Stage boundaries, milestones |
| **Tier 3: Reference** | Architecture, decisions | When relevant |

---

## Enforcement

README maintenance is the responsibility of:

1. **Agents** — Should flag when README appears stale
2. **Humans** — Review at stage boundaries
3. **Init script** — Creates initial README

No automated validation currently. Future: `acm-validate` could check README compliance.

---

## References

- ACM-TAXONOMY.md (Artifact maintenance tiers)
- ACM-STATUS-SPEC.md (Status tracking)
- ACM-PROJECT-CLAUDE-MD-SPEC.md (CLAUDE.md structure)
