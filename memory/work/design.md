

---

## AI生图工作流 - DreamMaker (2026-04-01)

### 概述
**技能类型**: AI浏览器自动化 + 图像生成  
**工具**: DreamMaker (网易AI美术平台)  
**核心**: 自主操作浏览器完成AI生图全流程

---

### 标准工作流程

```
1. 打开DreamMaker 2D创作
   URL: https://dreammaker.netease.com/2d

2. 参数设置
   - 模型: nano-banana-pro（默认）
   - 分辨率: 4K（高品质）/ 2K / 1K
   - 图片比例: 横版21:9（游戏宣传图）
   - 生成张数: 4张

3. 参考图上传（可选）
   - 点击"参考原图"按钮
   - 选择本地图片

4. 提示词输入
   结构: 任务 + 核心要求 + 限制条件

5. 点击生成并监控进度

6. 迭代优化直到满意
```

---

### 提示词工程最佳实践

#### ✅ 黄金公式
```
任务类型 + 核心要求 + 具体细节 + 限制条件
```

#### ✅ 成功案例（去背景）
```
Remove background from reference image, make it transparent PNG.
Keep ALL design elements EXACTLY as reference image:
- Same font, size, layout
- Same decorative vines and thorns
- Same frost crystalline edges
Generate both:
1. "DIABLO IMMORTAL" 
2. "暗黑破坏神 不朽"
Only remove background. Nothing else changes.
```

#### ❌ 避免的坑
| 问题 | 解决方案 |
|------|----------|
| 提示词过于复杂 | 使用极简提示词 |
| 描述性语言过多 | 明确指令而非描述 |
| 没有明确限制 | 添加"不要做XX" |
| 多次迭代后失真 | 回到极简版本重新开始 |

#### 💡 核心原则
> **简单 > 复杂**  
> **明确指令 > 描述性语言**  
> **限制条件 > 创意发挥**

---

### 浏览器操作命令集

```javascript
// 导航
browser navigate url="https://dreammaker.netease.com/2d"

// 等待加载
browser act kind=wait timeMs=3000

// 点击元素（使用aria ref）
browser act kind=click ref=f7e424

// 输入文本
browser act kind=type ref=f7e424 text="..."

// 全选
browser act kind=press key="Control+a"

// 截图检查
browser screenshot

// 获取元素列表
browser snapshot refs=aria
```

---

### 实战记录：暗黑破坏神LOGO生成

**轮次**: 6轮迭代优化

| 轮次 | 问题 | 解决方案 |
|------|------|----------|
| 1 | 加了不必要的中国风元素 | 精确描述参考图元素 |
| 2 | LOGO设计变化 | 强调"只去背景，设计不变" |
| 3 | 中英文装饰不一致 | 要求"完全相同的装饰元素" |
| 4 | 冰柱/荆棘过于突出 | 添加"克制、对称、轻薄"限制 |
| 5 | 效果回退 | **极简提示词策略** |
| 6 | (最终版) | "Remove background... Only remove background" |

**最终有效提示词**:
```
Remove background from reference image, make it transparent PNG.
Keep ALL design elements EXACTLY as reference image.
Generate both: "DIABLO IMMORTAL" and "暗黑破坏神 不朽"
Only remove background. Nothing else changes.
```

---

### 自动化触发条件

**用户可直接说**：
- "用DreamMaker生成XX图"
- "打开DreamMaker做AI生图"
- "基于参考图生成透明背景LOGO"
- 任何包含 "DreamMaker" + "生成" 的指令

**系统自动执行**：
1. 检查浏览器状态
2. 导航到 DreamMaker 2D创作
3. 使用默认参数（4K/21:9/4张）
4. 等待用户输入
5. 执行生成流程

---

### 相关文件
- 参考图: `screenshots/3d4d988a228c4843a2ac68.png`
- 详细记录: `memory/2026-04-01.md`

---

_记录时间: 2026-04-01 | 技能状态: ✅ 已掌握并标准化_