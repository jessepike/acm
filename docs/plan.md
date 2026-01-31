---
type: "plan"
project: "ACM MCP Server"
version: "1.1"
status: "internal-review-complete"
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

Set up the project structure, dependencies, and shared utilities including path sandboxing.

1. **Scaffold** — `npm init`, directory structure, `tsconfig.json`, `package.json`
2. **Server entry point** — `src/index.ts` (stdio transport setup), `src/server.ts` (McpServer instance)
3. **Path resolution + sandboxing** — `src/lib/paths.ts` with `normalizePath()`, tilde expansion, env var fallback, and `validatePathWithinBase()` using `fs.realpath()` + prefix check
4. **File utilities** — `src/lib/files.ts` (readFile, readFrontmatter, fileExists)
5. **Error helpers** — `src/lib/errors.ts` (isError response builder)
6. **Types** — `src/types.ts` (shared TypeScript types)

**Exit:** Server compiles, starts, and responds to MCP `initialize` handshake. Shared libs importable. Path sandboxing functional.

### Phase B: Tool Implementation

Implement all 13 tools in category order. Each tool file follows the same pattern: import libs, register tools with `z.object()` schemas, implement handlers. All file reads go through sandboxed path resolution from Phase A.

1. **Orchestration** — `src/tools/orchestration.ts` (3 tools: `get_stage`, `get_review_prompt`, `get_transition_prompt`)
2. **Artifacts** — `src/tools/artifacts.ts` (2 tools: `get_artifact_spec`, `get_artifact_stub`)
3. **Project** — `src/tools/project.ts` (3 tools: `get_project_type_guidance`, `check_project_structure`, `check_project_health`)
4. **Governance** — `src/tools/governance.ts` (2 tools: `get_rules_spec`, `get_context_spec`)
5. **Capabilities** — `src/tools/capabilities.ts` (2 tools: `query_capabilities`, `get_capability_detail`)
6. **Knowledge** — `src/tools/knowledge.ts` (1 tool: `query_knowledge`)

**Exit:** All 13 tools registered, compile clean, handle happy path and error cases. Sandbox enforced on all file reads.

### Phase C: Edge Cases & Error Handling

Verify all edge cases produce actionable errors.

1. **Edge case testing** — missing files, empty KB, no frontmatter, invalid capability_id, `..` in project_path, missing status.md/brief for validate mode

**Exit:** All edge cases return `isError` with actionable messages. No crashes.

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

## Testing Strategy

This is a read-only MCP server with no external dependencies. Testing focuses on manual verification during build and smoke testing at integration.

**During Build (Phase B):**
- Compile after each tool file — `npm run build` must pass
- Verify each tool category returns expected content by calling tools manually via MCP inspector or consumer project
- Test both happy path (valid inputs) and error path (invalid stage, missing file) per tool

**Edge Cases (Phase C):**
- Missing spec files → graceful `isError`, not crash
- Empty capabilities registry → empty results, not error
- No frontmatter in artifacts → handle gracefully
- Invalid `capability_id` → rejected before path construction
- `..` in `project_path` → sandbox rejection
- `validate: true` with incomplete project → clear error about what's missing
- Tilde expansion in env var paths → resolves correctly
- KB directory with no matching results → empty results

**Integration (Phase E):**
- Wire into consumer project (e.g., link-triage-pipeline)
- Call at least one tool from each of the 6 categories
- Verify success criteria from Brief

**No automated test framework** — this is an MVP personal tool with 13 read-only tools. The cost of setting up Jest/Vitest exceeds the value for this scope. If tool count grows or logic becomes complex, add automated tests then.

## Build Principles

- **Compile early, compile often** — verify TypeScript compiles after each file
- **One tool category at a time** — implement, test, commit, move on
- **Sandbox from the start** — path validation built into lib/paths.ts, used by all tools
- **Spec comments** — add `// Per ACM-{SPEC}-SPEC vX.Y.Z` comments where validation logic references spec content
- **Atomic commits** — one logical change per commit
- **No stdout** — all logging to stderr

## Risk Mitigations

| Risk | Mitigation |
|------|-----------|
| MCP SDK API mismatch | Check SDK docs/types for `registerTool` signature before implementing first tool |
| gray-matter edge cases | Test with actual ACM spec files that have complex frontmatter |
| Path sandboxing false positives | Test with symlinked directories and relative paths |

## Issue Log

| # | Issue | Source | Severity | Status | Resolution |
|---|-------|--------|----------|--------|------------|
| 1 | Tasks format doesn't match ACM-DEVELOP-SPEC — missing acceptance criteria, dependencies, capability columns | Ralph-Develop | High | Resolved | Converted tasks.md to table format with all required columns |
| 2 | Plan missing testing strategy section required by ACM-DEVELOP-SPEC | Ralph-Develop | High | Resolved | Added Testing Strategy section |
| 3 | Path sandboxing in separate Phase C is error-prone — should be built into lib/paths.ts from Phase A | Ralph-Develop | High | Resolved | Merged sandbox into Phase A (task A4) and Phase B (all tools use it). Phase C narrowed to edge case verification only. |
| 4 | Plan missing milestones section | Ralph-Develop | Low | Open | Phase exit criteria serve this purpose adequately for MVP |
| 5 | Plan missing parallelization opportunities section | Ralph-Develop | Low | Open | Build is largely sequential; limited parallelization opportunity |
| 6 | Manifest uses "latest" for MCP SDK version | Ralph-Develop | Low | Open | Acceptable for MVP personal project |
| 7 | Phase 1 internal review complete | Ralph-Develop | - | Complete | 2 cycles: 3 High resolved in cycle 1, zero Critical/High in cycle 2 |
