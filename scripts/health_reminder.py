#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
健康小助手 - 每30分钟提醒起身活动、喝水
"""
import random
import datetime
import sys
import io

# 修复 Windows 编码问题
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

# 提醒语料库（轮换着来，不那么无聊）
REMINDERS = {
    "movement": [
        "🧘 起来站一站，扭扭腰，活动 2 分钟",
        "🚶 起身走两步，去窗边看看远方",
        "🤸 肩颈酸了没？做几个扩胸运动",
        "🦵 坐半小时了，起来拉伸一下腿部",
        "💃 站起来！原地踏步 30 秒也好",
    ],
    "water": [
        "💧 喝口水，身体需要水分",
        "🥤 拿起水杯，小口慢饮",
        "🚰 补水时间到，别等口渴才喝",
        "🧊 温水最好，来一口",
    ],
    "eye": [
        "👀 看屏幕久了，闭目养神 20 秒",
        "🌿 远眺一下，让眼睛休息",
    ],
    "mood": [
        "🌬️ 深呼吸三次，放松一下",
        "✨ 你做得很好，记得对自己好点",
    ]
}

def get_reminder():
    """随机组合一条提醒"""
    hour = datetime.datetime.now().hour
    
    # 工作时间（9-18点）更正式一点
    is_work_hours = 9 <= hour < 18
    
    # 随机选2-3个类别组合
    categories = ["movement", "water"]
    if random.random() > 0.5:
        categories.append(random.choice(["eye", "mood"]))
    
    messages = []
    for cat in categories:
        messages.append(random.choice(REMINDERS[cat]))
    
    # 组装消息
    header = "⏰ 健康小提醒" if is_work_hours else "🌙 休息提醒"
    footer = "——身体是革命的本钱 :p"
    
    return f"{header}\n\n" + "\n".join(f"  • {m}" for m in messages) + f"\n\n{footer}"

if __name__ == "__main__":
    print(get_reminder())
