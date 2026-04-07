# ☁️ 飞书云空间同步脚本
# 将关键记忆文件同步到飞书云空间
# 执行时机: 每日备份完成后

$date = Get-Date -Format "yyyy-MM-dd"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$workspace = "$env:USERPROFILE\.openclaw\workspace"

Write-Host "☁️ 开始飞书云空间同步: $timestamp" -ForegroundColor Cyan

# 待同步文件列表
$filesToSync = @(
    @{ Source = "$workspace\MEMORY.md"; TargetName = "MEMORY-$date.md" }
    @{ Source = "$workspace\AGENTS.md"; TargetName = "AGENTS-$date.md" }
    @{ Source = "$workspace\memory\work\skills-index.md"; TargetName = "skills-index-$date.md" }
    @{ Source = "$workspace\memory\work\skills-priority.md"; TargetName = "skills-priority-$date.md" }
)

# 生成当日记忆摘要
$dailyFiles = Get-ChildItem "$workspace\memory" -Filter "*.md" | 
    Where-Object { $_.Name -match "^\d{4}-\d{2}-\d{2}\.md$" } |
    Sort-Object Name -Descending |
    Select-Object -First 7

$summaryContent = @"
# 📚 记忆系统备份摘要

**备份时间**: $timestamp
**包含文件**: $($dailyFiles.Count) 个日记忆 + 4个核心文件

## 最近记忆
$(($dailyFiles | ForEach-Object { "- $($_.Name.Replace('.md',''))" }) -join "`n")

## 文件清单
- MEMORY.md - 长期记忆
- AGENTS.md - 系统配置
- skills-index.md - 技能索引
- skills-priority.md - 星级优先级

---
*自动同步摘要*
"@

$summaryPath = "$workspace\backup\sync-summary-$date.md"
$summaryContent | Out-File -FilePath $summaryPath -Encoding UTF8

Write-Host "📝 同步摘要已生成: $summaryPath" -ForegroundColor Green
Write-Host "" -ForegroundColor White
Write-Host "📤 需要上传的文件:" -ForegroundColor Yellow

foreach ($file in $filesToSync) {
    if (Test-Path $file.Source) {
        $size = [math]::Round((Get-Item $file.Source).Length / 1KB, 2)
        Write-Host "  ✓ $($file.TargetName) ($size KB)" -ForegroundColor Gray
    } else {
        Write-Host "  ✗ $($file.TargetName) - 文件不存在" -ForegroundColor Red
    }
}

Write-Host "" -ForegroundColor White
Write-Host "⚠️ 注意: 飞书云空间上传需要手动执行或通过API调用" -ForegroundColor Yellow
Write-Host "   建议路径: 我的空间/OpenClaw-Backup/" -ForegroundColor Gray
Write-Host "   手动上传命令: openclaw feishu drive upload" -ForegroundColor Gray

# 生成上传清单
$uploadList = @"
# 飞书云空间上传清单 - $date

## 目标路径
我的空间/OpenClaw-Backup/

## 待上传文件
$(($filesToSync | ForEach-Object { 
    if (Test-Path $_.Source) { 
        $size = [math]::Round((Get-Item $_.Source).Length / 1KB, 2)
        "- [ ] $($_.TargetName) ($size KB)"
    }
}) -join "`n")

## 压缩包（周/月归档）
$(if (Test-Path "$workspace\backup\weekly") { 
    Get-ChildItem "$workspace\backup\weekly" -Filter "*.zip" | 
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 3 |
    ForEach-Object { "- [ ] $($_.Name) ($([math]::Round($_.Length / 1KB, 2)) KB)" }
} else { "- 暂无归档文件" })

---
*生成时间: $timestamp*
"@

$uploadList | Out-File -FilePath "$workspace\backup\upload-list-$date.md" -Encoding UTF8

Write-Host "" -ForegroundColor White
Write-Host "✅ 飞书同步准备完成!" -ForegroundColor Green
Write-Host "   上传清单: backup\upload-list-$date.md" -ForegroundColor Gray
