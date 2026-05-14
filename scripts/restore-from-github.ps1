# OpenClaw 从 GitHub 恢复脚本
# 用于从家中电脑一键恢复所有内容（记忆、技能、配置等）

param(
    [string]$RepoUrl = "https://github.com/anya52800-code/yinzi-openclaw-backup.git",
    [string]$Branch = "master",
    [switch]$Force = $false
)

$OpenClawDir = "$env:USERPROFILE\.openclaw"
$WorkspaceDir = "$OpenClawDir\workspace"
$ScriptsDir = "$WorkspaceDir\scripts"

Write-Host "🔄 OpenClaw GitHub 恢复工具" -ForegroundColor Cyan
Write-Host "=========================="
Write-Host "仓库: $RepoUrl"
Write-Host "分支: $Branch"
Write-Host "目标: $WorkspaceDir"
Write-Host ""

# 检查网络连接
Write-Host "🌐 检查网络连接..." -ForegroundColor Cyan
$testConnection = Test-Connection -ComputerName github.com -Count 1 -Quiet
if (-not $testConnection) {
    Write-Host "❌ 错误: 无法连接到 GitHub，请检查网络!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ 网络连接正常" -ForegroundColor Green

# 检查 Git 是否安装
$gitPath = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitPath) {
    Write-Host "📥 Git 未安装，正在下载..." -ForegroundColor Yellow
    
    # 下载 Git for Windows
    $gitInstaller = "$env:TEMP\Git-2.42.0-64-bit.exe"
    try {
        Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.42.0.windows.2/Git-2.42.0.2-64-bit.exe" -OutFile $gitInstaller -UseBasicParsing
        Write-Host "🔧 安装 Git..." -ForegroundColor Cyan
        Start-Process -FilePath $gitInstaller -ArgumentList "/VERYSILENT /NORESTART" -Wait
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
        Write-Host "✅ Git 安装完成" -ForegroundColor Green
    } catch {
        Write-Host "❌ Git 安装失败，请手动安装: https://git-scm.com/download/win" -ForegroundColor Red
        exit 1
    }
}

# 检查 OpenClaw 是否安装
$openclawPath = Get-Command openclaw -ErrorAction SilentlyContinue
if (-not $openclawPath) {
    Write-Host "📥 OpenClaw 未安装，正在安装..." -ForegroundColor Yellow
    
    # 检查 Node.js
    $nodePath = Get-Command node -ErrorAction SilentlyContinue
    if (-not $nodePath) {
        Write-Host "📥 Node.js 未安装，请先安装 Node.js: https://nodejs.org/" -ForegroundColor Red
        exit 1
    }
    
    # 安装 OpenClaw
    npm install -g openclaw
    Write-Host "✅ OpenClaw 安装完成" -ForegroundColor Green
}

# 克隆或拉取仓库
if (Test-Path "$WorkspaceDir\.git") {
    Write-Host "📦 发现现有仓库，正在更新..." -ForegroundColor Cyan
    Set-Location $WorkspaceDir
    
    # 创建本地备份（以防万一）
    $backupStamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $localBackup = "$WorkspaceDir\backup\pre-restore-$backupStamp"
    New-Item -ItemType Directory -Path $localBackup -Force | Out-Null
    Copy-Item "$WorkspaceDir\*.md" $localBackup -Force -ErrorAction SilentlyContinue
    Copy-Item "$WorkspaceDir\memory" $localBackup -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item "$WorkspaceDir\skills" $localBackup -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✅ 已创建本地备份: $localBackup" -ForegroundColor Green
    
    # 拉取最新代码
    git fetch origin
    git reset --hard origin/$Branch
    Write-Host "✅ 仓库已更新到最新" -ForegroundColor Green
} else {
    Write-Host "📦 首次克隆仓库..." -ForegroundColor Cyan
    
    # 确认覆盖
    if ((Test-Path $WorkspaceDir) -and -not $Force) {
        Write-Host "⚠️  目标目录已存在且不是Git仓库!" -ForegroundColor Yellow
        $confirm = Read-Host "是否覆盖? (输入 'yes' 继续)"
        if ($confirm -ne "yes") {
            Write-Host "已取消。" -ForegroundColor Gray
            exit 0
        }
    }
    
    # 备份现有内容
    if (Test-Path $WorkspaceDir) {
        $backupStamp = Get-Date -Format "yyyyMMdd-HHmmss"
        $localBackup = "$env:TEMP\openclaw-backup-$backupStamp"
        Move-Item $WorkspaceDir $localBackup -Force
        Write-Host "✅ 已备份现有内容到: $localBackup" -ForegroundColor Green
    }
    
    # 克隆仓库
    git clone --branch $Branch $RepoUrl $WorkspaceDir
    Write-Host "✅ 仓库克隆完成" -ForegroundColor Green
}

Write-Host ""
Write-Host "📋 恢复内容清单:" -ForegroundColor Cyan
Write-Host "=========================="

# 检查恢复的内容
$contentItems = @(
    @{ Path = "$WorkspaceDir\MEMORY.md"; Name = "长期记忆" },
    @{ Path = "$WorkspaceDir\AGENTS.md"; Name = "Agent配置" },
    @{ Path = "$WorkspaceDir\SOUL.md"; Name = "人格设定" },
    @{ Path = "$WorkspaceDir\IDENTITY.md"; Name = "身份定义" },
    @{ Path = "$WorkspaceDir\USER.md"; Name = "用户配置" },
    @{ Path = "$WorkspaceDir\HEARTBEAT.md"; Name = "心跳配置" },
    @{ Path = "$WorkspaceDir\TOOLS.md"; Name = "工具配置" },
    @{ Path = "$WorkspaceDir\memory"; Name = "每日记忆目录" },
    @{ Path = "$WorkspaceDir\skills"; Name = "技能目录" },
    @{ Path = "$WorkspaceDir\scripts"; Name = "脚本目录" },
    @{ Path = "$WorkspaceDir\screenshots"; Name = "截图/产出目录" }
)

foreach ($item in $contentItems) {
    if (Test-Path $item.Path) {
        Write-Host "  ✅ $($item.Name)" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  $($item.Name) - 未找到" -ForegroundColor Yellow
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

# 询问是否启动
$startGateway = Read-Host "是否现在启动 OpenClaw Gateway? (y/n)"
if ($startGateway -eq "y" -or $startGateway -eq "Y") {
    Write-Host "🚀 启动 OpenClaw Gateway..." -ForegroundColor Cyan
    openclaw gateway start
}
