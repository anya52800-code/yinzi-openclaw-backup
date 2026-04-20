# ⏰ 配置每日自动备份定时任务
# 以管理员身份运行此脚本
# 右键 → "使用 PowerShell 运行"

$taskName = "OpenClaw-DailyBackup"
$scriptPath = "$env:USERPROFILE\.openclaw\workspace\scripts\backup-daily.ps1"
$logPath = "$env:USERPROFILE\.openclaw\workspace\backup\task-log.txt"

Write-Host "⏰ OpenClaw 定时备份任务配置" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# 检查脚本是否存在
if (-not (Test-Path $scriptPath)) {
    Write-Host "❌ 脚本不存在: $scriptPath" -ForegroundColor Red
    exit 1
}

# 检查 PowerShell 执行策略
$policy = Get-ExecutionPolicy
if ($policy -eq "Restricted") {
    Write-Host "⚠️ PowerShell执行策略为Restricted，需要修改" -ForegroundColor Yellow
    Write-Host "   运行: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Gray
}

# 删除旧任务（如果存在）
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Host "🗑️ 删除旧任务: $taskName" -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# 创建触发器：每天 21:00
$trigger = New-ScheduledTaskTrigger -Daily -At "21:00"

# 创建操作：运行 PowerShell 执行脚本
$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`" >> `"$logPath`" 2>&1"

# 创建设置
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# 创建任务
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive

Write-Host "📝 创建定时任务: $taskName" -ForegroundColor Yellow
Write-Host "   执行时间: 每天 21:00" -ForegroundColor Gray
Write-Host "   执行脚本: $scriptPath" -ForegroundColor Gray
Write-Host "   日志文件: $logPath" -ForegroundColor Gray
Write-Host ""

try {
    Register-ScheduledTask -TaskName $taskName -Trigger $trigger -Action $action -Settings $settings -Principal $principal -Force | Out-Null
    Write-Host "✅ 定时任务创建成功!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 任务信息:" -ForegroundColor Cyan
    Write-Host "   名称: $taskName"
    Write-Host "   状态: $(Get-ScheduledTask -TaskName $taskName | Select-Object -ExpandProperty State)"
    Write-Host "   下次运行: $(Get-ScheduledTask -TaskName $taskName | Get-ScheduledTaskInfo | Select-Object -ExpandProperty NextRunTime)"
    Write-Host ""
    Write-Host "🔧 手动操作:" -ForegroundColor Cyan
    Write-Host "   立即测试: schtasks /run /tn $taskName"
    Write-Host "   查看任务: schtasks /query /tn $taskName /v"
    Write-Host "   删除任务: schtasks /delete /tn $taskName /f"
    Write-Host ""
    Write-Host "📁 备份输出:" -ForegroundColor Cyan
    Write-Host "   Git提交:   $env:USERPROFILE\.openclaw\workspace"
    Write-Host "   OneDrive:  $env:USERPROFILE\OneDrive\OpenClaw-Backup"
    Write-Host "   报告文件:  $env:USERPROFILE\.openclaw\workspace\backup\daily-report-YYYY-MM-DD.md"
    Write-Host ""
    
    # 立即运行一次测试
    $testNow = Read-Host "是否立即运行一次备份测试? (y/n)"
    if ($testNow -eq "y" -or $testNow -eq "Y") {
        Write-Host ""
        Write-Host "🚀 开始测试运行..." -ForegroundColor Green
        & $scriptPath
    }
    
} catch {
    Write-Host "❌ 创建任务失败: $_" -ForegroundColor Red
    Write-Host "   可能需要以管理员身份运行 PowerShell" -ForegroundColor Yellow
    exit 1
}

Read-Host "`n按 Enter 退出"
