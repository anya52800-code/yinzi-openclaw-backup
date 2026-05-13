# 磊子技能清单（2026-05-08）

> 家中电脑恢复时需要重新安装的技能列表
> 安装命令: `openclaw skills install <name>` 或 `openclaw skills search <keyword>`

---

## 5星核心技能（优先安装）

| 技能名 | 用途 | 安装命令 |
|--------|------|----------|
| multi-search-engine | 多搜索引擎 | `openclaw skills install multi-search-engine` |
| nano-banana-2 | AI生图 | `openclaw skills install nano-banana-2` |
| image-editor | 图片编辑 | `openclaw skills install image-editor` |
| ui-ux-pro-max | UI/UX设计 | `openclaw skills install ui-ux-pro-max` |
| ui-responsive-layout | 响应式布局 | `openclaw skills install ui-responsive-layout` |
| automation-workflows | 自动化工作流 | `openclaw skills install automation-workflows` |
| sql-connector | 数据库连接 | `openclaw skills install sql-connector` |
| github-1.0.0 | GitHub操作 | `openclaw skills install github-1.0.0` |
| ssh-connector | SSH连接 | `openclaw skills install ssh-connector` |
| docker-cli | Docker操作 | `openclaw skills install docker-cli` |
| code-reviewer | 代码审查 | `openclaw skills install code-reviewer` |
| code-validator | 代码验证 | `openclaw skills install code-validator` |
| trend-analyzer | 趋势分析 | `openclaw skills install trend-analyzer` |
| content-strategy | 内容策略 | `openclaw skills install content-strategy` |
| research-assistant | 研究助手 | `openclaw skills install research-assistant` |
| memory-manager | 记忆管理 | `openclaw skills install memory-manager` |
| skill-creator | 技能创建 | `openclaw skills install skill-creator` |
| find-skills | 技能搜索 | `openclaw skills install find-skills` |

---

## 4星重要技能（按需安装）

| 技能名 | 用途 | 安装命令 |
|--------|------|----------|
| agent-browser | 浏览器代理 | `openclaw skills install agent-browser` |
| answeroverflow | 问答搜索 | `openclaw skills install answeroverflow` |
| article-writer | 文章写作 | `openclaw skills install article-writer` |
| arxiv-skill | 论文搜索 | `openclaw skills install arxiv-skill` |
| browser-automation | 浏览器自动化 | `openclaw skills install browser-automation` |
| canvas-design | Canvas设计 | `openclaw skills install canvas-design` |
| competitive-analysis | 竞品分析 | `openclaw skills install competitive-analysis` |
| daily-reminder | 每日提醒 | `openclaw skills install daily-reminder` |
| design-system-creation | 设计系统 | `openclaw skills install design-system-creation` |
| Designer | 设计师助手 | `openclaw skills install Designer` |
| dreammaker-automation | 自动化 | `openclaw skills install dreammaker-automation` |
| feishu-doc | 飞书文档 | `openclaw skills install feishu-doc` |
| feishu-drive | 飞书云盘 | `openclaw skills install feishu-drive` |
| feishu-perm | 飞书权限 | `openclaw skills install feishu-perm` |
| feishu-wiki | 飞书知识库 | `openclaw skills install feishu-wiki` |
| file-organizer-zh | 文件整理 | `openclaw skills install file-organizer-zh` |
| Graphic Design | 平面设计 | `openclaw skills install Graphic Design` |
| health-reminder | 健康提醒 | `openclaw skills install health-reminder` |
| n8n-workflow-automation | n8n工作流 | `openclaw skills install n8n-workflow-automation` |
| office-automation | 办公自动化 | `openclaw skills install office-automation` |
| pandas-analyzer | 数据分析 | `openclaw skills install pandas-analyzer` |
| playwright-testing | 测试自动化 | `openclaw skills install playwright-testing` |
| proactivity | 主动助手 | `openclaw skills install proactivity` |
| remotion-video-toolkit | 视频制作 | `openclaw skills install remotion-video-toolkit` |
| self-improvement | 自我改进 | `openclaw skills install self-improvement` |
| skill-vetter | 技能审核 | `openclaw skills install skill-vetter` |
| slack-gif-creator | GIF制作 | `openclaw skills install slack-gif-creator` |
| theme-factory | 主题工厂 | `openclaw skills install theme-factory` |
| usage-monitor | 用量监控 | `openclaw skills install usage-monitor` |
| weather | 天气查询 | `openclaw skills install weather` |

---

## 3星及以下技能（按需安装）

| 技能名 | 用途 | 安装命令 |
|--------|------|----------|
| caveman | 简化表达 | `openclaw skills install caveman` |
| d2-diagram-creator | D2图表 | `openclaw skills install d2-diagram-creator` |
| diagnose | 诊断工具 | `openclaw skills install diagnose` |
| grill-me | 问答测试 | `openclaw skills install grill-me` |
| grill-with-docs | 文档测试 | `openclaw skills install grill-with-docs` |
| improve-codebase-architecture | 架构改进 | `openclaw skills install improve-codebase-architecture` |
| mermaid-diagrams | Mermaid图表 | `openclaw skills install mermaid-diagrams` |
| setup-matt-pocock-skills | 配置技能 | `openclaw skills install setup-matt-pocock-skills` |
| tdd | 测试驱动开发 | `openclaw skills install tdd` |
| to-issues | Issue管理 | `openclaw skills install to-issues` |
| to-prd | PRD生成 | `openclaw skills install to-prd` |
| triage | 分类处理 | `openclaw skills install triage` |
| web-content-fetcher | 网页抓取 | `openclaw skills install web-content-fetcher` |
| write-a-skill | 技能编写 | `openclaw skills install write-a-skill` |
| zoom-out | 全局视图 | `openclaw skills install zoom-out` |

---

## 快速安装脚本

```powershell
# 5星核心技能（必装）
$essential = @(
    "multi-search-engine",
    "nano-banana-2",
    "image-editor",
    "ui-ux-pro-max",
    "ui-responsive-layout",
    "automation-workflows",
    "sql-connector",
    "github-1.0.0",
    "ssh-connector",
    "docker-cli",
    "code-reviewer",
    "code-validator",
    "trend-analyzer",
    "content-strategy",
    "research-assistant",
    "memory-manager",
    "skill-creator",
    "find-skills"
)

foreach ($skill in $essential) {
    Write-Host "Installing $skill..."
    openclaw skills install $skill
}
```

---

## 家中电脑恢复步骤

1. **安装OpenClaw**: `npm install -g openclaw`
2. **恢复记忆文件**: 运行 `restore-agent.ps1`
3. **安装核心技能**: 运行上面的PowerShell脚本
4. **配置飞书**: 按 `feishu-bot-setup-guide.md` 申请新机器人
5. **启动服务**: `openclaw gateway start`

---

*清单生成时间: 2026-05-08*
*技能总数: 51个*
*5星核心: 18个 | 4星重要: 30个 | 3星及以下: 15个*
