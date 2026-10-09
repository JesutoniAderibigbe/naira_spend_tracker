# Your Next Teammate is an Agent: hands-on guide

You will build the **Naira Spend Tracker** with an AI agent as your teammate.
The agent plans, writes code, runs the app, looks at it, fixes what it sees and
writes the tests. Your job is to lead: set the goal, review the plan, read the
diff.

Each step has a **checkpoint branch**. Fall behind? Run
`git checkout <branch>` and carry on from there. Nobody gets left behind.

| Step | What you build | Main tools | Checkpoint after |
| --- | --- | --- | --- |
| 0 | Setup and verify | Agent plugin, `AGENTS.md`, skills | `00-start` |
| 1 | Plan the chart | Dart MCP `pub_dev_search`, plan mode | |
| 2 | Build the chart | Dart MCP analyzer, pub tool | `01-chart` |
| 3 | Give the agent eyes | Marionette MCP or Flutter Driver | `02-runtime-fix` |
| 4 | Agent as tester | Test skills, Dart MCP test runner | `03-tests` |
| 5 | Design from Figma | Figma MCP | |
| 6 | Accessibility and responsive | a11y agent, responsive skill | `04-final` |
| 7 | Take-home: Firebase | Firebase MCP | |

---

## Step 0: Setup (do this before the workshop)

**You need:** Flutter stable (3.47 or later, Dart 3.9+), Node.js (optional),
one agent host, and a non-web run target (Android emulator, phone, or
desktop). Web cannot take Driver screenshots.

```bash
git clone <repo-url> naira_spend_tracker
cd naira_spend_tracker
git checkout 00-start
bash tool/setup.sh          # Windows: powershell -ExecutionPolicy Bypass -File tool\setup.ps1
flutter run                 # the app should open with a week of sample spending
```

`tool/setup.sh` generates the platform folders, fetches packages, installs
the Marionette MCP server, and points every agent at the skills in
`.agents/skills`.

### Install the official Flutter agent plugin in your host

| Host | Do this |
| --- | --- |
| Antigravity IDE | Settings → Customizations → Build with Google Plugins → Customize → Download **Dart and Flutter** |
| Antigravity CLI (`agy`) | Nothing extra: this repo ships `.agents/mcp_config.json` and `.agents/skills` |
| Claude Code | `claude plugin marketplace add flutter/agent-plugins` then `claude plugin install dart-flutter@dart-flutter`. This repo's `.mcp.json` adds Marionette, Figma and Firebase. |
| Cursor | `/add-plugin dart-flutter` in chat. This repo's `.cursor/mcp.json` adds the rest. |
| Codex | `codex plugin marketplace add flutter/agent-plugins` then `codex plugin add dart-flutter@dart-flutter`, plus `codex mcp add marionette -- marionette_mcp` |
| GitHub Copilot (VS Code) | Dart extension v3.116+ registers the Dart MCP server (`"dart.mcpServer": true` is already in `.vscode/settings.json`). `.vscode/mcp.json` adds the rest. |

### What is in this repo for the agent

```text
AGENTS.md                       project rules, loaded every session
CLAUDE.md                       Claude Code entry point (imports AGENTS.md)
.github/copilot-instructions.md Copilot rules
.cursor/rules/                  Cursor rules (+ official hot reload rule)
.agent/rules/                   Antigravity rules (official hot reload rule)
.agents/skills/                 27 skills: 25 official Flutter and Dart skills,
                                the Marionette skill, and our own
                                spend-tracker-definition-of-done
.mcp.json                       Claude Code MCP servers
.cursor/mcp.json                Cursor MCP servers
.vscode/mcp.json                Copilot MCP servers
.agents/mcp_config.json         Antigravity CLI MCP servers
```

### Verify

Open the project in your agent, approve the MCP servers, then ask:

> Summarize the Dart and Flutter tools and skills available in this project.

You should see the **dart** tools (analyze, pub, tests, runtime), the
**marionette** tools (connect, tap, take_screenshots), and the skills list.
No tools? Check `dart --version`, restart your host, and see
**Troubleshooting** at the end.

---

## Step 1: Plan before code

> Read AGENTS.md and the lib folder. I want a weekly spending chart under the summary card on the home screen, showing total spend per day for the last 7 days with short day labels (Mon, Tue...). Do not write code yet. Search pub.dev for a suitable chart package, then give me a short plan: the package and why, the files you will create or change, and how you will verify the result.

**Watch for:** a `pub_dev_search` tool call in the log. The plan should name
a verification step.

**Push back on one thing.** For example:

> Put the per-day aggregation in its own pure function in lib/logic so it can be unit tested without widgets. Update the plan.

You are the tech lead. Reviewing a 10-line plan is cheaper than reviewing a
400-line diff.

## Step 2: Build and self-correct

> Go ahead with the plan. Add the dependency with the pub tool, implement the chart, then run the analyzer and fix every issue before you stop.

**Watch for:** the agent adding the package with a tool instead of guessing
a version, and fixing its own analyzer errors.

**Bonus:** the analyzer also reports a deprecated `withOpacity` call that was
already in the starter code. Did the agent fix it? If not, ask why.

✅ Checkpoint: `git checkout 01-chart`

## Step 3: Give the agent eyes

There is a bug in the app you have not seen yet. On a phone-sized screen, the
summary card overflows. The agent is about to find it on its own.

### Option A: Marionette MCP (default, no flags)

```bash
flutter run -d <your-device>
```

Copy the VM service URI from the console (looks like
`ws://127.0.0.1:XXXXX/XXXX=/ws`), then:

