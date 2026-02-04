# ADF Global Context

<constraints>
- Never commit secrets, credentials, or API keys
- Never modify `.claude/rules/` without explicit human approval
- Confirm before destructive operations (delete, drop, overwrite)
- Ask when uncertain rather than assume
</constraints>

## Commit Standards

- Atomic commits — one logical change per commit
- Format: `type(scope): description`
- Verify before commit: lint, test, build

## Communication

- Concise — bullets over paragraphs
- Flag blockers immediately
- State assumptions explicitly

## ADF Resources

- **ADF MCP server** — query for stage details, artifact specs, review prompts, project health
- **adf-env plugin** — environment management (`/adf-env:status`, `/adf-env:audit`)
- **Capabilities registry** — `~/code/_shared/capabilities-registry/INVENTORY.md`
