# OpenClaw Daily Backup Script
# Backs up memory files to Git and OneDrive
# Run time: Daily at 21:00

$date = Get-Date -Format "yyyy-MM-dd"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$workspace = "$env:USERPROFILE\.openclaw\workspace"
$oneDriveDir = "$env:USERPROFILE\OneDrive\OpenClaw-Backup"

try {
    Set-Location $workspace
    Write-Host "Starting daily backup: $timestamp" -ForegroundColor Cyan

    # Create directories
    New-Item -ItemType Directory -Path "$workspace\backup\weekly" -Force | Out-Null
    New-Item -ItemType Directory -Path "$workspace\backup\monthly" -Force | Out-Null
    New-Item -ItemType Directory -Path $oneDriveDir -Force | Out-Null

    # Git init if needed
    if (-not (Test-Path ".git")) {
        git init | Out-Null
        git config user.email "openclaw@local" | Out-Null
        git config user.name "OpenClaw Backup" | Out-Null
        Write-Host "Git repo initialized" -ForegroundColor Green
    }

    # Add all key files
    git add memory/ --all 2>$null
    git add MEMORY.md AGENTS.md HEARTBEAT.md TOOLS.md 2>$null
    git add SOUL.md IDENTITY.md USER.md 2>$null
    git add memory/work/ memory/life/ --all 2>$null
    git add scripts/*.ps1 2>$null

    # Commit if changes exist
    $status = git status --porcelain
    if ($status) {
        git commit -m "Memory backup: $date" | Out-Null
        Write-Host "Git commit done: $($status.Count) files" -ForegroundColor Green
    } else {
        Write-Host "No changes, skip commit" -ForegroundColor Yellow
    }

    # Generate report
    $fileCount = (Get-ChildItem memory/ -Filter "*.md" -Recurse -ErrorAction SilentlyContinue).Count
    
    $report = @"
# Backup Report - $date

## Time
- Executed: $timestamp
- Type: Daily auto backup

## Contents
- Daily memory files
- Work zone: memory/work/
- Life zone: memory/life/
- Long-term: MEMORY.md
- Config: AGENTS.md, HEARTBEAT.md, TOOLS.md
- Identity: SOUL.md, IDENTITY.md, USER.md
- Scripts: scripts/*.ps1

## Git Status
$(if ($status) { "- Changes: $($status.Count) files" } else { "- No changes" })
- Last commit: $(git log -1 --pretty=format:"%h - %s" 2>$null)

## Stats
- Memory files: $fileCount

## Health Check
- Today memory: $(if (Test-Path "memory/$date.md") { "OK" } else { "MISSING" })
- MEMORY.md: $(if (Test-Path "MEMORY.md") { "OK" } else { "MISSING" })
- Skills index: $(if (Test-Path "memory/work/skills-index.md") { "OK" } else { "MISSING" })

---
Auto-generated backup report
"@

    $report | Out-File -FilePath "$workspace\backup\daily-report-$date.md" -Encoding UTF8
    Write-Host "Backup report generated" -ForegroundColor Green

    # Upload to OneDrive
    Write-Host "Uploading to OneDrive..." -ForegroundColor Cyan
    $uploadFiles = @(
        @{ Source = "MEMORY.md"; Target = "MEMORY-$date.md" }
        @{ Source = "AGENTS.md"; Target = "AGENTS-$date.md" }
        @{ Source = "SOUL.md"; Target = "SOUL-$date.md" }
        @{ Source = "IDENTITY.md"; Target = "IDENTITY-$date.md" }
        @{ Source = "USER.md"; Target = "USER-$date.md" }
        @{ Source = "memory/work/skills-index.md"; Target = "skills-index-$date.md" }
        @{ Source = "memory/work/skills-priority.md"; Target = "skills-priority-$date.md" }
        @{ Source = "backup/daily-report-$date.md"; Target = "daily-report-$date.md" }
    )

    $uploadCount = 0
    foreach ($file in $uploadFiles) {
        $src = "$workspace\$($file.Source)"
        $dst = "$oneDriveDir\$($file.Target)"
        if (Test-Path $src) {
            Copy-Item -Path $src -Destination $dst -Force
            $uploadCount++
        }
    }

    # Upload last 7 daily memory files
    $dailyFiles = Get-ChildItem "$workspace\memory" -Filter "*.md" | 
        Where-Object { $_.Name -match "^\d{4}-\d{2}-\d{2}\.md$" } |
        Sort-Object Name -Descending |
        Select-Object -First 7

    foreach ($file in $dailyFiles) {
        Copy-Item -Path $file.FullName -Destination "$oneDriveDir\$($file.Name)" -Force
        $uploadCount++
    }

    Write-Host "OneDrive upload done: $uploadCount files" -ForegroundColor Green

    # Push to remote if configured
    $remote = git remote get-url origin 2>$null
    if ($remote) {
        git push origin main 2>$null | Out-Null
        Write-Host "Pushed to remote" -ForegroundColor Green
    }

    Write-Host "Daily backup complete! (Git + OneDrive)" -ForegroundColor Green
    
} catch {
    Write-Host "Backup failed: $_" -ForegroundColor Red
    exit 1
}
