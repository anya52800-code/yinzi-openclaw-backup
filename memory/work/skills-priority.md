# Skills 星级优先级体系

> 2026-03-26 建立 | 五星制评定与调用规则

---

## 星级定义

| 星级 | 含义 | 调用策略 |
|:----:|------|----------|
| ⭐⭐⭐⭐⭐ | **核心技能** | 高频使用，质量稳定，任务出现时**优先自动调用** |
| ⭐⭐⭐⭐ | **重要技能** | 特定场景必备，识别到场景时**主动推荐** |
| ⭐⭐⭐ | **辅助技能** | 按需使用，用户提及或明确需求时调用 |
| ⭐⭐ | **低频技能** | 特定 niche 场景，备用 |
| ⭐ | **边缘技能** | 极少使用，用户明确要求时才调用 |

---

## 全技能星级评定

### 🔍 搜索与信息获取

| 技能 | 星级 | 评定理由 |
|------|:----:|----------|
| **multi-search-engine** | ⭐⭐⭐⭐⭐ | 17引擎覆盖，零配置，高频刚需 |
| **arxiv-skill** | ⭐⭐⭐⭐ | 学术场景专用，研究必备 |
| summarize-1.0.0 | ⭐⭐⭐⭐ | 长文/视频摘要，效率工具 |
| answeroverflow-1.0.2 | ⭐⭐⭐ | Discord内容搜索， niche场景 |
| weather-1.0.0 | ⭐⭐ | 天气查询，低频 |

**调用规则**：
- 默认搜索 → 自动调用 multi-search-engine (5星)
- 论文/学术 → 主动推荐 arxiv-skill (4星)
- 长内容摘要 → 识别到URL时推荐 summarize (4星)

---

### 🎨 视觉与内容创作

| 技能 | 星级 | 评定理由 |
|------|:----:|----------|
| **nano-banana-2** | ⭐⭐⭐⭐⭐ | AI图像生成，高频，4K质量 |
| **image-editor** | ⭐⭐⭐⭐⭐ | 图片处理刚需，刚添加补短 |
| **ui-ux-pro-max** | ⭐⭐⭐⭐⭐ | UI/UX全能，设计→代码闭环 |
| **ui-responsive-layout** | ⭐⭐⭐⭐⭐ | 游戏UI适配，垂直领域专家 |
| canvas-design-2 | ⭐⭐⭐⭐ | 艺术设计，特定风格 |
| designer-1.0.0 | ⭐⭐⭐⭐ | 品牌设计，专业场景 |
| theme-factory | ⭐⭐⭐ | 配色工具，轻量辅助 |
| article-writer | ⭐⭐⭐⭐ | 中文写作，内容创作 |
| remotion-video-toolkit | ⭐⭐⭐⭐ | 视频制作，专业工具 |
| powerpoint-pptx | ⭐⭐⭐⭐ | PPT制作，职场必备 |

**调用规则**：
- AI生成图 → 自动调用 nano-banana-2 (5星)
- 截图处理/编辑 → 自动调用 image-editor (5星)
- UI设计 → 自动调用 ui-ux-pro-max (5星)
- 游戏UI适配 → 自动调用 ui-responsive-layout (5星)
- 写文章 → 识别到写作需求时调用 article-writer (4星)

---

### ⚡ 自动化与效率

| 技能 | 星级 | 评定理由 |
|------|:----:|----------|
| **automation-workflows** | ⭐⭐⭐⭐⭐ | 自动化策略，solopreneur核心 |
| **n8n-workflow-automation** | ⭐⭐⭐⭐ | n8n实现，落地工具 |
| **sql-connector** | ⭐⭐⭐⭐⭐ | 数据库连接，数据流核心 |
| **office-automation-skill** | ⭐⭐⭐⭐ | Office处理，高频办公 |
| file-organizer-zh | ⭐⭐⭐ | 文件整理，辅助工具 |

