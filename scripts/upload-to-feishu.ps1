# ☁️ 飞书云空间上传脚本
# 将本地备份同步到飞书云空间
# 使用: .\scripts\upload-to-feishu.ps1

$date = Get-Date -Format "yyyy-MM-dd"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$workspace = "$env:USERPROFILE\.openclaw\workspace"

Write-Host @"
╔══════════════════════════════════════════════════════════╗
║        ☁️ 飞书云空间 - 记忆系统同步                      ║
╚══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host "同步时间: $timestamp" -ForegroundColor Gray
Write-Host ""

# 检查必要文件
$requiredFiles = @(
    "$workspace\MEMORY.md",
    "$workspace\AGENTS.md",
    "$workspace\HEARTBEAT.md",
    "$workspace\memory\work\skills-index.md",
    "$workspace\memory\work\skills-priority.md"
)

Write-Host "📋 检查待上传文件..." -ForegroundColor Yellow
$missingFiles = @()
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        $size = [math]::Round((Get-Item $file).Length / 1KB, 2)
        Write-Host "  ✅ $(Split-Path $file -Leaf) ($size KB)" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $(Split-Path $file -Leaf) - 缺失" -ForegroundColor Red
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Host ""
    Write-Host "⚠️ 有 $($missingFiles.Count) 个文件缺失，请检查后再试" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "📤 准备上传到飞书云空间..." -ForegroundColor Yellow
Write-Host ""

# 生成上传批次文件（供手动或API使用）
$uploadBatch = @"
# 飞书云空间上传批次 - $date
# 生成时间: $timestamp
# 
# 使用方法:
# 1. 打开飞书云空间: https://www.feishu.cn/drive/
# 2. 创建文件夹: OpenClaw-Backup
# 3. 按以下结构上传文件

## 📁 目标路径: OpenClaw-Backup/1-memory-current/

$(foreach ($file in $requiredFiles) {
    $name = Split-Path $file -Leaf
    $targetName = if ($name -match "^\d{4}-\d{2}-\d{2}\.md$") { $name } else { "$name" }
    "UPLOAD: $file -> 1-memory-current/$targetName"
})

## 📁 目标路径: OpenClaw-Backup/2-archive-weekly/
$(if (Test-Path "$workspace\backup\weekly") {
    Get-ChildItem "$workspace\backup\weekly" -Filter "*.zip" |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 3 |
    ForEach-Object { "UPLOAD: $($_.FullName) -> 2-archive-weekly/$($_.Name)" }
} else { "# 暂无归档文件" })

## 📁 目标路径: OpenClaw-Backup/4-reports/
$(if (Test-Path "$workspace\backup") {
    Get-ChildItem "$workspace\backup" -Filter "daily-report-*.md" |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 7 |
    ForEach-Object { "UPLOAD: $($_.FullName) -> 4-reports/$($_.Name)" }
} else { "# 暂无报告" })

## 📄 README
UPLOAD: $workspace\backup\cloud-readme.md -> README.md

---
*此文件由 upload-to-feishu.ps1 自动生成*
"@

$batchFile = "$workspace\backup\feishu-upload-batch-$date.txt"
$uploadBatch | Out-File -FilePath $batchFile -Encoding UTF8

Write-Host "✅ 上传批次文件已生成: $batchFile" -ForegroundColor Green
Write-Host ""

# 尝试使用OpenClaw工具自动上传（需要cloud技能）
Write-Host "🔍 检查自动上传能力..." -ForegroundColor Yellow

# 创建上传清单摘要
$summary = @"
# 飞书云空间同步摘要 - $date

## 待上传文件 ($($requiredFiles.Count) 个核心文件)
$(foreach ($file in $requiredFiles) {
    $name = Split-Path $file -Leaf
    $size = [math]::Round((Get-Item $file).Length / 1KB, 2)
    "- [ ] $name ($size KB)"
})

## 步骤
1. 打开飞书云空间
2. 创建文件夹: OpenClaw-Backup
3. 按批次文件上传

## 批次文件位置
$batchFile

---
生成时间: $timestamp
"@

$summary | Out-File -FilePath "$workspace\backup\feishu-sync-summary-$date.md" -Encoding UTF8

Write-Host @"
╔══════════════════════════════════════════════════════════╗
║              ✅ 同步准备完成!                            ║
╚══════════════════════════════════════════════════════════╝

📄 批次文件: backup\feishu-upload-batch-$date.txt
📊 摘要文件: backup\feishu-sync-summary-$date.md

💡 手动上传步骤:
   1. 打开飞书云空间
   2. 新建文件夹: OpenClaw-Backup
   3. 按批次文件清单上传

⚡ 或使用命令行:
   openclaw feishu drive upload --folder "OpenClaw-Backup"

"@ -ForegroundColor Green
