# Design Stage Handoff

## Context

The ACM Discover stage is complete and validated. This document summarizes what's ready and what the Design stage needs to define.

---

## What Discover Produced

### Specifications (Ready to Use)

| Spec | Version | Purpose |
|------|---------|---------|
| ACM-DISCOVER-SPEC.md | 1.2.0 | Complete Discover workflow with two-phase review |
| ACM-BRIEF-SPEC.md | 2.1.0 | Brief structure, type-specific extensions |
| ACM-INTENT-SPEC.md | - | Intent structure |
| ACM-PROJECT-TYPES-SPEC.md | 2.0.0 | Type classification system |
| ACM-STATUS-SPEC.md | 1.1.0 | Session state tracking |
| ACM-TAXONOMY.md | 1.1.0 | Terms, decisions, artifact tiers |

### Prompts (Ready to Use)

| Prompt | Purpose |
|--------|---------|
| `prompts/ralph-review-prompt.md` | Phase 1 internal review (Ralph Loop) |
| `prompts/external-review-prompt.md` | Phase 2 external review (GPT/Gemini) |

### Key Patterns Established

1. **Two-phase review:** Internal (fast iteration) → External (diverse perspectives)
2. **YAGNI principle:** Only flag blocking issues, no scope expansion
3. **Artifact tiers:** Tier 1 (always), Tier 2 (stage-critical), Tier 3 (reference)
4. **Session protocol:** Read status at start, update at end

---

## What Design Stage Needs

### Primary Deliverable

**ACM-DESIGN-SPEC.md** — Define the Design stage workflow

### Questions to Answer

1. **What does Design produce?**
   - Architecture decisions?
   - Tech stack selection?
   - Component breakdown?
   - Design document/spec?

2. **What phases does Design have?**
   - Analysis? (understand Brief constraints)
   - Options? (explore approaches)
   - Decision? (commit to approach)
   - Documentation? (capture decisions)

3. **What are Design's inputs?**
   - Intent (always)
   - Brief (primary input)
   - What else?

4. **What are Design's exit criteria?**
   - When is Design "done"?
   - What does Develop need to start?

5. **Does Design need a review loop?**
   - If so, what does it review? (Architecture decisions? Tech choices?)
   - Same two-phase model, or different?

### Suggested Approach

Follow the Discover spec pattern:
- Phase model (what happens in what order)
- Inputs/outputs table
- Phase details (purpose, activities, agent role, human role, exit signal)
- Exit criteria checklist
- Context loading guidance

---

## Validation Done

The Discover stage was validated with a real project (portfolio website):

1. ✅ Ralph Loop produced meaningful iteration (2 cycles, 4 P1s resolved)
2. ✅ External review caught additional issues (Intent/Brief alignment, constraint conflicts)
3. ✅ Two-phase model works — different reviewers catch different things
4. ✅ YAGNI principle needed — external reviewers were too expansive without it

---

## Files Archived

Moved to `_archive/`:
- `AGENT-INSTRUCTIONS.md` — Content absorbed into CLAUDE.md pattern
- `discover-review-prompt.md` — Superseded by two new prompts

---

## Next Steps

1. Start new agent session for Design stage
2. Review this handoff + ACM-DISCOVER-SPEC.md for patterns
3. Draft ACM-DESIGN-SPEC.md
4. Optionally: Use portfolio project as Design test case (parallel to spec development)
