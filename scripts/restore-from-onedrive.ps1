# OpenClaw 从 OneDrive 恢复脚本
# 用于从家中电脑恢复记忆和配置

param(
    [string]$SourceDir = "$env:USERPROFILE\OneDrive\OpenClaw-Backup",
    [switch]$Force = $false
)

$OpenClawDir = "$env:USERPROFILE\.openclaw"
$WorkspaceDir = "$OpenClawDir\workspace"

Write-Host "🔄 OpenClaw 恢复工具" -ForegroundColor Cyan
Write-Host "=========================="
Write-Host "源目录: $SourceDir"
Write-Host "目标: $WorkspaceDir"
Write-Host ""

# 检查源目录
if (-not (Test-Path $SourceDir)) {
    Write-Host "❌ 错误: OneDrive 备份目录不存在!" -ForegroundColor Red
    Write-Host "   请确保已登录 OneDrive 并同步完成。" -ForegroundColor Red
    exit 1
}

# 检查最新恢复包
$restorePackages = Get-ChildItem $SourceDir -Filter "openclaw-restore-*.zip" | Sort-Object Name -Descending
if (-not $restorePackages) {
    Write-Host "⚠️ 未找到恢复包，将尝试从分散文件恢复..." -ForegroundColor Yellow
    
    # 从分散文件恢复
    $latestMemory = Get-ChildItem $SourceDir -Filter "MEMORY-*.md" | Sort-Object Name -Descending | Select-Object -First 1
    if (-not $latestMemory) {
        Write-Host "❌ 错误: OneDrive 中没有找到备份文件!" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "找到最新备份: $($latestMemory.Name)"
    $restoreMode = "individual"
} else {
    $latestPackage = $restorePackages[0]
    Write-Host "✅ 找到恢复包: $($latestPackage.Name)" -ForegroundColor Green
    $restoreMode = "package"
}

# 确认恢复
if (-not $Force) {
    Write-Host ""
    Write-Host "⚠️  此操作将覆盖当前工作区的记忆文件!" -ForegroundColor Yellow
    $confirm = Read-Host "确认恢复? (输入 'yes' 继续)"
    if ($confirm -ne "yes") {
        Write-Host "已取消。" -ForegroundColor Gray
        exit 0
    }
}

# 创建备份（以防万一）
$backupStamp = Get-Date -Format "yyyyMMdd-HHmmss"
$localBackup = "$WorkspaceDir\backup\pre-restore-$backupStamp"
New-Item -ItemType Directory -Path $localBackup -Force | Out-Null
Copy-Item "$WorkspaceDir\*.md" $localBackup -Force -ErrorAction SilentlyContinue
Copy-Item "$WorkspaceDir\memory" $localBackup -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "✅ 已创建本地备份: $localBackup" -ForegroundColor Green

# 执行恢复
if ($restoreMode -eq "package") {
    # 从完整包恢复
    $tempExtract = "$env:TEMP\openclaw-restore-$(Get-Random)"
    New-Item -ItemType Directory -Path $tempExtract -Force | Out-Null
    
    Write-Host "📦 解压恢复包..." -ForegroundColor Cyan
    Expand-Archive -Path $latestPackage.FullName -DestinationPath $tempExtract -Force
    
    Write-Host "📝 恢复记忆文件..." -ForegroundColor Cyan
    Copy-Item "$tempExtract\*" $WorkspaceDir -Recurse -Force
    
    Remove-Item -Recurse -Force $tempExtract
} else {
    # 从分散文件恢复
    Write-Host "📝 从分散文件恢复..." -ForegroundColor Cyan
    
    # 恢复核心文件
    Get-ChildItem $SourceDir -Filter "MEMORY-*.md" | Sort-Object Name -Descending | Select-Object -First 1 | ForEach-Object {
        Copy-Item $_.FullName "$WorkspaceDir\MEMORY.md" -Force
        Write-Host "  ✓ MEMORY.md"
    }
    
    Get-ChildItem $SourceDir -Filter "AGENTS-*.md" | Sort-Object Name -Descending | Select-Object -First 1 | ForEach-Object {
        Copy-Item $_.FullName "$WorkspaceDir\AGENTS.md" -Force
        Write-Host "  ✓ AGENTS.md"
    }
    
    Get-ChildItem $SourceDir -Filter "SOUL-*.md" | Sort-Object Name -Descending | Select-Object -First 1 | ForEach-Object {
        Copy-Item $_.FullName "$WorkspaceDir\SOUL.md" -Force
        Write-Host "  ✓ SOUL.md"
    }
    
    Get-ChildItem $SourceDir -Filter "IDENTITY-*.md" | Sort-Object Name -Descending | Select-Object -First 1 | ForEach-Object {
        Copy-Item $_.FullName "$WorkspaceDir\IDENTITY.md" -Force
        Write-Host "  ✓ IDENTITY.md"
    }
    
    Get-ChildItem $SourceDir -Filter "USER-*.md" | Sort-Object Name -Descending | Select-Object -First 1 | ForEach-Object {
        Copy-Item $_.FullName "$WorkspaceDir\USER.md" -Force
        Write-Host "  ✓ USER.md"
    }
    
    # 恢复每日记忆文件
    Get-ChildItem $SourceDir -Filter "????-??-??.md" | ForEach-Object {
        Copy-Item $_.FullName "$WorkspaceDir\memory\$($_.Name)" -Force
        Write-Host "  ✓ memory/$($_.Name)"
    }
}

Write-Host ""
Write-Host "✅ 恢复完成!" -ForegroundColor Green
Write-Host ""
Write-Host "🚀 下一步:" -ForegroundColor Cyan
Write-Host "   1. 启动 OpenClaw Gateway: openclaw gateway start"
Write-Host "   2. 验证记忆: 问我'今天是什么日期'或'我是谁'"
Write-Host "   3. 检查文件: ls memory/"
Write-Host ""

# 显示恢复的文件列表
Write-Host "📋 已恢复文件:" -ForegroundColor Gray
Get-ChildItem $WorkspaceDir\*.md | ForEach-Object { Write-Host "   $($_.Name)" -ForegroundColor DarkGray }
