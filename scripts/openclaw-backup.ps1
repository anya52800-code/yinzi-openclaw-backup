# OpenClaw 一键备份脚本
# 用法：右键 → "使用 PowerShell 运行"，或在 PowerShell 中执行：
# & "$env:USERPROFILE\.openclaw\workspace\scripts\openclaw-backup.ps1"

param(
    [string]$OutputDir = "$env:USERPROFILE\Desktop",
    [string]$BackupName = "openclaw-backup"
)

$OpenClawDir = "$env:USERPROFILE\.openclaw"
$DateStamp = Get-Date -Format "yyyyMMdd-HHmm"
$ZipPath = Join-Path $OutputDir "$BackupName-$DateStamp.zip"

# 创建临时目录收集文件
$TempDir = Join-Path $env:TEMP "openclaw-backup-$DateStamp"
New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

Write-Host "🔧 OpenClaw 备份开始..." -ForegroundColor Cyan
Write-Host "源目录: $OpenClawDir"
Write-Host "输出:   $ZipPath"
Write-Host ""

# === 核心配置文件 ===
Write-Host "📄 复制 openclaw.json (主配置)..." -ForegroundColor Yellow
if (Test-Path "$OpenClawDir\openclaw.json") {
    Copy-Item "$OpenClawDir\openclaw.json" "$TempDir\openclaw.json" -Force
} else {
    Write-Host "⚠️ 未找到 openclaw.json" -ForegroundColor Red
}

# === 授权凭证 ===
Write-Host "🔐 复制 credentials (飞书 OAuth)..." -ForegroundColor Yellow
if (Test-Path "$OpenClawDir\credentials") {
    Copy-Item -Recurse "$OpenClawDir\credentials" "$TempDir\credentials" -Force
} else {
    Write-Host "⚠️ 未找到 credentials 目录" -ForegroundColor Red
}

# === 工作区（核心！包含 SOUL.md MEMORY.md 记忆 技能）===
Write-Host "📁 复制 workspace (核心工作区)..." -ForegroundColor Yellow
if (Test-Path "$OpenClawDir\workspace") {
    Copy-Item -Recurse "$OpenClawDir\workspace" "$TempDir\workspace" -Force
} else {
    Write-Host "⚠️ 未找到 workspace 目录" -ForegroundColor Red
}

# === 记忆数据库（可选，增强记忆连续性）===
Write-Host "🧠 复制 memory SQLite (可选)..." -ForegroundColor Yellow
if (Test-Path "$OpenClawDir\memory\main.sqlite") {
    Copy-Item "$OpenClawDir\memory\main.sqlite" "$TempDir\memory-main.sqlite" -Force
} else {
    Write-Host "⚠️ 未找到 memory SQLite，workspace 中的 .md 记忆文件已包含" -ForegroundColor DarkGray
}

# === 插件扩展 ===
Write-Host "🔌 复制 extensions (插件)..." -ForegroundColor Yellow
if (Test-Path "$OpenClawDir\extensions") {
    Copy-Item -Recurse "$OpenClawDir\extensions" "$TempDir\extensions" -Force
} else {
    Write-Host "⚠️ 未找到 extensions 目录" -ForegroundColor Red
}

# === 打包 ===
Write-Host ""
Write-Host "📦 打包压缩中..." -ForegroundColor Green
Compress-Archive -Path "$TempDir\*" -DestinationPath $ZipPath -Force

# 清理临时目录
Remove-Item -Recurse -Force $TempDir

# 输出结果
$ZipSize = (Get-Item $ZipPath).Length / 1MB
Write-Host ""
Write-Host "✅ 备份完成!" -ForegroundColor Green
Write-Host "   文件: $ZipPath"
Write-Host "   大小: $([math]::Round($ZipSize, 2)) MB"
Write-Host ""
Write-Host "📋 备份内容清单：" -ForegroundColor Cyan
Write-Host "   • openclaw.json     - 主配置（API key、飞书、模型、端口）"
Write-Host "   • credentials/      - 飞书 OAuth 授权凭证"
Write-Host "   • workspace/        - SOUL.md、MEMORY.md、记忆、技能、脚本"
Write-Host "   • memory-main.sqlite- 内置记忆数据库（可选）"
Write-Host "   • extensions/       - openclaw-lark 等插件"
Write-Host ""
Write-Host "🚀 下一步（家里电脑）：" -ForegroundColor Cyan
Write-Host "   1. npm install -g openclaw"
Write-Host "   2. 解压此 zip 到 %USERPROFILE%\.openclaw\"
Write-Host "   3. openclaw plugins install openclaw-lark"
Write-Host "   4. openclaw auth feishu"
Write-Host "   5. openclaw gateway start"
Write-Host ""
Write-Host "⚠️ 注意：同一飞书 Bot 同一时间只能连一台电脑。"
Write-Host "   离开公司前执行: openclaw gateway stop"
Write-Host "   到家后执行:      openclaw gateway start"
Write-Host ""

# 尝试打开文件夹
if (Test-Path $OutputDir) {
    Start-Process explorer.exe -ArgumentList "/select,$ZipPath"
}

Read-Host "按 Enter 退出"
