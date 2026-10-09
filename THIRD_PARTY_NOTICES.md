# Third-party notices

This repository vendors agent skills and rules so the workshop works offline
and every attendee gets the same versions.

| Path | Source | Version | Licence |
| --- | --- | --- | --- |
| `.agents/skills/flutter-*`, `.agents/skills/dart-*` | [flutter/agent-plugins](https://github.com/flutter/agent-plugins) `skills/` | commit `0ef3972` (2026-09-30) | BSD-3-Clause, `third_party/licenses/flutter-agent-plugins-BSD-3-Clause.txt` |
| `.agent/rules/flutter-hot-reload.md`, `.cursor/rules/flutter-hot-reload.mdc` | [flutter/agent-plugins](https://github.com/flutter/agent-plugins) `rules/` | commit `0ef3972` | BSD-3-Clause |
| `.agents/skills/marionette-flutter-drive-app` | [leancodepl/marionette_mcp](https://github.com/leancodepl/marionette_mcp) `packages/marionette_flutter/skills/` | commit `1081d7f` (2026-10-05, v0.7.0) | Apache 2.0, `third_party/licenses/marionette-mcp-Apache-2.0.txt` |

Refresh them with:

```bash
npx skills add flutter/agent-plugins --skill '*' --agent universal --yes
npx skills add leancodepl/marionette_mcp --agent universal --yes
```

`.agents/skills/spend-tracker-definition-of-done` is original to this workshop.
