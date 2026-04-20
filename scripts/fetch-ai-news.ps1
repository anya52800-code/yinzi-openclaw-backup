# AI前沿信息自动抓取脚本
# 每日执行，抓取 Anthropic/OpenAI/Google 最新动态
# 输出到 memory/work/ai-frontier-2026.md

$date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$frontierFile = "$env:USERPROFILE\.openclaw\workspace\memory\work\ai-frontier-2026.md"
$logFile = "$env:USERPROFILE\.openclaw\workspace\backup\ai-news-log.txt"

Write-Host "[$date] 开始抓取AI前沿信息..." -ForegroundColor Cyan

# 抓取 Anthropic 新闻
try {
    $anthropic = Invoke-WebRequest -Uri "https://www.anthropic.com/news" -UseBasicParsing -TimeoutSec 15
    $anthropicNews = @()
    if ($anthropic.Content -match 'news-item.*?<h3[^>]*>(.*?)</h3>') {
        $anthropicNews += $matches[1]
    }
    Write-Host "Anthropic: 抓取成功" -ForegroundColor Green
} catch {
    Write-Host "Anthropic: 抓取失败 - $_" -ForegroundColor Red
}

# 抓取 OpenAI 新闻
try {
    $openai = Invoke-WebRequest -Uri "https://openai.com/news" -UseBasicParsing -TimeoutSec 15
    $openaiNews = @()
    if ($openai.Content -match 'news-item.*?<h3[^>]*>(.*?)</h3>') {
        $openaiNews += $matches[1]
    }
    Write-Host "OpenAI: 抓取成功" -ForegroundColor Green
} catch {
    Write-Host "OpenAI: 抓取失败 - $_" -ForegroundColor Red
}

# 抓取 Google AI 博客
try {
    $google = Invoke-WebRequest -Uri "https://blog.google/technology/ai/" -UseBasicParsing -TimeoutSec 15
    $googleNews = @()
    if ($google.Content -match 'article-title.*?>(.*?)</') {
        $googleNews += $matches[1]
    }
    Write-Host "Google AI: 抓取成功" -ForegroundColor Green
} catch {
    Write-Host "Google AI: 抓取失败 - $_" -ForegroundColor Red
}

# 更新日志
$logEntry = @"
[$date] AI News Check
Anthropic: $($anthropicNews.Count) items
OpenAI: $($openaiNews.Count) items
Google: $($googleNews.Count) items
---
"@

Add-Content -Path $logFile -Value $logEntry

# 如果有新内容，更新 frontier 文件
if ($anthropicNews.Count -gt 0 -or $openaiNews.Count -gt 0 -or $googleNews.Count -gt 0) {
    $update = @"

## 自动更新 - $date

### Anthropic
$(($anthropicNews | ForEach-Object { "- $_" }) -join "`n")

### OpenAI
$(($openaiNews | ForEach-Object { "- $_" }) -join "`n")

### Google AI
$(($googleNews | ForEach-Object { "- $_" }) -join "`n")

"@
    
    Add-Content -Path $frontierFile -Value $update
    Write-Host "前沿信息已更新到 $frontierFile" -ForegroundColor Green
}

Write-Host "[$date] 抓取完成" -ForegroundColor Cyan
