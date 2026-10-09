# Naira Spend Tracker: guide for AI agents

This file is read by Antigravity, the Antigravity CLI, Codex, Cursor and other
agents at the start of every session. Claude Code reads it through `CLAUDE.md`.
Keep it short: every line here costs context in every session.

## Project
- Flutter stable (3.47+), Dart 3.9+, Material 3. Targets Android, iOS, desktop and web.
- State: built-in `ChangeNotifier` + `ListenableBuilder`. No third-party state
  management packages unless the user asks.
- Layers: `lib/data` (models, repository) → `lib/logic` (stores, pure
  functions) → `lib/ui` (screens, `lib/ui/widgets`). UI never talks to the
  repository directly.
- Money is an `int` of kobo (100 kobo = 1 naira). Never use `double` for money.
  Format with `formatNaira` and parse with `parseNairaToKobo` in
  `lib/logic/money.dart`.
- Dates come from `ExpenseStore.now()`, never `DateTime.now()` in logic, so
  tests can inject a fixed clock.

## Agent bridges (read before running the app)
- Debug runs use **Marionette** by default (`MarionetteBinding` in `lib/main.dart`).
- To use the Dart and Flutter MCP server's Flutter Driver tools instead, run
  `flutter run --dart-define=ENABLE_FLUTTER_DRIVER=true`.
- Only one binding can exist per process. Never initialize both, and never
  call `main()` from tests; pump `SpendTrackerApp` directly.

## Always
- Add or remove packages with the pub tool (`flutter pub add`). Never edit
  `pubspec.yaml` dependencies by hand, and say why a new package is needed.
- After every change: run the analyzer and fix all issues, then format.
- Every new widget gets a widget test. Every new logic class gets a unit test.
- Prefer `const` constructors and small widgets over long build methods.
- Use stable `Key`s (`Key('saveButton')`) on anything a test or agent taps.
- Interactive widgets need a tooltip or semantic label. Touch targets ≥ 48x48.
- When an app is running: hot reload after UI edits, then check runtime errors
  and take a screenshot to confirm.

## Never
- Never change a test to make it pass without telling the user why.
- Never touch `android/`, `ios/` or other native folders without asking.
- Never commit secrets, API keys or a filled-in `.env`.
- Never ship an agent bridge: Marionette and Flutter Driver stay behind the
  checks in `lib/main.dart`.

## Definition of done
Use the `spend-tracker-definition-of-done` skill before you say a task is finished.

## Commands
- `flutter analyze`
- `dart format .`
- `flutter test`
- `flutter test integration_test` (needs a device or desktop)
