#!/usr/bin/env python3
"""
每日记忆文件自动创建脚本
在每天0:01执行，静默创建当日的记忆文件
"""

import os
import sys
from datetime import datetime, timedelta

MEMORY_DIR = os.path.expanduser("~/.openclaw/workspace/memory")

def get_weekday_cn(date):
    """返回中文星期"""
    weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日']
    return weekdays[date.weekday()]

def create_daily_memory_file(date=None):
    """创建指定日期的记忆文件"""
    if date is None:
        date = datetime.now()
    
    date_str = date.strftime('%Y-%m-%d')
    weekday = get_weekday_cn(date)
    file_path = os.path.join(MEMORY_DIR, f"{date_str}.md")
    
    # 如果文件已存在，不覆盖
    if os.path.exists(file_path):
        return f"文件已存在: {file_path}"
    
    # 确保目录存在
    os.makedirs(MEMORY_DIR, exist_ok=True)
    
    # 记忆文件模板
    template = f"""# {date_str} 每日记录

## 今日概览
- **日期**: {date_str} {weekday}
- **主要工作**: 
- **会话数**: 

---

## 重要决策与变更

<!-- 记录重要的决策、变更、里程碑 -->

---

## 具体事件记录

<!-- 按时间段记录具体发生的事情 -->

---

## 关键洞察

<!-- 记录有价值的洞察、经验教训 -->

---

## 待办/后续

- [ ] 

---
_自动创建于 {datetime.now().strftime('%H:%M')}_
"""
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(template)
    
    return f"已创建: {file_path}"

if __name__ == "__main__":
    # 创建今日记忆文件
    result = create_daily_memory_file()
    print(result)
