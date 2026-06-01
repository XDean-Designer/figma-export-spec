# Deploy to GitHub Pages
# Run: gh auth login (if needed)
# Run: .\deploy-github.ps1

$ErrorActionPreference = "Stop"
$gh = if (Get-Command gh -ErrorAction SilentlyContinue) { "gh" } else { "$env:TEMP\gh-cli\bin\gh.exe" }

if ($gh -ne "gh" -and -not (Test-Path $gh)) {
  Write-Host "gh CLI not found."
  exit 1
}

& $gh auth status | Out-Null

$repoName = "figma-export-spec"
$owner = "XDean-Designer"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

if (-not (Test-Path ".git")) {
  git init -b main
}

git add index.html rules.json RULES.md .github .gitignore deploy-github.ps1 README.md 2>$null
git add -- "规范文本.txt" 2>$null
git diff --cached --quiet
if ($LASTEXITCODE -ne 0) {
  git commit -m "Publish Figma export fidelity spec for GitHub Pages"
}

try {
  $loggedIn = (& $gh api user -q .login 2>$null)
  if ($loggedIn) { $owner = $loggedIn }
} catch {}

$remote = "https://github.com/$owner/$repoName.git"
if (git remote get-url origin 2>$null) {
  git remote set-url origin $remote
} else {
  git remote add origin $remote
}

& $gh repo create "$owner/$repoName" --public --source=. --remote=origin --description "Figma export HTML fidelity spec" 2>$null
git push -u origin main

& $gh api "repos/$owner/$repoName/pages" -X POST -f build_type=workflow 2>$null

Write-Host ""
Write-Host "Repo: https://github.com/$owner/$repoName"
Write-Host "Pages: https://$($owner.ToLower()).github.io/$repoName/"
