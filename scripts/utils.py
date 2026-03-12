import os
import json
from datetime import datetime, timedelta
import pandas as pd
import requests


def get_today():
    """获取今天的日期字符串"""
    return datetime.now().strftime('%Y-%m-%d')


def get_yesterday():
    """获取昨天的日期字符串"""
    return (datetime.now() - timedelta(days=1)).strftime('%Y-%m-%d')


def save_data(data, filename):
    """保存数据到文件"""
    os.makedirs('data', exist_ok=True)
    filepath = os.path.join('data', filename)
    data.to_json(filepath, orient='records', force_ascii=False, indent=2)
    return filepath


def load_data(filename):
    """从文件加载数据"""
    filepath = os.path.join('data', filename)
    if os.path.exists(filepath):
        return pd.read_json(filepath)
    return None


def format_bond_info(row):
    """格式化单条债券信息"""
    return f"""
> **债券名称**：{row.get('债券简称', 'N/A')}
> **债券代码**：{row.get('债券代码', 'N/A')}
> **发行日期**：{row.get('发行日期', 'N/A')}
> **发行规模**：{row.get('发行规模', 'N/A')}亿元
> **票面利率**：{row.get('票面利率', 'N/A')}%
> **期限**：{row.get('期限', 'N/A')}年
> **信用评级**：{row.get('信用评级', 'N/A')}
---
"""


def compare_bonds(new_bonds, old_bonds):
    """对比新旧数据，找出新增债券"""
    if old_bonds is None:
        return new_bonds

    old_codes = set(old_bonds['债券代码'].tolist()) if '债券代码' in old_bonds.columns else set()
    new_codes = set(new_bonds['债券代码'].tolist()) if '债券代码' in new_bonds.columns else set()
    added_codes = new_codes - old_codes

    if '债券代码' in new_bonds.columns:
        return new_bonds[new_bonds['债券代码'].isin(added_codes)]
    return new_bonds


def send_serverchan(title, content, sendkey):
    """通过 Server酱发送消息到个人微信"""
    if not sendkey:
        print("⚠️ Server酱 SendKey 未配置，跳过推送")
        return False
    
    url = f"https://sctapi.ftqq.com/{sendkey}.send"
    data = {
        "title": title,
        "desp": content
    }
    
    try:
        response = requests.post(url, data=data, timeout=10)
        result = response.json()
        
        if result.get("code") == 0:
            print(f"✅ Server酱推送成功: {title}")
            return True
        else:
            print(f"❌ Server酱推送失败: {result}")
            return False
            
    except Exception as e:
        print(f"❌ Server酱推送异常: {e}")
        return False
