# 部署 Figma 导出 HTML 还原度规范到 GitHub Pages
# 1. 运行: gh auth login  （若未登录）
# 2. 运行: .\deploy-github.ps1

$ErrorActionPreference = "Stop"
$gh = if (Get-Command gh -ErrorAction SilentlyContinue) { "gh" } else { "$env:TEMP\gh-cli\bin\gh.exe" }

if (-not (Test-Path $gh) -and $gh -notmatch "^gh$") {
  Write-Host "未找到 gh，请先安装 GitHub CLI。"
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

git add index.html rules.json RULES.md "规范文本.txt" .github .gitignore deploy-github.ps1 README.md 2>$null
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

& $gh repo create "$owner/$repoName" --public --source=. --remote=origin --description "Figma 设计稿导出 HTML 前的还原度检查规范（Cursor Agent + GitHub Pages）" 2>$null
git push -u origin main

& $gh api "repos/$owner/$repoName/pages" -X POST -f build_type=workflow 2>$null

Write-Host ""
Write-Host "仓库: https://github.com/$owner/$repoName"
Write-Host "Pages（部署完成后）: https://$($owner.ToLower()).github.io/$repoName/"
