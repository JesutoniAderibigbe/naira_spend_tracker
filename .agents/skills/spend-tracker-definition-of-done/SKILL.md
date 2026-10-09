---
name: spend-tracker-definition-of-done
description: The checklist an agent must complete before reporting any change to the Naira Spend Tracker as finished. Use at the end of every coding task in this repo, before writing a summary, and whenever the user asks "are you done?", "is it working?" or "verify this".
---

# Definition of done for Naira Spend Tracker

This is a project-specific skill written for the workshop. It shows how a team
turns its review checklist into something an agent runs on its own. Copy the
pattern for your own repos.

Work through every step in order. Do not skip a step because the change
"looks small". If a step cannot be done (for example, no app is running),
say so explicitly in your final summary instead of silently skipping it.

## 1. Static checks

1. Run static analysis with the Dart and Flutter MCP server (or `flutter analyze`).
2. Fix every error, warning and info in files you touched. Deprecated API
   warnings count: replace the API, do not add `// ignore`.
3. Format with the MCP format tool (or `dart format .`).

## 2. Tests

1. Run `flutter test`.
2. If you added a widget, confirm a widget test covers it. If you added logic
   in `lib/logic`, confirm a unit test covers it, including one edge case
   (empty list, zero, a date at midnight).
3. If a test fails, fix the code, not the test. If you believe the test is
   wrong, stop and explain why to the user before changing it.

## 3. Runtime check (when an app is running)

Pick whichever bridge the app was started with:

- **Marionette (default debug run):** `connect` with the VM service URI,
  `hot_reload`, `take_screenshots`, then `get_logs`.
- **Flutter Driver (`--dart-define=ENABLE_FLUTTER_DRIVER=true`):** connect
  through the Dart Tooling Daemon, hot reload, check runtime errors, take a
  screenshot.

Then:

1. Confirm there are no new runtime errors (overflow stripes, exceptions).
2. Exercise the changed flow once like a user would (for example: tap
   "Add expense", enter "Suya" and "2500", tap "Save expense").
3. Take a final screenshot.

## 4. Project rules

Check the diff against `AGENTS.md`:

- Money stays in integer kobo and is shown with `formatNaira`.
- No `DateTime.now()` inside `lib/logic`.
- New interactive widgets have a `Key` and a tooltip or semantic label.
- No new package was added without stating why.

## 5. Report

End with a short summary containing:

- What changed, file by file, in one line each.
- Results: analyzer (issue count), tests (passed/total), runtime check
  (done or why not).
- Anything you are unsure about or chose not to do.
