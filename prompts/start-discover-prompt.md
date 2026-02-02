---
type: "prompt"
description: "Stage entry prompt — initiates Discover stage for new projects"
version: "1.0.0"
updated: "2026-02-02"
scope: "discover"
usage: "Run at start of new project to begin Discover stage"
---

# Start Discover Stage

## Purpose

Initiate Discover stage for a new project. Validates project setup, updates state, loads context, and begins exploration phase.

---

## Prompt

```
You are starting the Discover stage for a new project.

## Step 1: Validate Project Setup

Verify basic project structure exists:
- Project directory created
- `status.md` exists (may be minimal/stub)
- `CLAUDE.md` exists (may be minimal/stub)

If missing:
- STOP
- Report what's missing
- Instruct user to run project initialization first

If present, continue to Step 2.

## Step 2: Update State

Update `status.md`:
- stage: discover
- phase: exploration
- last_action: "Started Discover stage"
- next_steps: "Begin exploration — gathering ideas, context, constraints"

## Step 3: Load Context

Read and internalize:
- `~/code/_shared/acm/ACM-DISCOVER-SPEC.md` — Stage workflow and requirements
- `~/code/_shared/acm/ACM-BRIEF-SPEC.md` — What the Brief will contain
- `~/code/_shared/acm/ACM-INTENT-SPEC.md` — What Intent.md should capture
- Any existing project notes or context the user has shared

## Step 4: Begin Exploration Phase

You are now in the Exploration phase — the divergent brainstorming stage.

**Your goal:** Gather the puzzle pieces. Understand the problem space.

**Activities:**
- Brainstorm with the user (conversational, broad)
- Research prior art, competitors, adjacent solutions if helpful
- Capture rough notes, questions, possibilities
- Identify constraints and dependencies
- Ask clarifying questions to understand:
  - What problem are we solving?
  - Who is this for?
  - What does success look like?
  - What are the constraints? (time, budget, tech, scope)
  - What's in scope vs out of scope?

**Agent role:** Conversational partner. Ask clarifying questions. Surface considerations. Don't structure yet — let ideas flow.

**Human role:** Provide direction, domain knowledge, gut instincts. Follow interesting threads.

**Phase exit signal:** Enough raw material gathered to start structuring. Human says "I think I have enough to crystallize" or agent confirms sufficient clarity to draft Brief and Intent.

Start by:
1. Asking the user to describe the project concept in their own words
2. Probing with follow-up questions to understand the problem space
3. Exploring constraints, success criteria, and scope boundaries
4. Continuing until you have enough context to move to Crystallization

When you have enough raw material, confirm: "I have enough to crystallize this into a structured Brief and Intent. Ready to move to Crystallization phase?"
```

---

## Notes

- Discover is the entry point — no prior stage to validate
- Project initialization should create minimal status.md + CLAUDE.md stubs
- Exploration phase is conversational and exploratory — no structure yet
- After exploration, agent moves to Crystallization phase to draft Brief + Intent
- Intent.md and Brief.md will be created during Crystallization, not before
