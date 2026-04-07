# 📦 每周归档旧记忆
# 执行时间: 每周五 21:00
# 归档策略: 保留最近7天，旧文件压缩存储

$date = Get-Date -Format "yyyy-MM-dd"
$year = Get-Date -Format "yyyy"
$week = (Get-Date).DayOfYear / 7 + 1
$weekNum = [math]::Floor($week).ToString().PadLeft(2, '0')
$archiveName = "weekly/$year-W$weekNum.zip"

$workspace = "$env:USERPROFILE\.openclaw\workspace"
Set-Location $workspace

Write-Host "📦 开始周归档: $archiveName" -ForegroundColor Cyan

# 1. 确保目录存在
New-Item -ItemType Directory -Path "$workspace\backup\weekly" -Force | Out-Null
New-Item -ItemType Directory -Path "$workspace\backup\monthly" -Force | Out-Null
New-Item -ItemType Directory -Path "$workspace\backup\quarterly" -Force | Out-Null

# 2. 获取7天前的日期
$cutoffDate = (Get-Date).AddDays(-7).ToString("yyyy-MM-dd")
Write-Host "📅 归档截止: $cutoffDate 之前的文件" -ForegroundColor Yellow

# 3. 获取旧记忆文件（不包括最近7天）
$oldFiles = Get-ChildItem "$workspace\memory" -Filter "*.md" | 
    Where-Object { 
        $_.Name -match "^\d{4}-\d{2}-\d{2}\.md$" -and 
        $_.Name.Replace(".md", "") -lt $cutoffDate 
    }

if ($oldFiles) {
    # 归档到压缩包
    $archivePath = "$workspace\backup\$archiveName"
    Compress-Archive -Path $oldFiles.FullName -DestinationPath $archivePath -Force
    
    $archiveSize = [math]::Round((Get-Item $archivePath).Length / 1KB, 2)
    Write-Host "✅ 归档 $($oldFiles.Count) 个文件" -ForegroundColor Green
    Write-Host "   位置: $archivePath" -ForegroundColor Gray
    Write-Host "   大小: $archiveSize KB" -ForegroundColor Gray
    
    # 记录归档清单
    $manifest = @"
# 周归档清单 - $year-W$weekNum

## 归档信息
- 归档时间: $date
- 包含文件: $($oldFiles.Count) 个
- 归档大小: $archiveSize KB

## 文件列表
$(($oldFiles | ForEach-Object { "- $($_.Name) ($([math]::Round($_.Length / 1KB, 2)) KB)" }) -join "`n")

## 存储位置
- 本地: $archivePath

---
*自动归档生成*
"@
    $manifest | Out-File -FilePath "$workspace\backup\weekly\$year-W$weekNum-manifest.md" -Encoding UTF8
    
} else {
    Write-Host "ℹ️ 无需要归档的旧文件" -ForegroundColor Yellow
}

# 4. 月度归档（每月1号执行）
if ((Get-Date).Day -eq 1) {
    $lastMonth = (Get-Date).AddMonths(-1).ToString("yyyy-MM")
    $monthlyArchive = "monthly/$lastMonth.zip"
    
    # 归档整个月的记忆
    $monthFiles = Get-ChildItem "$workspace\memory" -Filter "$lastMonth-*.md"
    if ($monthFiles) {
        $monthlyPath = "$workspace\backup\$monthlyArchive"
        Compress-Archive -Path $monthFiles.FullName -DestinationPath $monthlyPath -Force
        Write-Host "✅ 月度归档完成: $monthlyArchive" -ForegroundColor Green
    }
}

# 5. 清理超过90天的归档（可选）
$oldArchives = Get-ChildItem "$workspace\backup\weekly" -Filter "*.zip" | 
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-90) }

if ($oldArchives) {
    Write-Host "🧹 发现 $($oldArchives.Count) 个超过90天的归档" -ForegroundColor Yellow
    # 删除旧归档（取消注释以启用）
    # $oldArchives | Remove-Item -Force
    # Write-Host "🗑️ 已删除旧归档" -ForegroundColor Green
}

Write-Host "🎉 周归档完成!" -ForegroundColor Green