**调用规则**：
- "自动化"关键词 → 自动调用 automation-workflows (5星)
- 数据库/数据 → 自动调用 sql-connector (5星)
- Word/Excel处理 → 自动调用 office-automation (4星)

---

### 🔧 集成与工具

| 技能 | 星级 | 评定理由 |
|------|:----:|----------|
| **github-1.0.0** | ⭐⭐⭐⭐⭐ | GitHub操作，开发必备 |
| **ssh-connector** | ⭐⭐⭐⭐⭐ | 远程服务器，运维核心 |
| **docker-cli** | ⭐⭐⭐⭐⭐ | 容器化部署，DevOps必备 |
| **agent-browser** | ⭐⭐⭐⭐ | 浏览器自动化，测试/抓取 |
| gog-1.0.0 | ⭐⭐⭐ | Google工具，特定场景 |
| video-downloader | ⭐⭐⭐ | 视频下载，低频 |

**调用规则**：
- GitHub相关 → 自动调用 github-1.0.0 (5星)
- 服务器/SSH → 自动调用 ssh-connector (5星)
- Docker/容器 → 自动调用 docker-cli (5星)

---

### 🧠 Agent管理

| 技能 | 星级 | 评定理由 |
|------|:----:|----------|
| **memory-manager** | ⭐⭐⭐⭐⭐ | 记忆系统，核心基础设施 |
| **self-improving-agent-3.0.4** | ⭐⭐⭐⭐⭐ | 自我改进，持续优化 |
| **proactivity-1.0.1** | ⭐⭐⭐⭐ | 主动提醒，体验提升 |
| skill-creator-0.1.0 | ⭐⭐⭐ | 创建技能，低频 |
| skill-vetter-1.0.0 | ⭐⭐⭐ | 技能审查，低频 |
| find-skills-0.1.0 | ⭐⭐⭐ | 发现技能，低频 |
| auto-updater-1.0.0 | ⭐⭐⭐ | 自动更新，后台运行 |
| **usage-monitor** | ⭐⭐⭐⭐ | 成本监控，运营必备 |
| daily-reminder | ⭐⭐⭐⭐ | 每日系统自检，稳定保障 |
| health-reminder | ⭐⭐⭐ | 健康提醒，工作辅助 |

**调用规则**：
- 记忆相关 → 自动调用 memory-manager (5星)
- 学习/改进 → 自动调用 self-improving-agent (5星)
- 成本/用量 → 调用 usage-monitor (4星)
- 系统自检 → 调用 daily-reminder (4星)
- 健康提醒 → 识别工作场景时调用 health-reminder (3星)

---

### 📊 分析与研究

| 技能 | 星级 | 评定理由 |
|------|:----:|----------|
| **competitive-analysis-0.1.0** | ⭐⭐⭐⭐ | 竞品分析，商业研究 |
| **pandas-analyzer** | ⭐⭐⭐⭐⭐ | 数据分析，通用能力 |
| slack-gif-creator-anthropic-1.0.0 | ⭐⭐ | Slack GIF，特定平台 |

**调用规则**：
- 竞品/市场 → 自动调用 competitive-analysis (4星)
- 数据分析/CSV → 自动调用 pandas-analyzer (5星)

---

### 🛠️ 开发支持

| 技能 | 星级 | 评定理由 |
|------|:----:|----------|
| **chaquopy** | ⭐⭐⭐⭐⭐ | Python执行，基础能力 |
| **code-reviewer** | ⭐⭐⭐⭐⭐ | 代码审查，质量保证 |
| playwright-testing | ⭐⭐⭐⭐ | UI测试，验证工具 |
| awesome-claude-skills-1.0.0 | ⭐⭐ | 参考集合，低频查阅 |

**调用规则**：
- Python脚本 → 自动调用 chaquopy (5星)
- 代码审查/Review → 自动调用 code-reviewer (5星)
- UI测试 → 识别到测试需求时调用 playwright-testing (4星)

