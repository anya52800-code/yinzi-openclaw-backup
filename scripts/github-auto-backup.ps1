# OpenClaw GitHub 自动备份脚本
# 用于将记忆、技能、配置等全量内容推送到GitHub

param(
    [string]$RepoUrl = "https://github.com/anya52800-code/yinzi-openclaw-backup.git",
    [string]$Branch = "master",
    [string]$CommitMessage = ""
)

$WorkspaceDir = "$env:USERPROFILE\.openclaw\workspace"
$GitDir = "$WorkspaceDir\.git"

Write-Host "🔄 OpenClaw GitHub 自动备份" -ForegroundColor Cyan
Write-Host "=========================="
Write-Host "仓库: $RepoUrl"
Write-Host "分支: $Branch"
Write-Host ""

# 检查Git是否安装
$gitPath = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitPath) {
    Write-Host "❌ Git 未安装，请先安装Git" -ForegroundColor Red
    exit 1
}

# 进入工作目录
Set-Location $WorkspaceDir

# 检查是否是Git仓库
if (-not (Test-Path $GitDir)) {
    Write-Host "📦 初始化Git仓库..." -ForegroundColor Cyan
    git init
    git remote add origin $RepoUrl
    Write-Host "✅ Git仓库初始化完成" -ForegroundColor Green
}

# 检查远程仓库
$remoteUrl = git remote get-url origin 2>$null
if (-not $remoteUrl) {
    Write-Host "📦 添加远程仓库..." -ForegroundColor Cyan
    git remote add origin $RepoUrl
}

# 获取当前时间
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$dateStr = Get-Date -Format "yyyy-MM-dd"

# 如果没有提供提交信息，自动生成
if ([string]::IsNullOrEmpty($CommitMessage)) {
    $CommitMessage = "Auto backup: $timestamp"
}

Write-Host "📝 添加文件到暂存区..." -ForegroundColor Cyan

# 添加核心文件
git add MEMORY.md
git add AGENTS.md
git add SOUL.md
git add IDENTITY.md
git add USER.md
git add HEARTBEAT.md
git add TOOLS.md

# 添加记忆文件
git add memory/

# 添加技能
git add skills/

# 添加脚本
git add scripts/

# 添加截图/产出
git add screenshots/

# 检查是否有变更
$status = git status --porcelain
if ([string]::IsNullOrEmpty($status)) {
    Write-Host "✅ 没有变更需要提交" -ForegroundColor Green
    exit 0
}

Write-Host "📝 提交变更..." -ForegroundColor Cyan
git commit -m "$CommitMessage"

Write-Host "📤 推送到GitHub..." -ForegroundColor Cyan
git push origin $Branch

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 备份完成! ($timestamp)" -ForegroundColor Green
    Write-Host "   仓库: $RepoUrl" -ForegroundColor Gray
} else {
    Write-Host "❌ 推送失败，请检查网络或仓库权限" -ForegroundColor Red
    exit 1
}
