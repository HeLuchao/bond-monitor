#!/usr/bin/env python3
"""
本地测试脚本
用于验证新债查询和推送功能是否正常工作
"""

import os
import sys
from datetime import datetime

# 添加 scripts 目录到 Python 路径
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'scripts'))

from scripts.query_bond import BondMonitor
from scripts.utils import send_serverchan
from scripts.config import Config


def test_serverchan():
    """测试 Server酱 推送"""
    print("\n" + "="*50)
    print("测试 1: Server酱 推送")
    print("="*50)
    
    sendkey = Config.SERVERCHAN_SENDKEY
    if not sendkey:
        print("❌ SERVERCHAN_SENDKEY 未配置")
        print("请设置环境变量：export SERVERCHAN_SENDKEY='your_sendkey'")
        return False
    
    print(f"✅ SERVERCHAN_SENDKEY 已配置: {sendkey[:20]}...")
    
    # 发送测试消息
    title = "🧪 新债监控系统测试"
    content = f"""
## 测试消息

这是一条测试消息，用于验证推送功能是否正常。

**测试时间**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

如果你收到这条消息，说明推送功能配置成功！

---

### 系统信息
- Python 版本: {sys.version.split()[0]}
- 操作系统: {sys.platform}
- 配置文件: config.py
"""
    
    success = send_serverchan(title, content, sendkey)
    
    if success:
        print("✅ Server酱推送成功！请检查个人微信是否收到消息")
        return True
    else:
        print("❌ Server酱推送失败")
        return False


def test_bond_query():
    """测试债券查询功能"""
    print("\n" + "="*50)
    print("测试 2: 债券数据查询")
    print("="*50)
    
    try:
        monitor = BondMonitor()
        print(f"✅ BondMonitor 初始化成功")
        print(f"   - 查询日期: {monitor.today}")
        
        # 查询债券数据
        print("\n正在查询债券数据...")
        bonds = monitor.fetch_bond_data()
        
        if bonds is not None and not bonds.empty:
            print(f"✅ 查询成功，获取到 {len(bonds)} 条债券数据")
            print(f"\n前3条数据预览:")
            print(bonds.head(3).to_string())
            return True
        else:
            print("⚠️ 未查询到债券数据（可能是非工作日或数据源问题）")
            return True
            
    except Exception as e:
        print(f"❌ 查询失败: {e}")
        import traceback
        traceback.print_exc()
        return False


def test_data_storage():
    """测试数据存储功能"""
    print("\n" + "="*50)
    print("测试 3: 数据存储")
    print("="*50)
    
    try:
        from scripts.utils import save_data, load_data
        import pandas as pd
        
        # 创建测试数据
        test_data = pd.DataFrame({
            '债券代码': ['123456', '123457'],
            '债券名称': ['测试转债1', '测试转债2'],
            '发行日期': ['2026-03-12', '2026-03-12']
        })
        
        # 保存数据
        save_data(test_data, 'test_bonds.csv')
        print("✅ 数据保存成功")
        
        # 加载数据
        loaded_data = load_data('test_bonds.csv')
        if loaded_data is not None:
            print("✅ 数据加载成功")
            print(f"   - 数据行数: {len(loaded_data)}")
            
            # 清理测试文件
            import os
            test_file = os.path.join('data', 'test_bonds.csv')
            if os.path.exists(test_file):
                os.remove(test_file)
                print("✅ 测试文件已清理")
            
            return True
        else:
            print("❌ 数据加载失败")
            return False
            
    except Exception as e:
        print(f"❌ 存储测试失败: {e}")
        import traceback
        traceback.print_exc()
        return False


def main():
    """主测试函数"""
    print("\n" + "="*70)
    print(" "*20 + "新债监控系统 - 本地测试")
    print("="*70)
    
    print(f"\n测试时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    # 检查环境变量
    print("\n" + "-"*50)
    print("环境变量检查:")
    print("-"*50)
    
    serverchan_key = os.getenv('SERVERCHAN_SENDKEY', '')
    wechat_webhook = os.getenv('WECHAT_WEBHOOK_URL', '')
    
    print(f"SERVERCHAN_SENDKEY: {'✅ 已配置' if serverchan_key else '❌ 未配置'}")
    print(f"WECHAT_WEBHOOK_URL: {'✅ 已配置' if wechat_webhook else '⚠️ 未配置（可选）'}")
    
    # 运行测试
    results = []
    
    # 测试1: Server酱推送
    results.append(("Server酱推送", test_serverchan()))
    
    # 测试2: 债券查询
    results.append(("债券数据查询", test_bond_query()))
    
    # 测试3: 数据存储
    results.append(("数据存储功能", test_data_storage()))
    
    # 输出测试结果汇总
    print("\n" + "="*70)
    print(" "*25 + "测试结果汇总")
    print("="*70)
    
    for name, result in results:
        status = "✅ 通过" if result else "❌ 失败"
        print(f"{name:20s}: {status}")
    
    # 统计
    passed = sum(1 for _, r in results if r)
    total = len(results)
    
    print("\n" + "-"*70)
    print(f"总计: {passed}/{total} 项测试通过")
    
    if passed == total:
        print("\n🎉 恭喜！所有测试通过，系统运行正常！")
        print("\n下一步:")
        print("1. 提交代码到 GitHub")
        print("2. 在 GitHub 配置 SERVERCHAN_SENDKEY Secret")
        print("3. 手动触发工作流测试")
    else:
        print("\n⚠️ 部分测试失败，请检查配置和代码")
    
    print("="*70 + "\n")


if __name__ == '__main__':
    main()