---

## 任务→技能自动映射规则

| 任务关键词/场景 | 自动触发技能 | 星级 |
|----------------|--------------|:----:|
| "搜索"/"查一下"/"找" | multi-search-engine | ⭐⭐⭐⭐⭐ |
| "论文"/"文献"/"研究" | arxiv-skill | ⭐⭐⭐⭐ |
| "生成图"/"画"/"AI图" | nano-banana-2 | ⭐⭐⭐⭐⭐ |
| "截图"/"图片处理"/"水印" | image-editor | ⭐⭐⭐⭐⭐ |
| "UI"/"界面"/"设计" | ui-ux-pro-max | ⭐⭐⭐⭐⭐ |
| "游戏UI"/"适配"/"分辨率" | ui-responsive-layout | ⭐⭐⭐⭐⭐ |
| "自动化"/"workflow" | automation-workflows | ⭐⭐⭐⭐⭐ |
| "数据库"/"SQL"/"查询" | sql-connector | ⭐⭐⭐⭐⭐ |
| "GitHub"/"PR"/"issue" | github-1.0.0 | ⭐⭐⭐⭐⭐ |
| "服务器"/"SSH"/"远程" | ssh-connector | ⭐⭐⭐⭐⭐ |
| "Docker"/"容器"/"部署" | docker-cli | ⭐⭐⭐⭐⭐ |
| "分析"/"数据"/"CSV" | pandas-analyzer | ⭐⭐⭐⭐⭐ |
| "代码审查"/"review" | code-reviewer | ⭐⭐⭐⭐⭐ |
| "Python"/"脚本" | chaquopy | ⭐⭐⭐⭐⭐ |
| "竞品"/"竞争对手" | competitive-analysis | ⭐⭐⭐⭐ |
| "写文章"/"内容" | article-writer | ⭐⭐⭐⭐ |
| "视频"/"动画" | remotion-video-toolkit | ⭐⭐⭐⭐ |
| "PPT"/"幻灯片" | powerpoint-pptx | ⭐⭐⭐⭐ |

---

## 自检机制

**每次任务处理时自动执行**：

1. **意图识别** → 提取任务关键词
2. **星级匹配** → 查找对应5星技能
3. **优先级排序** → 同场景多个技能时，星级高者优先
4. **主动推荐** → 4星技能识别到场景时主动建议
5. **质量保障** → 5星技能默认深度使用，确保输出质量

**自检问题**：
- 是否有5星技能可直接覆盖当前任务？
- 是否需要组合多个技能？
- 4星辅助技能是否需要推荐？
- 输出是否符合该技能的最佳实践？

---

## 五星技能清单（核心资产）

共 **24个** 5星核心技能：

1. multi-search-engine
2. nano-banana-2
3. image-editor
4. ui-ux-pro-max
5. ui-responsive-layout
6. automation-workflows
7. sql-connector
8. github-1.0.0
9. ssh-connector
10. docker-cli
11. memory-manager
12. self-improving-agent-3.0.4
13. usage-monitor
14. competitive-analysis
15. pandas-analyzer
16. chaquopy
17. code-reviewer
18. arxiv-skill / article-writer / remotion-video-toolkit / powerpoint-pptx (视场景)

**原则**：5星技能优先深度调用，确保质量；4星技能场景匹配时主动推荐；3星及以下按需使用。

---

### 新增5星技能（2026-04-07）
| 技能 | 分类 | 纳入理由 |
|------|------|----------|
| trend-analyzer | 创作前期 | 热点追踪，内容创作闭环起点 |
| content-strategy | 创作前期 | 策略制定，受众定位核心 |
| research-assistant | 创作前期 | 调研分析，信息整理基础 |

**原则**：5星技能优先深度调用，确保质量；4星技能场景匹配时主动推荐；3星及以下按需使用。

---
_星级体系更新完成：24个5星 + 17个4星 + 10个3星及以下 = 51个技能_