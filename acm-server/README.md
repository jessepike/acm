# ACM MCP Server

MCP server providing read-only access to ACM framework data — stage specs, review prompts, artifact templates, project health checks, capabilities registry, and knowledge base.

## Installation

```bash
cd acm-server
npm install
npm run build
```

Requires Node.js >= 18.

## Consumer Wiring

Add to your project's `.mcp.json`:

```json
{
  "mcpServers": {
    "acm": {
      "command": "node",
      "args": ["/path/to/acm/acm-server/build/index.js"],
      "env": {}
    }
  }
}
```

Optionally reference the companion skill in your `.claude/CLAUDE.md`:

```markdown
## ACM Integration
See: ~/code/_shared/acm/skills/acm-workflow/skill.md
```

## Environment Variables

| Variable | Default | Purpose |
|----------|---------|---------|
| `ACM_ROOT` | `~/code/_shared/acm` | Path to ACM framework root |
| `CAPABILITIES_REGISTRY_ROOT` | `~/code/_shared/capabilities-registry` | Path to capabilities registry |

## Tools (13)

| Category | Tool | Purpose |
|----------|------|---------|
| Orchestration | `get_stage` | Stage requirements and workflow |
| | `get_review_prompt` | Review prompt for stage/phase |
| | `get_transition_prompt` | Stage transition guidance with optional validation |
| Artifacts | `get_artifact_spec` | Artifact specification |
| | `get_artifact_stub` | Artifact starter template |
| Project | `get_project_type_guidance` | Project type classification guidance |
| | `check_project_structure` | Folder structure validation |
| | `check_project_health` | Structural health checks |
| Governance | `get_rules_spec` | Rules governance specification |
| | `get_context_spec` | CLAUDE.md context specification |
| Capabilities | `query_capabilities` | Search capabilities registry |
| | `get_capability_detail` | Full capability details |
| Knowledge | `query_knowledge` | Search knowledge base |

## Testing

```bash
npm test
```

59 tests across 9 test files covering all tools, libraries, and edge cases.

## Architecture

- **Transport:** stdio (JSON-RPC 2.0)
- **Read-only:** Never writes to any file
- **No network:** All data from local filesystem
- **Path sandboxing:** All path inputs validated against expected base directories
