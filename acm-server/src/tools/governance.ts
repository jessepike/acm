import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import path from "node:path";
import { ACM_ROOT, validatePathWithinBase } from "../lib/paths.js";
import { readFile, fileExists } from "../lib/files.js";
import { errorResponse } from "../lib/errors.js";

const CONTEXT_FILES: Record<string, string> = {
  global: "ACM-GLOBAL-CLAUDE-MD-SPEC.md",
  project: "ACM-PROJECT-CLAUDE-MD-SPEC.md",
};

export function registerGovernanceTools(server: McpServer): void {
  server.tool(
    "get_rules_spec",
    "Get the ACM rules governance specification. Use when setting up or auditing a project's .claude/rules/ directory — covers what rules are, categories, file organization, and lifecycle.",
    {},
    async () => {
      const filePath = path.join(ACM_ROOT, "ACM-RULES-SPEC.md");
      const check = await validatePathWithinBase(filePath, ACM_ROOT);
      if (!check.valid) return errorResponse(check.error);
      if (!(await fileExists(check.resolved)))
        return errorResponse("ACM-RULES-SPEC.md not found.");
      const content = await readFile(check.resolved);
      return { content: [{ type: "text" as const, text: content }] };
    }
  );

  server.tool(
    "get_context_spec",
    "Get the ACM specification for CLAUDE.md context artifacts. Use when creating or auditing CLAUDE.md files — covers required sections, what belongs in global vs project level.",
    {
      level: z.enum(["global", "project"]).describe("Which CLAUDE.md spec to return"),
    },
    async ({ level }) => {
      const fileName = CONTEXT_FILES[level];
      const filePath = path.join(ACM_ROOT, fileName);
      const check = await validatePathWithinBase(filePath, ACM_ROOT);
      if (!check.valid) return errorResponse(check.error);
      if (!(await fileExists(check.resolved)))
        return errorResponse(`${fileName} not found.`);
      const content = await readFile(check.resolved);
      return { content: [{ type: "text" as const, text: content }] };
    }
  );
}
