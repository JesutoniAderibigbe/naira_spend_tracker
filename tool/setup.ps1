# One-time setup for the "Your Next Teammate is an Agent" workshop (Windows).
# Run from the repository root in PowerShell:  powershell -ExecutionPolicy Bypass -File tool\setup.ps1
$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

function Step($msg) { Write-Host "`n==> $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "[warn] $msg" -ForegroundColor Yellow }

Step 'Checking Flutter and Dart'
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  Write-Host 'Flutter is not on your PATH. Install it from https://docs.flutter.dev/install'
  exit 1
}
flutter --version
$dartLine = (dart --version 2>&1) | Out-String
if ($dartLine -match 'version: (\d+)\.(\d+)') {
  $major = [int]$Matches[1]; $minor = [int]$Matches[2]
  if ($major -lt 3 -or ($major -eq 3 -and $minor -lt 9)) {
    Write-Host "Dart $major.$minor found. The Dart and Flutter MCP server needs Dart 3.9 or later. Run: flutter upgrade"
    exit 1
  }
}

Step 'Generating platform folders (existing files are never overwritten)'
flutter create . --project-name naira_spend_tracker --org dev.gdgibadan --platforms=android,ios,web,macos,linux,windows

Step 'Fetching packages'
flutter pub get

Step 'Installing the Marionette MCP server'
dart pub global activate marionette_mcp
if (-not (Get-Command marionette_mcp -ErrorAction SilentlyContinue)) {
  Warn 'marionette_mcp is not on your PATH. Add %LOCALAPPDATA%\Pub\Cache\bin to PATH, then restart your terminal and editor.'
}

Step 'Copying skills so every agent finds them'
# Symlinks need admin rights on Windows, so we copy instead.
# Re-run this script after editing anything in .agents\skills.
foreach ($target in '.claude\skills', '.cursor\skills', '.github\skills') {
  if (Test-Path $target) { Remove-Item $target -Recurse -Force }
  New-Item -ItemType Directory -Force -Path (Split-Path $target) | Out-Null
  Copy-Item '.agents\skills' $target -Recurse
  Write-Host "copied .agents\skills -> $target"
}

Step 'Checking optional tools'
if (Get-Command node -ErrorAction SilentlyContinue) {
  Write-Host "Node $(node --version) found (Firebase and Figma MCP servers use npx)."
} else {
  Warn 'Node.js not found. Only needed for the Firebase and community Figma MCP servers.'
}

Step 'Done'
Write-Host @'
Next:
  1. Open this folder in your agent (Antigravity, Claude Code, Cursor, Codex or Copilot).
  2. Approve the MCP servers it finds in the project config.
  3. Ask: "Summarize the Dart and Flutter tools and skills available in this project."
  4. Follow WORKSHOP.md from step 1.
'@
