#!/usr/bin/env bash
# One-time setup for the "Your Next Teammate is an Agent" workshop.
# Run from the repository root:  bash tool/setup.sh
set -euo pipefail

cd "$(dirname "$0")/.."

step() { printf '\n\033[1;32m==> %s\033[0m\n' "$1"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$1"; }

step "Checking Flutter and Dart"
command -v flutter >/dev/null || { echo "Flutter is not on your PATH. Install it from https://docs.flutter.dev/install"; exit 1; }
flutter --version
dart_version="$(dart --version 2>&1 | sed -E 's/.*version: ([0-9]+)\.([0-9]+).*/\1.\2/')"
major="${dart_version%%.*}"; minor="${dart_version##*.}"
if [ "$major" -lt 3 ] || { [ "$major" -eq 3 ] && [ "$minor" -lt 9 ]; }; then
  echo "Dart $dart_version found. The Dart and Flutter MCP server needs Dart 3.9 or later. Run: flutter upgrade"
  exit 1
fi

step "Generating platform folders (existing files are never overwritten)"
flutter create . --project-name naira_spend_tracker --org dev.gdgibadan \
  --platforms=android,ios,web,macos,linux,windows

step "Fetching packages"
flutter pub get

step "Installing the Marionette MCP server"
dart pub global activate marionette_mcp
if ! command -v marionette_mcp >/dev/null; then
  warn "marionette_mcp is not on your PATH. Add \"\$HOME/.pub-cache/bin\" to PATH, then restart your terminal and editor."
fi

step "Linking skills so every agent finds them"
# .agents/skills is the source of truth. Claude Code, Cursor and Copilot also
# look in their own folders, so we link those to the same place.
for target in .claude/skills .cursor/skills .github/skills; do
  mkdir -p "$(dirname "$target")"
  if [ -L "$target" ] || [ ! -e "$target" ]; then
    rm -f "$target"
    ln -s "../.agents/skills" "$target"
    echo "linked $target -> .agents/skills"
  else
    warn "$target already exists and is not a link; left it alone."
  fi
done

step "Checking optional tools"
command -v node >/dev/null && echo "Node $(node --version) found (Firebase and Figma MCP servers use npx)." \
  || warn "Node.js not found. Only needed for the Firebase and community Figma MCP servers."

step "Done"
cat <<'EOT'
Next:
  1. Open this folder in your agent (Antigravity, Claude Code, Cursor, Codex or Copilot).
  2. Approve the MCP servers it finds in the project config.
  3. Ask: "Summarize the Dart and Flutter tools and skills available in this project."
  4. Follow WORKSHOP.md from step 1.

Refresh the official skills later with:
  npx skills add flutter/agent-plugins --skill '*' --agent universal --yes
  npx skills add leancodepl/marionette_mcp --agent universal --yes
EOT
