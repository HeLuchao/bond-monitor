import os
from dotenv import load_dotenv

load_dotenv()


class Config:
    # 企业微信 Webhook URL
    WECHAT_WEBHOOK_URL = os.getenv('WECHAT_WEBHOOK_URL')

    # Server酱 SendKey（推送到个人微信）
    SERVERCHAN_SENDKEY = os.getenv('SERVERCHAN_SENDKEY')

    # 数据存储路径
    DATA_DIR = 'data'
    LOGS_DIR = 'logs'

    # 新债查询配置
    BOND_TYPE = 'all'  # all, cb(可转债), corporate(企业债)

    # 消息推送时间配置（北京时间）
    # 优先级：环境变量 PUSH_TIME > 默认值 08:00
    # 格式：HH:MM，例如 "08:00"、"09:30"、"10:00"
    # 配置方式：
    #   - 本地：在 .env 文件中设置 PUSH_TIME=08:00
    #   - GitHub Actions：在仓库 Secrets 中设置 PUSH_HOUR 和 PUSH_MINUTE
    PUSH_TIME = os.getenv('PUSH_TIME', '08:00')

    # 是否推送所有新债，还是只推送重要信息
    PUSH_ALL = False

    @classmethod
    def get_push_time(cls) -> str:
        """获取推送时间，返回 HH:MM 格式字符串"""
        push_time = cls.PUSH_TIME
        # 基本格式校验
        try:
            parts = push_time.split(':')
            hour = int(parts[0])
            minute = int(parts[1]) if len(parts) > 1 else 0
            # 范围校验
            if not (0 <= hour <= 23 and 0 <= minute <= 59):
                raise ValueError
            return f"{hour:02d}:{minute:02d}"
        except (ValueError, IndexError):
            print(f"⚠️  PUSH_TIME 格式无效（当前值：{push_time}），已回退为默认值 08:00")
            return '08:00'
