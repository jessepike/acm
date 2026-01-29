---
type: "brief"
description: "Capability registry extraction — scoping document for agent execution"
created: "2026-01-29"
lifecycle: "ephemeral"
---

# Capability Registry — Extraction Brief

## What

Extract the capability registry from `~/code/tools/agent-harness/` into a standalone repo at `~/code/_shared/capabilities-registry/`. This is a curated personal registry of skills, tools, agents, and plugins available for agentic development.

## Why

Agents need to know what capabilities are available when planning and executing projects across all stages. Currently the registry is buried inside agent-harness (a broader project with stages, commands, domains, templates). The registry needs to be standalone, self-maintaining, and queryable by agents during any stage — Discover (research skills), Design (analysis tools), Develop (build capabilities), Deliver (deployment tools).

## Source Material

- **Agent-harness repo:** `~/code/tools/agent-harness/`
- **Key files to extract:** `active/`, `staging/`, `archive/`, `INVENTORY.md`, `INVENTORY.json`, `schemas/`, relevant scripts from `scripts/`
- **Sync system docs:** `~/code/tools/agent-harness/SYNC_SYSTEM_README.md` — describes the existing sync pipeline (fetch → validate → integrate → promote). Extract and simplify.
- **ACM Environment Spec:** `~/code/_shared/acm/ACM-ENVIRONMENT-SPEC.md` — section on Capabilities primitive defines the architectural role

## Target Structure

```
~/code/_shared/capabilities-registry/
├── README.md
├── REGISTRY-SPEC.md              # Self-documenting spec (see below)
├── inventory.json                # Derived from capability.yaml files (machine-readable index)
├── INVENTORY.md                  # Derived from inventory.json (human/agent-readable)
├── capabilities/
│   ├── skills/
│   │   ├── frontend-design/
│   │   │   ├── SKILL.md          # The actual skill file
│   │   │   └── capability.yaml    # Source, version, upstream URL, tags
│   │   ├── webapp-testing/
│   │   ├── pdf/
│   │   └── ...
│   ├── tools/                    # MCP servers + deterministic scripts
│   │   ├── memory-mcp/
│   │   └── ...
│   ├── agents/                   # Sub-agent definitions
│   │   └── ...
│   └── plugins/                  # Composite packages (skills + hooks + commands)
│       ├── acm-env/
│       └── ...
├── staging/                      # Capabilities not yet promoted
├── archive/                      # Deprecated versions
└── scripts/
    ├── sync.sh                   # Fetch + validate from upstream
    ├── check-freshness.sh        # Report what's stale (no auto-update)
    ├── promote.sh                # staging → capabilities/
    └── generate-inventory.sh     # capability.yaml files → inventory.json → INVENTORY.md
```

## Key Design Decisions

1. **Organized by capability name, not vendor.** `skills/frontend-design/` not `skills/@anthropic/frontend-design/`. Vendor/source is metadata in `capability.yaml`, not folder structure.

2. **Four capability types:** skills, tools, agents, plugins.
   - **Skills** — SKILL.md with instructions and supporting files (primary unit per Claude Code 2.1.3)
   - **Tools** — MCP servers or deterministic scripts
   - **Agents** — Sub-agent definitions with specialized domain expertise
   - **Plugins** — Composite packages that bundle skills, hooks, and commands (e.g., acm-env)

3. **Tags for queryability.** Agents search by need ("Do I have Supabase capabilities?"), not by folder. Tags in `capability.yaml`.

4. **`capability.yaml` is source of truth.** Each capability directory contains a `capability.yaml` manifest. `generate-inventory.sh` scans all `capability.yaml` files to produce `inventory.json` (machine-readable index) and `INVENTORY.md` (human/agent-readable). Data flows one direction: `capability.yaml` → `inventory.json` → `INVENTORY.md`. Never hand-edit `inventory.json` or `INVENTORY.md`.

5. **INVENTORY.md organized by category/tags** for agent readability:
   ```markdown
   ## By Category
   ### Frontend / UI
   | Name | Type | Tags | Description |
   ### Backend / Data
   | Name | Type | Tags | Description |
   ```

6. **Start with Anthropic official source only.** Community sources are future backlog.

7. **Freshness check, not auto-update.** `check-freshness.sh` reports what's stale. Human decides when to pull. Auto-update is a future enhancement.

8. **Lifecycle:** staging → active (in `capabilities/`) → archive.

## capability.yaml Schema

Each capability directory contains a `capability.yaml` — the source of truth for that capability:

```yaml
name: frontend-design
type: skill                    # skill | tool | agent | plugin
description: "Production-grade frontend UI design patterns"
source: anthropic              # Where it came from
upstream: https://github.com/anthropics/skills/tree/main/frontend-design
version: "20260122.1"
quality: 100                   # 0-100 score
tags: [ui, css, components, frontend, design]
status: active                 # staging | active | archive
added: "2026-01-29"
updated: "2026-01-29"
```

## REGISTRY-SPEC.md Should Cover

- Purpose and scope of the registry
- Four capability types with definitions (skills, tools, agents, plugins)
- Tags taxonomy (loose convention, documented common tags — e.g., `ui`, `backend`, `database`, `testing`, `documents`, `deployment`, `auth`, `api`)
- `capability.yaml` schema
- Lifecycle: staging → active → archive
- Data flow: `capability.yaml` → `inventory.json` → `INVENTORY.md` (one direction, never hand-edit derived files)
- Sync behavior (Anthropic official source, fetch + validate, manual promote)
- Freshness check behavior (report only, no auto-update)
- Relationship to ACM (consumed by all stages as needed, not coupled)

## What to Extract from Agent-Harness

| Extract | Don't Extract |
|---------|---------------|
| `active/` capabilities (actual skill/tool files) | `core/` (stages, commands — ACM owns this) |
| `staging/` capabilities | `domains/` (review later, separate concern) |
| `archive/` capabilities | `templates/` (project scaffolds) |
| Sync scripts (simplified — drop discovery feeds, GitHub Topics API) | `vendors/` folder structure (flatten into capabilities/) |
| Quality scoring logic | Deduplication engine (not needed for curated registry) |
| `.ack-meta.yaml` pattern (evolve to `capability.yaml`) | 11-source crawl config |
| `INVENTORY.json` / `INVENTORY.md` | `docs/` from agent-harness |

## What NOT to Do

- Do not bring over the 11-source discovery feed system — overkill for curated registry
- Do not organize by vendor (`@anthropic/`, `@modelcontextprotocol/`) — flatten to capability name
- Do not auto-update anything — freshness check reports only
- Do not import community capabilities (quality 40-69) — only Anthropic official (quality 90+)
- Do not couple to ACM — registry is standalone, ACM references it

## Success Criteria

- [ ] New git repo initialized at `~/code/_shared/capabilities-registry/`
- [ ] REGISTRY-SPEC.md created covering all sections listed above
- [ ] Active capabilities migrated from agent-harness with `capability.yaml` files
- [ ] `inventory.json` generated from `capability.yaml` files
- [ ] `INVENTORY.md` generated from `inventory.json` (organized by category)
- [ ] `scripts/generate-inventory.sh` works (`capability.yaml` → JSON → MD)
- [ ] `scripts/check-freshness.sh` reports stale capabilities
- [ ] `scripts/sync.sh` can fetch from Anthropic official source
- [ ] `scripts/promote.sh` moves staging → capabilities/
- [ ] README.md with quick start and overview
- [ ] No coupling to ACM or agent-harness
