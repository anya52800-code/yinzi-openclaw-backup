# 飞书云空间每日快照上传
# 每天19:05自动执行

$date = Get-Date -Format "yyyy-MM-dd"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$workspace = "$env:USERPROFILE\.openclaw\workspace"

Write-Host "============================================"
Write-Host "  飞书云空间每日快照 - $date"
Write-Host "============================================"
Write-Host "时间: $timestamp"
Write-Host ""

# 创建快照目录
$snapshotDir = "$workspace\backup\snapshot-$date"
New-Item -ItemType Directory -Path $snapshotDir -Force | Out-Null

Write-Host "步骤1: 复制文件到快照目录..."

# 复制核心文件
$coreFiles = @(
    "$workspace\MEMORY.md",
    "$workspace\AGENTS.md",
    "$workspace\HEARTBEAT.md",
    "$workspace\IDENTITY.md",
    "$workspace\SOUL.md",
    "$workspace\TOOLS.md",
    "$workspace\USER.md"
)

foreach ($file in $coreFiles) {
    if (Test-Path $file) {
        $name = Split-Path $file -Leaf
        Copy-Item $file "$snapshotDir\$name" -Force
        $size = [math]::Round((Get-Item $file).Length / 1KB, 2)
        Write-Host "  + $name ($size KB)"
    }
}

# 创建子目录
New-Item -ItemType Directory -Path "$snapshotDir\memory" -Force | Out-Null
New-Item -ItemType Directory -Path "$snapshotDir\memory\work" -Force | Out-Null
New-Item -ItemType Directory -Path "$snapshotDir\memory\life" -Force | Out-Null
New-Item -ItemType Directory -Path "$snapshotDir\skills" -Force | Out-Null

# 复制技能索引
if (Test-Path "$workspace\memory\work\skills-index.md") {
    Copy-Item "$workspace\memory\work\skills-index.md" "$snapshotDir\skills\" -Force
    Write-Host "  + skills/skills-index.md"
}
if (Test-Path "$workspace\memory\work\skills-priority.md") {
    Copy-Item "$workspace\memory\work\skills-priority.md" "$snapshotDir\skills\" -Force
    Write-Host "  + skills/skills-priority.md"
}

# 复制当日记忆
$todayMem = "$workspace\memory\$date.md"
if (Test-Path $todayMem) {
    Copy-Item $todayMem "$snapshotDir\memory\" -Force
    Write-Host "  + memory/$date.md"
}

# 复制记忆分区
Copy-Item "$workspace\memory\work\*" "$snapshotDir\memory\work\" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item "$workspace\memory\life\*" "$snapshotDir\memory\life\" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "  + memory/work/*"
Write-Host "  + memory/life/*"

# 生成清单
$gitInfo = git log -1 --pretty=format:"%h - %s" 2>$null
if ($gitInfo -eq $null) { $gitInfo = "N/A" }

$manifest = "每日快照清单 - $date`n生成时间: $timestamp`nGit提交: $gitInfo`n`n包含文件:`n"
foreach ($f in $coreFiles) {
    if (Test-Path $f) { $manifest += "- $(Split-Path $f -Leaf)`n" }
}
$manifest += "- memory/$date.md`n- memory/work/*`n- memory/life/*`n- skills/*"
$manifest | Out-File -FilePath "$snapshotDir\manifest.md" -Encoding UTF8

# 压缩
$zipPath = "$workspace\backup\snapshot-$date.zip"
Compress-Archive -Path "$snapshotDir\*" -DestinationPath $zipPath -Force
$zipSize = [math]::Round((Get-Item $zipPath).Length / 1KB, 2)

Write-Host ""
Write-Host "步骤2: 压缩快照..."
Write-Host "  文件: snapshot-$date.zip ($zipSize KB)"

# 生成上传清单
$list = "飞书上传清单 - $date`n================================`n"
$list += "`n目录: OpenClaw-Backup/2-daily-snapshot/$date/`n`n"
$list += "步骤:`n"
$list += "1. 创建文件夹: 2-daily-snapshot/$date/`n"
$list += "2. 解压 snapshot-$date.zip 到该文件夹`n"
$list += "3. 同时更新 1-latest/ 下的文件`n`n"
$list += "本地文件:`n"
$list += "- $zipPath`n"
$list += "- $snapshotDir\`n"

$listFile = "$workspace\backup\upload-list-$date.txt"
$list | Out-File -FilePath $listFile -Encoding UTF8

Write-Host ""
Write-Host "============================================"
Write-Host "  完成!"
Write-Host "============================================"
Write-Host ""
Write-Host "生成文件:"
Write-Host "  - snapshot-$date.zip ($zipSize KB)"
Write-Host "  - upload-list-$date.txt"
Write-Host ""
Write-Host "下一步: 手动上传到飞书云空间"
Write-Host "  路径: 2-daily-snapshot/$date/"
