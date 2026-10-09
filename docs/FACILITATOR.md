# Facilitator notes

Spoilers for the workshop. Attendees should not need this file.

## Planted issues in `00-start`

| # | Where | What | Found by | Fixed in |
| --- | --- | --- | --- | --- |
| 1 | `lib/ui/widgets/summary_header.dart` | A `Row` with fixed-width children overflows on any screen narrower than roughly 540 logical pixels (every phone in portrait) | Runtime errors via Marionette `get_logs` / screenshot, or Dart MCP `get_runtime_errors` + widget tree | `02-runtime-fix` |
| 2 | `lib/ui/widgets/summary_header.dart` | Deprecated `Color.withOpacity` | Analyzer (`deprecated_member_use`) | `02-runtime-fix` |
| 3 | `lib/ui/widgets/expense_tile.dart` | Delete `IconButton` has no tooltip or semantic label | a11y agent, or Marionette `get_interactive_elements` showing an element with no text | `04-final` |

Bug 1 does not show in the default 800x600 widget test surface, which is why
`flutter test` passes on `00-start`. That is a teaching point: green tests do
not mean a working UI on a real phone.

## What each checkpoint contains

- `01-chart`: `fl_chart` dependency, `lib/logic/weekly_spend.dart` (pure
  aggregation), `lib/ui/widgets/weekly_chart.dart`, chart on the home screen.
- `02-runtime-fix`: summary card reflows (amount on its own line, label
  `Flexible`), `withValues(alpha: ...)`.
- `03-tests`: `test/logic/money_test.dart`, `test/logic/weekly_spend_test.dart`,
  `test/logic/expense_store_test.dart`, `test/ui/add_expense_screen_test.dart`,
  `test/ui/home_screen_test.dart` (includes a 360 px phone-width overflow
  regression test), `integration_test/add_expense_flow_test.dart`.
- `04-final`: `design/tokens.json`, `lib/ui/theme/app_theme.dart`, tooltip and
  semantics fixes, chart `Semantics` summary, two-column layout at 840 px and
  wider, and `test/ui/accessibility_test.dart` using Flutter's built-in
  `labeledTapTargetGuideline` and `androidTapTargetGuideline`. Copy that test
  onto `03-tests` and run it to show the room a red test that the
  accessibility fix turns green.

## Timing (60 minutes)

| Time | Step |
| --- | --- |
| 0 to 4 | Hook: show the overflow on a phone, fix it with one prompt |
| 4 to 12 | Concepts |
| 12 to 20 | Step 0 together |
| 20 to 29 | Steps 1 and 2 |
| 29 to 38 | Step 3 |
| 38 to 46 | Step 4 |
| 46 to 50 | Step 6 (a11y) |
| 50 to 55 | Practices |
| 55 to 60 | Questions |

Step 5 (Figma) and step 7 (Firebase) are take-home unless you have a 90
minute slot. For the hook, use a separate clone on `00-start` so the room
still sees the bug in step 3.

## Before the day

- Create the Figma **Tokens** frame from `docs/FIGMA.md` and share a view link.
- Run every step yourself on the host you will demo, on the projector
  resolution.
- Record a screen capture of steps 1 to 4 as a fallback.
- Push this repo to GitHub with all branches: `git push --all origin`.
