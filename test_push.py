#!/usr/bin/env python3
"""
测试推送功能
强制发送一条测试消息到个人微信
"""

import os
import sys
from datetime import datetime

# 添加 scripts 目录到 Python 路径
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'scripts'))

from scripts.utils import send_serverchan
from scripts.config import Config


def main():
    print("\n" + "="*70)
    print(" "*20 + "测试推送功能")
    print("="*70)
    
    # 检查环境变量
    sendkey = Config.SERVERCHAN_SENDKEY
    
    if not sendkey:
        print("\n❌ 错误: SERVERCHAN_SENDKEY 未配置")
        print("\n请设置环境变量:")
        print("  export SERVERCHAN_SENDKEY='your_sendkey'")
        print("\n或在 GitHub Secrets 中配置 SERVERCHAN_SENDKEY")
        return False
    
    print(f"\n✅ SERVERCHAN_SENDKEY 已配置: {sendkey[:20]}...")
    
    # 发送测试消息
    title = "🧪 新债监控系统测试"
    content = f"""
## 测试消息

这是一条测试消息，用于验证推送功能是否正常。

**测试时间**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

### 系统状态
✅ 数据查询功能正常
✅ Server酱配置正确
✅ 推送功能可用

---

### 说明
如果你收到这条消息，说明：
1. GitHub Actions 工作流正常执行
2. SERVERCHAN_SENDKEY 配置正确
3. Server酱推送服务正常

系统将在每天早上 9:00 自动推送新债信息。
"""

    print("\n正在发送测试消息...")
    success = send_serverchan(title, content, sendkey)
    
    if success:
        print("\n" + "="*70)
        print("✅ 推送成功！")
        print("="*70)
        print("\n请检查你的个人微信是否收到消息。")
        print("\n消息内容:")
        print(f"  标题: {title}")
        print(f"  发送时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print("\n" + "="*70)
        return True
    else:
        print("\n" + "="*70)
        print("❌ 推送失败")
        print("="*70)
        print("\n可能的原因:")
        print("1. SendKey 无效或已过期")
        print("2. 网络连接问题")
        print("3. Server酱服务异常")
        print("\n请检查:")
        print("- 访问 https://sct.ftqq.com/ 查看你的 SendKey")
        print("- 尝试在 Server酱官网发送测试消息")
        print("- 检查网络连接")
        print("\n" + "="*70)
        return False


if __name__ == '__main__':
    success = main()
    sys.exit(0 if success else 1)
