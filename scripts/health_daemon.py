#!/usr/bin/env python3
"""
健康提醒守护进程 - 智能版
只在工作日、工作时间提醒，跳过午休
"""
import time
import random
import datetime
import threading
import sys
import os

# 添加到路径，确保能导入 health_reminder
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from health_reminder import get_reminder, REMINDERS

class HealthDaemon:
    def __init__(self):
        self.running = False
        self.reminder_interval = 30 * 60  # 30分钟（秒）
        self.work_start = 10.5  # 10:30
        self.work_end = 18      # 18:00
        self.lunch_start = 12  # 12:00
        self.lunch_end = 14     # 14:00
        self.last_reminder = None
        
    def is_workday(self):
        """是否为工作日（周一到周五）"""
        return datetime.datetime.now().weekday() < 5
    
    def is_work_hours(self):
        """是否在工作时间（不含午休）"""
        now = datetime.datetime.now()
        hour = now.hour + now.minute / 60
        
        if not (self.work_start <= hour < self.work_end):
            return False
        if self.lunch_start <= hour < self.lunch_end:
            return False
        return True
    
    def should_remind(self):
        """是否应该提醒"""
        now = datetime.datetime.now()
        current_window = now.replace(minute=(now.minute // 30) * 30, second=0, microsecond=0)
        
        # 检查是否在工作日和工作时间
        if not self.is_workday():
            return False
        if not self.is_work_hours():
            return False
        
        # 检查是否已经在这个30分钟窗口内提醒过
        if self.last_reminder == current_window:
            return False
        
        self.last_reminder = current_window
        return True
    
    def send_reminder(self):
        """发送提醒"""
        message = get_reminder()
        print(f"\n{'='*50}")
        print(message)
        print(f"{'='*50}\n")
        
        # 这里可以集成系统通知
        try:
            self.show_system_notification(message)
        except:
            pass
    
    def show_system_notification(self, message):
        """显示大弹窗通知（Windows - tkinter居中大字版）"""
        import threading
        
        def show_big_popup():
            try:
                import tkinter as tk
                from tkinter import font as tkfont
                
                # 创建窗口
                root = tk.Tk()
                root.title("⏰ 健康提醒")
                
                # 窗口设置 - 较大尺寸
                window_width = 600
                window_height = 400
                
                # 获取屏幕尺寸并居中
                screen_width = root.winfo_screenwidth()
                screen_height = root.winfo_screenheight()
                x = (screen_width - window_width) // 2
                y = (screen_height - window_height) // 2
                root.geometry(f"{window_width}x{window_height}+{x}+{y}")
                
                # 置顶显示并强制前台
                root.attributes('-topmost', True)
                root.lift()
                root.focus_force()
                
                # 闪烁任务栏（Windows）
                try:
                    import ctypes
                    hwnd = ctypes.windll.user32.GetForegroundWindow()
                    ctypes.windll.user32.FlashWindow(hwnd, True)
                except:
                    pass
                
                # 背景色 - 温和的蓝色
                root.configure(bg='#E3F2FD')
                
                # 大标题
                title_label = tk.Label(
                    root,
                    text="⏰ 健康提醒",
                    font=('Microsoft YaHei', 36, 'bold'),
                    bg='#E3F2FD',
                    fg='#1976D2'
                )
                title_label.pack(pady=20)
                
                # 分隔线
                separator = tk.Frame(root, bg='#1976D2', height=3)
                separator.pack(fill='x', padx=50, pady=10)
                
                # 提醒内容
                content_label = tk.Label(
                    root,
                    text="该起来活动活动、喝口水了！",
                    font=('Microsoft YaHei', 18),
                    bg='#E3F2FD',
                    fg='#333333',
                    wraplength=500
                )
                content_label.pack(pady=20)
                
                # 具体建议
                details = tk.Label(
                    root,
                    text="• 站起来走两步\n• 喝口水润润喉\n• 看看远处放松眼睛",
                    font=('Microsoft YaHei', 14),
                    bg='#E3F2FD',
                    fg='#555555',
                    justify='left'
                )
                details.pack(pady=10)
                
                # 确定按钮
                def close_window():
                    root.destroy()
                
                btn = tk.Button(
                    root,
                    text="知道了 💪",
                    font=('Microsoft YaHei', 16, 'bold'),
                    bg='#1976D2',
                    fg='white',
                    activebackground='#1565C0',
                    activeforeground='white',
                    padx=30,
                    pady=10,
                    command=close_window
                )
                btn.pack(pady=30)
                
                # 绑定回车键关闭
                root.bind('<Return>', lambda e: close_window())
                root.bind('<Escape>', lambda e: close_window())
                
                # 窗口关闭协议
                root.protocol('WM_DELETE_WINDOW', close_window)
                
                # 运行窗口
                root.mainloop()
                
            except Exception as e:
                print(f"弹窗显示失败: {e}")
                # 备用方案：powershell 弹窗
                import subprocess
                subprocess.run([
                    "powershell", "-Command",
                    'Add-Type -AssemblyName System.Windows.Forms; '
                    '[System.Windows.Forms.MessageBox]::Show("该起来活动活动、喝口水了！", "⏰ 健康提醒")'
                ], capture_output=True)
        
        # 在新线程中显示弹窗，不阻塞主循环
        threading.Thread(target=show_big_popup, daemon=True).start()
    
    def run(self):
        """主循环"""
        self.running = True
        now = datetime.datetime.now()
        
        print("🚀 健康提醒守护进程已启动")
        print(f"   工作时间: {int(self.work_start)}:{int((self.work_start % 1) * 60):02d} - {self.work_end}:00")
        print(f"   午休跳过: {self.lunch_start}:00 - {int(self.lunch_end)}:00")
        
        # 计算下次提醒时间
        if now.minute < 30:
            next_time = now.replace(minute=30, second=0, microsecond=0)
        else:
            next_time = now.replace(minute=0, second=0, microsecond=0) + datetime.timedelta(hours=1)
        print(f"   下次提醒: {next_time.strftime('%H:%M')}")
        print("   按 Ctrl+C 停止\n")
        
        # 启动容错：如果刚错过整点/半点（1分钟内），立即补发一次
        if now.minute in [0, 1, 30, 31]:
            print(f"[{now.strftime('%H:%M')}] 刚错过整点/半点，立即补发提醒...")
            if self.is_workday() and self.is_work_hours():
                # 标记当前窗口已提醒
                current_window = now.replace(minute=(now.minute // 30) * 30, second=0, microsecond=0)
                self.last_reminder = current_window
                self.send_reminder()
                print("[补发完成] 下次正常提醒:\n")
        
        while self.running:
            try:
                if self.should_remind():
                    self.send_reminder()
                
                # 每分钟检查一次
                time.sleep(60)
                
            except KeyboardInterrupt:
                print("\n👋 健康提醒守护进程已停止")
                self.running = False
                break
            except Exception as e:
                print(f"❌ 错误: {e}")
                time.sleep(60)

if __name__ == "__main__":
    daemon = HealthDaemon()
    daemon.run()
