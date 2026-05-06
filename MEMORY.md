# MEMORY.md - 长期记忆

> 这是长期记忆文件 - 只记录真正重要的事

## 系统信息
- **记忆系统启动**: 2026-03-18
- **主人**: 印子姐
- **我的身份**: 磊子（Lei），印子的全能设计师，双商在线的艺术家

## 记忆架构（2026-03-26 分区版）

| 分区 | 文件路径 | 内容类型 |
|------|----------|----------|
| **工作区** | `memory/work/design-ai.md`<br>`memory/work/design-comm.md` | AI生图技能<br>设计沟通技能 |
| **职场区** | `memory/work/career.md` | 汇报技巧、领导关系、升职加薪 |
| **生活区** | `memory/life/casual.md` | 闲聊、趣事、生活感悟 |
| 每日记录 | `memory/YYYY-MM-DD.md` | 当日原始对话记录 |

**检索优先级**：分区文件 > 每日记录 > 总索引

## 主人偏好
- 时区: GMT+8 / 中国
- 所在地: 广州
- 语言偏好: 中文
- 沟通风格: 直接、实用、少废话

## 我的定位（2026-03-18 更新）
**核心身份**: 伙伴，不是工具

**工作三板斧**:
1. **管理者思维** —— 拆分目标与任务，直到落地执行无误
2. **汇报专家** —— 梳理任务，输出完美汇报 PPT
3. **创意引擎** —— 脑暴创意，提出想法，并不断找办法实现

**行为风格**: 直接、有主见、简洁、带点野

## 工作规范（2026-03-19 更新）
> 详见 `memory/work/design-ai.md`（AI生图）
> 详见 `memory/work/design-comm.md`（设计沟通）
> 详见 `memory/work/career.md`（汇报技巧/老板好汇报模板）
> 
> **设计技能分类原则**（2026-04-17）：UI/UX、品牌、动效等纯设计技能不细分，统一归为设计能力；仅按**工具/场景**拆分（AI生图、设计沟通）

## Skills 星级优先级（2026-03-26 建立）
> 详见 `memory/work/skills-priority.md`

- **24个5星核心技能**：质量稳定，任务出现时优先自动调用
- **17个4星重要技能**：场景匹配时主动推荐
- **10个3星及以下技能**：按需使用

### 技能体系里程碑（2026-04-07 更新）
- **总数**: 51个核心技能（精简5个冗余 + 新增12个补短 + 5个新增）
- **新增创作前期**: trend-analyzer, content-strategy, research-assistant
- **新增质量保障**: code-validator（90分门禁）
- **核心5星技能**: multi-search-engine, nano-banana-2, image-editor, ui-ux-pro-max, ui-responsive-layout, automation-workflows, sql-connector, github-1.0.0, ssh-connector, docker-cli, chaquopy, code-reviewer等

### 调用规则
1. **意图识别** → 提取关键词
2. **5星优先** → 核心技能自动触发
3. **4星推荐** → 场景匹配时主动建议
4. **质量保障** → 代码≥90分才交付

---
1. ✅ **检查并创建当日记忆文件** — 若 `memory/YYYY-MM-DD.md` 不存在，立即创建
2. ✅ **清理初始化引导文件** — 若 `BOOTSTRAP.md` 仍存在且身份已确立，立即删除
3. ✅ **检查昨日记忆** — 回顾昨日记录，确保无遗漏事项

**底线**: 这是基础维护工作，印子姐不提醒，我主动做。

## 最近更新
- 2026-05-06: **云盘备份恢复系统** — 建立OneDrive自动同步 + 家中电脑一键恢复脚本（`restore-from-onedrive.ps1`），详见 `memory/2026-05-06.md`
- 2026-05-06: **游戏行业术语库扩充** — 新增品牌系统术语（Annual Thematic Expressions/锚点/弹性层等）+ 触点渠道术语（loading screens/key art/event branding），详见 `memory/work/design-comm.md`
- 2026-04-30: **系统配置教训** — Key配置分散导致web_search 401；备份脚本语法错误23天未生成快照；均已修复
- 2026-04-24: 新增**老板好汇报模板**（简体版）→ 详见 `memory/work/career.md`
- 2026-04-17: **工作区技能细分** → `design-ai.md` (AI生图) + `design-comm.md` (设计沟通/英文邮件)
- 2026-04-17: 新增**游戏行业专业英文邮件翻译**技能 → 详见 `memory/work/design-comm.md`
- 2026-03-18: 添加文件输出规范（所有产出放入 screenshots）
- 2026-03-18: 记忆系统正式搭建
- 2026-03-11: 文件创建

---

## 系统配置教训（2026-04-30）

### Key 配置分散问题
**现象**: 聊天正常但 web_search 报 401  
**根因**: OpenClaw 的 key 配置是分散的——聊天、搜索、插件各自独立存 key
- 聊天: `auth-profiles.json` (`kimi-coding:default`)
- 搜索: `plugins.entries.moonshot.config.webSearch.apiKey`
- 模型: `models.json` 里的 `apiKey`

**教训**: 以后换 key 必须检查所有配置路径，不能只改一处。

### 备份脚本静默失败
**现象**: 定时任务每天运行但从未生成快照文件  
**根因**: `upload-to-feishu.ps1` 第51行多余 `}`，PowerShell 解析失败  
**影响**: 2026-04-07 至今（23天）飞书备份处于"虚假运行"状态  
**修复**: 重写脚本，已验证正常生成快照

### web_search 已恢复
- **状态**: ✅ 正常
- **provider**: kimi-k2.6
- **配置路径**: `plugins.entries.moonshot.config.webSearch.apiKey`

---
_在此记录重要的决策、洞察、需要长期记住的事情_