import sys
import os
import requests
import json
from datetime import datetime
import pandas as pd

# 添加 scripts 目录到 Python 路径
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

import akshare as ak
from utils import get_today, get_yesterday, save_data, load_data, format_bond_info, compare_bonds, send_serverchan
from config import Config


class BondMonitor:
    def __init__(self):
        self.webhook_url = Config.WECHAT_WEBHOOK_URL
        self.serverchan_sendkey = Config.SERVERCHAN_SENDKEY
        self.today = get_today()
        self.yesterday = get_yesterday()

    def fetch_bond_data(self):
        """获取新债数据"""
        print(f"[{datetime.now()}] 开始获取新债数据...")

        try:
            # 使用 AkShare 获取可转债数据
            df = ak.bond_zh_cov()
            print(f"[{datetime.now()}] 成功获取 {len(df)} 条债券数据")
            return df
        except Exception as e:
            print(f"[{datetime.now()}] 获取数据失败: {str(e)}")
            return None

    def filter_new_bonds(self, df):
        """过滤出今日或明日申购的新债"""
        if df is None or df.empty:
            return None

        # 筛选申购日期为今天或明天的债券
        df['申购日期'] = pd.to_datetime(df['申购日期'])
        tomorrow = (datetime.now() + pd.Timedelta(days=1)).strftime('%Y-%m-%d')

        # 筛选条件
        mask = (df['申购日期'].dt.strftime('%Y-%m-%d').isin([self.today, tomorrow]))
        new_bonds = df[mask]

        print(f"[{datetime.now()}] 筛选出 {len(new_bonds)} 条新债")
        return new_bonds

    def send_wechat_message(self, title, content):
        """发送企业微信机器人消息"""
        if not self.webhook_url:
            print(f"[{datetime.now()}] 未配置企业微信 Webhook URL，跳过消息推送")
            return False

        data = {
            "msgtype": "markdown",
            "markdown": {
                "content": f"## {title}\n\n{content}"
            }
        }

        try:
            response = requests.post(
                self.webhook_url,
                json=data,
                headers={'Content-Type': 'application/json'},
                timeout=10
            )
            result = response.json()

            if result.get('errcode') == 0:
                print(f"[{datetime.now()}] 微信消息发送成功")
                return True
            else:
                print(f"[{datetime.now()}] 微信消息发送失败: {result}")
                return False
        except Exception as e:
            print(f"[{datetime.now()}] 发送微信消息异常: {str(e)}")
            return False

    def generate_bond_message(self, df):
        """生成新债提醒消息"""
        if df is None or df.empty:
            return None

        content_lines = []
        for idx, row in df.iterrows():
            bond_info = format_bond_info(row.to_dict())
            content_lines.append(bond_info)

        content = ''.join(content_lines)

        # 标题直接显示新债数量
        count = len(df)
        if count == 1:
            title = f"✅ 今日有1只新债申购"
        else:
            title = f"✅ 今日有{count}只新债申购"

        return title, content

    def run(self):
        """执行监控任务"""
        push_time = Config.get_push_time()
        print(f"\n{'='*50}")
        print(f"[{datetime.now()}] 开始执行新债监控任务")
        print(f"[配置] 推送时间（北京时间）：{push_time}")
        print(f"[配置] Server酱 SendKey：{'已配置' if self.serverchan_sendkey else '未配置'}")
        print(f"[配置] 企业微信 Webhook：{'已配置' if self.webhook_url else '未配置'}")
        print(f"{'='*50}\n")

        # 1. 获取债券数据
        df = self.fetch_bond_data()

        # 2. 保存历史数据用于对比
        old_file = f'bonds_{self.yesterday}.json'
        old_df = load_data(old_file)

        # 3. 筛选新债
        new_bonds = self.filter_new_bonds(df)

        # 4. 对比找出新增债券
        added_bonds = compare_bonds(new_bonds, old_df)

        # 5. 保存今日数据
        today_file = f'bonds_{self.today}.json'
        if df is not None:
            save_data(df, today_file)

        # 6. 发送消息提醒
        if added_bonds is not None and not added_bonds.empty:
            title, content = self.generate_bond_message(added_bonds)

            # 推送到企业微信群
            success = self.send_wechat_message(title, content)

            # 推送到个人微信（Server酱）
            plain_content = content.replace('> ', '').replace('---', '').replace('\n\n', '\n')
            send_serverchan(
                title=title.replace('📢 ', ''),
                content=plain_content.strip(),
                sendkey=self.serverchan_sendkey
            )

            if success:
                print(f"[{datetime.now()}] 成功推送 {len(added_bonds)} 条新债信息")
            else:
                print(f"[{datetime.now()}] 企业微信消息推送失败")
        else:
            print(f"[{datetime.now()}] 今日无新债，无需推送")

            # 发送每日状态通知（可选）
            import os
            if os.getenv('SEND_DAILY_STATUS', 'false').lower() == 'true':
                status_title = "❌ 今日无新债申购"
                status_content = f"""
**日期**: {self.today}

**数据统计**:
- 总债券数量: {len(df) if df is not None else 0}
- 今日申购: 0
- 明日申购: 0

**最近申购债券**:
"""

                # 获取最近3只债券
                if df is not None and not df.empty:
                    recent = df.sort_values('申购日期', ascending=False).head(3)
                    for _, row in recent.iterrows():
                        status_content += f"""
- {row.get('债券简称', 'N/A')} ({row.get('债券代码', 'N/A')})
  申购日期: {row.get('申购日期', 'N/A')}
"""

                status_content += "\n---\n💡 系统运行正常，暂无新债申购"

                send_serverchan(
                    title=status_title,
                    content=status_content.strip(),
                    sendkey=self.serverchan_sendkey
                )
                print(f"[{datetime.now()}] 已发送每日状态通知")

        print(f"\n{'='*50}")
        print(f"[{datetime.now()}] 任务执行完成")
        print(f"{'='*50}\n")


def main():
    monitor = BondMonitor()
    monitor.run()


if __name__ == '__main__':
    main()
