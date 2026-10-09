# Naira Spend Tracker

The workshop app for **"Your Next Teammate is an Agent: AI-Powered Flutter
Development"**. A small expense tracker built so an AI agent can plan it,
build it, see it running, fix it and test it, using:

- the official **Dart and Flutter MCP server** and **Flutter agent plugin**
- **25 official Flutter and Dart skills**, plus the **Marionette** skill and a
  custom project skill
- **Marionette MCP** to tap, type, scroll and screenshot the running app
- the **Figma MCP server** to turn design tokens into a Flutter theme
- the **Firebase MCP server** for the take-home step
- rules files for every major agent host

## Start here

```bash
git checkout 00-start
bash tool/setup.sh        # Windows: powershell -ExecutionPolicy Bypass -File tool\setup.ps1
```

Then follow **[WORKSHOP.md](WORKSHOP.md)**.

## Branches

| Branch | State |
| --- | --- |
| `00-start` | Starter app with planted bugs, all agent tooling |
| `01-chart` | Weekly spending chart with fl_chart |
| `02-runtime-fix` | Overflow and deprecated API fixed |
| `03-tests` | Unit, widget and integration tests |
| `04-final` | Figma theme, accessibility fixes, responsive layout |
| `main` | Same as `04-final` |

## Layout

```text
lib/
  main.dart            picks the agent bridge (Marionette or Flutter Driver)
  app.dart             MaterialApp and theme
  data/                Expense model and in-memory repository
  logic/               ExpenseStore, money formatting, weekly aggregation
  ui/                  screens and widgets
docs/                  Figma setup and facilitator notes
tool/                  setup scripts
```

Credits: skills from [flutter/agent-plugins](https://github.com/flutter/agent-plugins)
(BSD-3-Clause) and [leancodepl/marionette_mcp](https://github.com/leancodepl/marionette_mcp)
(Apache 2.0). See `THIRD_PARTY_NOTICES.md`.
