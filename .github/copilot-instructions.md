# Copilot instructions for Naira Spend Tracker

The full rules are in `AGENTS.md` at the repository root. The essentials:

- Flutter 3.47+, Material 3, `ChangeNotifier` + `ListenableBuilder` for state.
- Money is an `int` of kobo. Use `formatNaira` and `parseNairaToKobo`.
- Add packages with `flutter pub add`, never by editing `pubspec.yaml` by hand.
- After every change: analyze, fix all issues, format, run `flutter test`.
- New widgets get widget tests; new logic gets unit tests.
- Interactive widgets need a `Key` and a tooltip or semantic label.
- Never change a test just to make it pass. Never commit secrets.
- Debug runs use Marionette; Flutter Driver only with
  `--dart-define=ENABLE_FLUTTER_DRIVER=true`. Never both.
