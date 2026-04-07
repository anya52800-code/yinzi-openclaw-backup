# 🚀 一键完整备份
# 顺序执行: Git备份 → 周归档检查 → 飞书同步准备

$date = Get-Date -Format "yyyy-MM-dd"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$workspace = "$env:USERPROFILE\.openclaw\workspace"
$scripts = "$workspace\scripts"

Write-Host @"
╔══════════════════════════════════════════════════════════╗
║        🧠 OpenClaw 记忆系统 - 完整备份流程               ║
╚══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host "开始时间: $timestamp" -ForegroundColor Gray
Write-Host ""

# 步骤1: 每日Git备份
Write-Host "▶ 步骤 1/3: 执行Git备份..." -ForegroundColor Yellow
& "$scripts\backup-daily.ps1"
if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $null) {
    Write-Host "❌ Git备份失败，中止流程" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 步骤2: 周归档（仅在周五执行或强制模式）
$isFriday = (Get-Date).DayOfWeek -eq "Friday"
$forceArchive = $args -contains "--archive"

if ($isFriday -or $forceArchive) {
    Write-Host "▶ 步骤 2/3: 执行周归档..." -ForegroundColor Yellow
    & "$scripts\archive-weekly.ps1"
    Write-Host ""
} else {
    Write-Host "▶ 步骤 2/3: 跳过周归档（非周五，加 --archive 强制执行）" -ForegroundColor Gray
    Write-Host ""
}

# 步骤3: 飞书同步准备
Write-Host "▶ 步骤 3/3: 准备飞书同步..." -ForegroundColor Yellow
& "$scripts\sync-feishu.ps1"
Write-Host ""

# 生成执行报告
$report = @"
# 🎉 完整备份执行报告 - $date

## 执行时间
- 开始: $timestamp
- 结束: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## 执行步骤
1. ✅ Git每日备份
2. $(if ($isFriday -or $forceArchive) { "✅" } else { "⏭️" }) 周归档 $(if (-not ($isFriday -or $forceArchive)) { "(跳过)" })
3. ✅ 飞书同步准备

## 输出文件
- Git提交: $(git log -1 --pretty=format:"%h - %s" 2>$null)
- 备份报告: backup/daily-report-$date.md
- 上传清单: backup/upload-list-$date.md
$(if (Test-Path "$workspace\backup\weekly\*.zip") { "- 周归档: backup/weekly/" })

## 健康状态
$(if (Test-Path "$workspace\memory\$date.md") { "✅" } else { "⚠️" }) 当日记忆文件
$(if (Test-Path "$workspace\MEMORY.md") { "✅" } else { "⚠️" }) 长期记忆
$(if (Test-Path "$workspace\memory\work\skills-index.md") { "✅" } else { "⚠️" }) 技能索引

---
*一键备份完成*
"@

$report | Out-File -FilePath "$workspace\backup\full-backup-report-$date.md" -Encoding UTF8

Write-Host @"
╔══════════════════════════════════════════════════════════╗
║                    ✅ 备份完成!                          ║
╚══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green

Write-Host "📄 完整报告: backup\full-backup-report-$date.md" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 后续操作:" -ForegroundColor White
Write-Host "   1. 检查Git状态: git log --oneline -5" -ForegroundColor Gray
Write-Host "   2. 查看备份报告: type backup\daily-report-$date.md" -ForegroundColor Gray
Write-Host "   3. 飞书云上传: 按 upload-list-$date.md 清单操作" -ForegroundColor Gray
