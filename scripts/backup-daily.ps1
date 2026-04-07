# 🔄 每日自动备份记忆系统
# 执行时间: 每天 21:00
# 备份内容: 记忆文件 + 技能索引 + 系统配置

$date = Get-Date -Format "yyyy-MM-dd"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$workspace = "$env:USERPROFILE\.openclaw\workspace"

try {
    Set-Location $workspace
    Write-Host "🔄 开始每日备份: $timestamp" -ForegroundColor Cyan

    # 1. 确保目录存在
    New-Item -ItemType Directory -Path "$workspace\backup\weekly" -Force | Out-Null
    New-Item -ItemType Directory -Path "$workspace\backup\monthly" -Force | Out-Null

    # 2. Git提交当前状态
    if (-not (Test-Path ".git")) {
        git init | Out-Null
        Write-Host "✅ Git仓库已初始化" -ForegroundColor Green
        
        # 配置用户信息（首次）
        git config user.email "openclaw@local" | Out-Null
        git config user.name "OpenClaw Backup" | Out-Null
    }

    # 3. 添加关键文件
    git add memory/ --all 2>$null
    git add MEMORY.md AGENTS.md HEARTBEAT.md TOOLS.md 2>$null
    git add memory/work/ memory/life/ --all 2>$null

    # 4. 提交（如果有变更）
    $status = git status --porcelain
    if ($status) {
        git commit -m "📝 记忆备份: $date `n`n- 自动备份每日记忆 `n- 更新技能索引" | Out-Null
        Write-Host "✅ Git提交完成: $($status.Count) 个文件" -ForegroundColor Green
    } else {
        Write-Host "ℹ️ 无变更，跳过提交" -ForegroundColor Yellow
    }

    # 5. 生成备份报告
    $memorySize = (Get-ChildItem memory/ -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $memorySizeMB = [math]::Round($memorySize / 1MB, 2)
    $fileCount = (Get-ChildItem memory/ -Filter "*.md" -Recurse -ErrorAction SilentlyContinue).Count

    $report = @"
# 📊 备份报告 - $date

## 备份时间
- 执行时间: $timestamp
- 备份类型: 每日自动备份

## 备份内容
- [x] 每日记忆文件
- [x] 工作分区: memory/work/
- [x] 生活分区: memory/life/
- [x] 长期记忆: MEMORY.md
- [x] 系统配置: AGENTS.md, HEARTBEAT.md, TOOLS.md
- [x] 技能索引: memory/work/skills-*.md

## Git状态
$(if ($status) { "- 提交变更: $($status.Count) 个文件" } else { "- 状态: 无变更" })
- 最新提交: $(git log -1 --pretty=format:"%h - %s" 2>$null)

## 存储统计
- 总大小: $memorySizeMB MB
- 记忆文件数: $fileCount 个

## 健康检查
- [x] 当日记忆文件: $(if (Test-Path "memory/$date.md") { "✅ 存在" } else { "❌ 缺失" })
- [x] MEMORY.md: $(if (Test-Path "MEMORY.md") { "✅ 存在" } else { "❌ 缺失" })
- [x] 技能索引: $(if (Test-Path "memory/work/skills-index.md") { "✅ 存在" } else { "❌ 缺失" })

---
*自动生成的备份报告*
"@

    $report | Out-File -FilePath "$workspace\backup\daily-report-$date.md" -Encoding UTF8
    Write-Host "✅ 备份报告已生成" -ForegroundColor Green

    # 6. 推送到远程（如果配置了）
    $remote = git remote get-url origin 2>$null
    if ($remote) {
        git push origin main 2>$null | Out-Null
        Write-Host "✅ 已推送到远程仓库" -ForegroundColor Green
    }

    Write-Host "🎉 每日备份完成!" -ForegroundColor Green
    
} catch {
    Write-Host "❌ 备份失败: $_" -ForegroundColor Red
    exit 1
}
