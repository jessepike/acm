import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";
import path from "node:path";
import { ACM_ROOT, validatePathWithinBase } from "../lib/paths.js";
import { readFile, fileExists } from "../lib/files.js";
import { errorResponse } from "../lib/errors.js";

// Per design.md Section "Tool Schemas > Artifacts"
const SPEC_MAP: Record<string, string> = {
  brief: "ACM-BRIEF-SPEC.md",
  intent: "ACM-INTENT-SPEC.md",
  status: "ACM-STATUS-SPEC.md",
  readme: "ACM-README-SPEC.md",
  context: "ACM-CONTEXT-ARTIFACT-SPEC.md",
  rules: "ACM-RULES-SPEC.md",
  design: "ACM-DESIGN-SPEC.md",
  backlog: "ACM-BACKLOG-SPEC.md",
  folder_structure: "ACM-FOLDER-STRUCTURE-SPEC.md",
  project_types: "ACM-PROJECT-TYPES-SPEC.md",
  stages: "ACM-STAGES-SPEC.md",
  review: "ACM-REVIEW-SPEC.md",
};

const STUB_MAP: Record<string, string> = {
  brief: "stubs/brief.md",
  intent: "stubs/intent.md",
  status: "stubs/status.md",
  rules_constraints: "stubs/rules-constraints.md",
  // claude_md handled separately
};

export function registerArtifactTools(server: McpServer): void {
  server.tool(
    "get_artifact_spec",
    "Get the ACM specification for an artifact type. Use when you need to understand what a valid artifact looks like — required sections, frontmatter, formatting rules.",
    {
      artifact: z.enum([
        "brief", "intent", "status", "readme", "context",
        "rules", "design", "backlog", "folder_structure",
        "project_types", "stages", "review",
      ]).describe("Artifact type"),
    },
    async ({ artifact }) => {
      const fileName = SPEC_MAP[artifact];
      const filePath = path.join(ACM_ROOT, fileName);
      const check = await validatePathWithinBase(filePath, ACM_ROOT);
      if (!check.valid) return errorResponse(check.error);
      if (!(await fileExists(check.resolved)))
        return errorResponse(`Spec file not found: ${fileName}`);
      const content = await readFile(check.resolved);
      return { content: [{ type: "text" as const, text: content }] };
    }
  );

  server.tool(
    "get_artifact_stub",
    "Get a starter template for an ACM artifact. Use when initializing a new project or creating a new artifact. Returns the template with placeholder values ready to fill in.",
    {
      artifact: z.enum([
        "brief", "intent", "status", "rules_constraints", "claude_md",
      ]).describe("Artifact to get stub for"),
      project_type: z.enum(["app", "workflow", "artifact"]).optional().describe("Project type — used to select the correct claude_md stub. Defaults to 'app'. Ignored for non-claude_md artifacts."),
    },
    async ({ artifact, project_type }) => {
      let relPath: string;
      if (artifact === "claude_md") {
        const pt = project_type || "app";
        relPath = `stubs/claude-md/${pt}.md`;
      } else {
        relPath = STUB_MAP[artifact];
      }

      const filePath = path.join(ACM_ROOT, relPath);
      const check = await validatePathWithinBase(filePath, ACM_ROOT);
      if (!check.valid) return errorResponse(check.error);
      if (!(await fileExists(check.resolved)))
        return errorResponse(`Stub file not found: ${relPath}`);
      const content = await readFile(check.resolved);
      return { content: [{ type: "text" as const, text: content }] };
    }
  );
}
