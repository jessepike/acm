---
type: "tasks"
project: "ACM MCP Server"
version: "1.0"
status: "draft"
created: "2026-01-31"
plan_ref: "docs/plan.md"
---

# Tasks: ACM MCP Server

## Phase A: Scaffold & Infrastructure

- [ ] A1: Initialize project — `npm init`, create directory structure per design
- [ ] A2: Configure TypeScript — `tsconfig.json` with strict mode, ES2022 target, `build/` outDir
- [ ] A3: Install dependencies — `@modelcontextprotocol/sdk`, `zod`, `gray-matter`, `typescript`, `@types/node`
- [ ] A4: Implement `src/lib/paths.ts` — `normalizePath()` with tilde expansion, `ACM_ROOT`/`REGISTRY_ROOT` constants with env var fallback
- [ ] A5: Implement `src/lib/files.ts` — `readFile()`, `readFrontmatter()`, `fileExists()` utilities
- [ ] A6: Implement `src/lib/errors.ts` — `errorResponse()` helper returning MCP `isError` format
- [ ] A7: Implement `src/types.ts` — shared types (ToolResponse, etc.)
- [ ] A8: Implement `src/server.ts` — McpServer instance creation, tool registration imports
- [ ] A9: Implement `src/index.ts` — StdioServerTransport setup, server start
- [ ] A10: Verify scaffold — `npm run build` compiles clean, server starts and handles MCP initialize

## Phase B: Tool Implementation

- [ ] B1: Implement `src/tools/orchestration.ts` — `get_stage`, `get_review_prompt`, `get_transition_prompt` (with validate mode + brief resolution)
- [ ] B2: Implement `src/tools/artifacts.ts` — `get_artifact_spec`, `get_artifact_stub` (with project_type param for claude_md)
- [ ] B3: Implement `src/tools/project.ts` — `get_project_type_guidance`, `check_project_structure`, `check_project_health` (with spec version comments)
- [ ] B4: Implement `src/tools/governance.ts` — `get_rules_spec`, `get_context_spec`
- [ ] B5: Implement `src/tools/capabilities.ts` — `query_capabilities`, `get_capability_detail` (with capability_id regex)
- [ ] B6: Implement `src/tools/knowledge.ts` — `query_knowledge`
- [ ] B7: Wire all tool modules into `server.ts`, verify compile + 13 tools registered

## Phase C: Path Sandboxing & Validation

- [ ] C1: Implement sandbox enforcement in `lib/paths.ts` — `validatePathWithinBase()` using `fs.realpath()` + prefix check
- [ ] C2: Apply sandbox checks to all tool handlers that read files
- [ ] C3: Test edge cases — missing files, empty KB, no frontmatter, invalid capability_id, `..` in project_path

## Phase D: Companion Skill

- [ ] D1: Create `skills/acm-workflow/skill.md` — skill definition with triggers and workflow instructions
- [ ] D2: Create `skills/acm-workflow/references/tool-guide.md` — per-tool usage guide with common sequences

## Phase E: Integration & Verification

- [ ] E1: Full build verification — `npm run build` produces `build/index.js`
- [ ] E2: Smoke test — wire into consumer project, verify tool responses
- [ ] E3: Create `acm-server/README.md` — installation, usage, tool reference
- [ ] E4: Verify all success criteria from Brief
- [ ] E5: Update `.gitignore` — exclude `acm-server/node_modules/` and `acm-server/build/`
