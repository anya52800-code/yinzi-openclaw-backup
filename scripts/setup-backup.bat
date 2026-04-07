@echo off
chcp 65001 > nul
echo 🔧 OpenClaw 记忆备份系统 - 完整版设置
echo ==========================================
echo.

set WORKSPACE=%USERPROFILE%\.openclaw\workspace
set SCRIPTS=%WORKSPACE%\scripts

echo 📁 步骤1: 创建备份目录...
if not exist "%WORKSPACE%\backup" mkdir "%WORKSPACE%\backup"
if not exist "%WORKSPACE%\backup\weekly" mkdir "%WORKSPACE%\backup\weekly"
if not exist "%WORKSPACE%\backup\monthly" mkdir "%WORKSPACE%\backup\monthly"
if not exist "%WORKSPACE%\backup\quarterly" mkdir "%WORKSPACE%\backup\quarterly"
if not exist "%SCRIPTS%" mkdir "%SCRIPTS%"
echo ✅ 目录结构已创建
echo.

echo 📦 步骤2: 初始化Git版本控制...
cd /d "%WORKSPACE%"
if not exist ".git" (
    git init > nul 2>&1
    git config user.email "openclaw@local"
    git config user.name "OpenClaw Backup"
    echo ✅ Git仓库已初始化
) else (
    echo ℹ️ Git仓库已存在
)
echo.

echo 📝 步骤3: 配置.gitignore...
(
echo backup/
echo *.zip
echo screenshots/
echo *.tmp
echo .DS_Store
) > .gitignore
echo ✅ .gitignore 已配置
echo.

echo ⏰ 步骤4: 创建定时任务...

:: 每日备份任务 (21:00)
schtasks /query /tn "OpenClaw-Daily-Backup" > nul 2>&1
if %errorlevel% neq 0 (
    schtasks /create /tn "OpenClaw-Daily-Backup" /tr "powershell.exe -ExecutionPolicy Bypass -File %SCRIPTS%\backup-daily.ps1" /sc daily /st 21:00 /f > nul 2>&1
    echo ✅ 每日备份任务已创建 (21:00)
) else (
    echo ℹ️ 每日备份任务已存在
)

:: 每周归档任务 (周五 21:30)
schtasks /query /tn "OpenClaw-Weekly-Archive" > nul 2>&1
if %errorlevel% neq 0 (
    schtasks /create /tn "OpenClaw-Weekly-Archive" /tr "powershell.exe -ExecutionPolicy Bypass -File %SCRIPTS%\archive-weekly.ps1" /sc weekly /d FRI /st 21:30 /f > nul 2>&1
    echo ✅ 每周归档任务已创建 (周五 21:30)
) else (
    echo ℹ️ 每周归档任务已存在
)
echo.

echo 🔍 步骤5: 验证安装...
echo.
echo 目录结构:
dir /b "%WORKSPACE%\backup" 2> nul | findstr /n "^"
echo.
echo 脚本文件:
dir /b "%SCRIPTS%\*.ps1" 2> nul
echo.
echo 定时任务:
schtasks /query /tn "OpenClaw-*" /fo list 2> nul | findstr "任务名"
echo.

echo ==========================================
echo 🎉 设置完成!
echo.
echo 📋 后续操作:
echo 1. 配置Git远程仓库（可选）:
echo    git remote add origin ^<你的仓库地址^>
echo.
echo 2. 手动测试备份:
echo    powershell -File %SCRIPTS%\backup-daily.ps1
echo.
echo 3. 查看备份报告:
echo    %WORKSPACE%\backup\daily-report-YYYY-MM-DD.md
echo.
echo 4. 飞书云同步（已授权）:
echo    首次完整备份后将自动上传关键文件
echo.
pause