> Connect to my running app with Marionette at <VM service URI>. Take a screenshot, then check for and fix any runtime and layout issues. Hot reload after each fix and take a new screenshot to confirm.

### Option B: Dart and Flutter MCP with Flutter Driver

```bash
flutter run -d <your-device> --dart-define=ENABLE_FLUTTER_DRIVER=true
```

> Connect to my running Flutter app and take a screenshot. Then check for and fix any static, runtime and layout issues. Hot reload after each fix and take a new screenshot to confirm.

(In VS Code use the **App + Flutter Driver (Dart MCP)** launch config.)

**Watch for:** the agent reading the `RenderFlex overflowed` error, inspecting
the widget tree, fixing the `Row` in `summary_header.dart`, hot reloading, and
screenshotting again. Compare before and after.

**Now drive it like a user:**

> Tap "Add expense", enter "Suya" as the title and 2500 as the amount, tap "Save expense", and screenshot the home screen. Check that the weekly total went up by ₦2,500.

With Flutter Driver on, the real keyboard is disabled; that is expected.

✅ Checkpoint: `git checkout 02-runtime-fix`

## Step 4: The agent as tester

> Add unit tests for lib/logic/money.dart and the weekly aggregation, and a widget test for the add expense form: an empty amount shows a validation error, and a valid entry is returned to the home screen and appears in the list. Run the tests and keep fixing until they pass. Do not change app behaviour to make a test pass without asking me.

Then turn what the agent clicked through in step 3 into a permanent test:

> Turn the add-expense flow you just drove into an integration test in integration_test/.

**Watch for:** the `flutter-add-widget-test`, `dart-add-unit-test` and
`flutter-add-integration-test` skills loading. The last sentence of the first
prompt is a guardrail against the classic agent cheat of editing code to fit
the test.

Finally:

> Use the spend-tracker-definition-of-done skill and report.

✅ Checkpoint: `git checkout 03-tests`

## Step 5: Design from Figma

Follow `docs/FIGMA.md` to get a Figma frame link (5 minutes, free account),
then:

**Claude Code, Cursor or Copilot (official Figma MCP, OAuth):**

> Using the Figma MCP server, read the colour and text styles from <figma link>. Create lib/ui/theme/app_theme.dart with a light and dark ThemeData built from those values, wire it into app.dart, and keep every colour coming from the theme. Show me the values you extracted before you write code.

**Antigravity or `agy` (community figma-flutter-mcp, needs `FIGMA_API_KEY`):**

> Setup flutter theme from <figma link> including Colors and Typography. Put it in lib/ui/theme/app_theme.dart and wire it into app.dart.

**Watch for:** the agent showing extracted values before writing code. Design
tokens from Figma, code from the agent, review from you.

## Step 6: Accessibility and responsive layout

**Antigravity only (official a11y agent):**

> @flutter_a11y_agent Audit the home screen for accessibility issues.

**Any host (Marionette + skills):**

> Audit the home screen for accessibility: every interactive element needs a label or tooltip and a 48x48 touch target, and the chart needs a text alternative. Use get_interactive_elements to find unlabelled controls. Fix what you find.

It should flag the delete `IconButton` with no tooltip. Lock the fix in:

> Add a widget test that runs Flutter's labeledTapTargetGuideline and androidTapTargetGuideline on the home screen.

Then:

> Make the home screen responsive: on screens wider than 840 logical pixels, show the summary and chart in a left column and the expense list in a right column. Keep the phone layout as it is.

**Watch for:** the `flutter-build-responsive-layout` skill. On desktop,
resize the window and ask the agent to screenshot both sizes.

✅ Checkpoint: `git checkout 04-final`

## Step 7: Take-home, Firebase

Create a free Firebase project, run `npx -y firebase-tools@latest login`, then:

> Using the Firebase MCP server, add Firebase to this app for my project <project-id> and store expenses in Cloud Firestore behind the existing ExpenseRepository interface. Write the Firestore security rules so each signed-in user can only read and write their own expenses, and show me the rules before deploying anything.

Read the security rules yourself. This is a decision you do not delegate.

---

## Prompt patterns worth stealing

| Pattern | Example ending |
| --- | --- |
| Plan first | "Do not write code yet. Give me a plan." |
| Definition of done | "...then run the analyzer and fix every issue before you stop." |
| Give it eyes | "Hot reload and take a screenshot to confirm." |
| Guardrail | "Do not change X to make Y pass without asking me." |
| Show your work | "Show me the values you extracted before you write code." |
| Close the loop | "Summarize the diff and list anything you are unsure about." |

## Troubleshooting

| Problem | Fix |
| --- | --- |
| No Dart tools in the agent | `dart --version` must be 3.9+. Restart the host. |
| Tools listed but "no roots" | Add `--force-roots-fallback` to the dart server args. |
| `marionette_mcp: command not found` | Add `~/.pub-cache/bin` (Windows: `%LOCALAPPDATA%\Pub\Cache\bin`) to PATH and restart your editor. |
| Marionette says version mismatch | `dart pub global activate marionette_mcp` again, then `flutter pub upgrade marionette_flutter`. |
| `Binding is already initialized` | You ran with Driver and Marionette together, or a test called `main()`. Pick one bridge. |
| Screenshot or tap fails with Driver | You are on web. Use an emulator or desktop. |
| Cannot type in the app yourself | Expected with Flutter Driver. Restart without the flag. |
| Figma MCP will not connect | Official server: run your host's MCP auth flow. Community server: export `FIGMA_API_KEY` before starting the agent. |
| The agent goes in circles | Stop it. `git checkout .` and re-prompt with one smaller goal. |
