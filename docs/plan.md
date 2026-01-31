---
type: "plan"
project: "ACM MCP Server"
version: "1.0"
status: "draft"
created: "2026-01-31"
design_ref: "docs/design.md"
manifest_ref: "docs/manifest.md"
capabilities_ref: "docs/capabilities.md"
---

# Plan: ACM MCP Server

## Overview

Build a 13-tool read-only TypeScript MCP server at `acm/acm-server/` plus a companion workflow skill at `acm/skills/acm-workflow/`. Follows the build order from design.md Section "Implementation Guidance".

## Phases

### Phase A: Scaffold & Infrastructure

Set up the project structure, dependencies, and shared utilities.

1. **Scaffold** — `npm init`, directory structure, `tsconfig.json`, `package.json`
2. **Server entry point** — `src/index.ts` (stdio transport setup), `src/server.ts` (McpServer instance)
3. **Path resolution** — `src/lib/paths.ts` with `normalizePath()`, tilde expansion, env var fallback
4. **File utilities** — `src/lib/files.ts` (readFile, readFrontmatter, fileExists)
5. **Error helpers** — `src/lib/errors.ts` (isError response builder)
6. **Types** — `src/types.ts` (shared TypeScript types)

**Exit:** Server compiles, starts, and responds to MCP `initialize` handshake. Shared libs importable.

### Phase B: Tool Implementation

Implement all 13 tools in category order. Each tool file follows the same pattern: import libs, register tools with `z.object()` schemas, implement handlers.

1. **Orchestration** — `src/tools/orchestration.ts` (3 tools: `get_stage`, `get_review_prompt`, `get_transition_prompt`)
2. **Artifacts** — `src/tools/artifacts.ts` (2 tools: `get_artifact_spec`, `get_artifact_stub`)
3. **Project** — `src/tools/project.ts` (3 tools: `get_project_type_guidance`, `check_project_structure`, `check_project_health`)
4. **Governance** — `src/tools/governance.ts` (2 tools: `get_rules_spec`, `get_context_spec`)
5. **Capabilities** — `src/tools/capabilities.ts` (2 tools: `query_capabilities`, `get_capability_detail`)
6. **Knowledge** — `src/tools/knowledge.ts` (1 tool: `query_knowledge`)

**Exit:** All 13 tools registered, compile clean, handle happy path and error cases.

### Phase C: Path Sandboxing & Validation

Harden path handling per Phase 2 review findings.

1. **Sandbox enforcement** — realpath prefix checks per tool category (ACM_ROOT, REGISTRY_ROOT, project_path)
2. **capability_id validation** — regex constraint `^[a-z0-9][a-z0-9-]*$`
3. **Edge case handling** — missing files, empty results, invalid frontmatter, missing status.md/brief

**Exit:** All path inputs validated and sandboxed. Error cases return `isError` with actionable messages.

### Phase D: Companion Skill

Build the ACM Workflow skill that teaches agents when/how to use tools.

1. **skill.md** — Skill definition with triggers and instructions
2. **references/tool-guide.md** — Per-tool when-to-use guide with common workflow sequences

**Exit:** Skill files complete, consumer wiring documented.

### Phase E: Integration & Verification

End-to-end verification against success criteria.

1. **Build verification** — `npm run build` produces working `build/index.js`
2. **Manual smoke test** — Wire into a consumer project via `.mcp.json`, verify tools respond correctly
3. **Consumer wiring template** — Document `.mcp.json` snippet for consumer projects
4. **README.md** — Usage, installation, tool reference

**Exit:** All success criteria from Brief verified. Server ready for use.

## Build Principles

- **Compile early, compile often** — verify TypeScript compiles after each file
- **One tool category at a time** — implement, test, commit, move on
- **Spec comments** — add `// Per ACM-{SPEC}-SPEC vX.Y.Z` comments where validation logic references spec content
- **Atomic commits** — one logical change per commit
- **No stdout** — all logging to stderr

## Risk Mitigations

| Risk | Mitigation |
|------|-----------|
| MCP SDK API mismatch | Check SDK docs/types for `registerTool` signature before implementing first tool |
| gray-matter edge cases | Test with actual ACM spec files that have complex frontmatter |
| Path sandboxing false positives | Test with symlinked directories and relative paths |
