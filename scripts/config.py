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

    # 消息推送配置
    PUSH_TIME = '09:00'  # 推送时间（北京时间）

    # 是否推送所有新债，还是只推送重要信息
    PUSH_ALL = False
