@AGENTS.md

## Claude Code notes
- Skills live in `.agents/skills`; `tool/setup.sh` links them into `.claude/skills`.
- Project MCP servers are in `.mcp.json` (Dart, Marionette, Figma, Firebase).
  Approve them when Claude Code asks, then check with `/mcp`.
- Figma uses OAuth: run `/mcp`, pick **figma**, choose **Authenticate**.
- The official Flutter hot reload rule is in `.agent/rules/flutter-hot-reload.md`;
  follow it here too.
