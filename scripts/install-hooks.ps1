$ErrorActionPreference = "Stop"

$repoRoot = git rev-parse --show-toplevel
if (-not $repoRoot) {
    throw "Run this script from inside the Git repository."
}

git -C $repoRoot config core.hooksPath .githooks

Write-Host "Configured Git hooks path: .githooks"
Write-Host "The secret-scanning pre-commit hook will run before commits."
