# 新债监控自动化系统

每日自动查询新债发行信息，并通过企业微信机器人推送提醒。

## 功能特性

- 每日自动查询新债发行数据
- 支持可转债、企业债等多种债券类型
- 通过企业微信机器人推送消息提醒
- 包含债券关键信息：代码、名称、发行日期、规模、利率、期限、评级等
- 完全免费，零成本运行

## 技术栈

- **数据获取**: AkShare（开源免费金融数据接口）
- **定时任务**: GitHub Actions（免费额度）
- **消息推送**: 企业微信机器人（完全免费）
- **开发语言**: Python 3.11+

## 快速开始

### 1. 准备工作

#### 1.1 创建企业微信群机器人

1. 创建企业微信群（至少3人）
2. 添加群机器人：群聊 → 右上角三个点 → 群机器人 → 添加机器人
3. 复制 Webhook URL（格式：`https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxx`）

#### 1.2 Fork 或 Clone 本仓库

如果你使用此仓库，建议 Fork 到你自己的 GitHub 账号。

### 2. 配置 GitHub Secrets

1. 进入你的 GitHub 仓库
2. Settings → Secrets and variables → Actions → New repository secret
3. 添加以下 Secret：
   - Name: `WECHAT_WEBHOOK_URL`
   - Value: 复制的企业微信 Webhook URL

### 3. 测试运行

1. 进入仓库的 Actions 标签
2. 点击 "Daily Bond Query" workflow
3. 点击 "Run workflow" 手动触发测试
4. 查看执行日志
5. 检查微信是否收到消息

### 4. 定时任务

系统已配置为每天北京时间 9:00（UTC 1:00）自动执行。

## 本地运行

### 安装依赖

```bash
pip install -r requirements.txt
```

### 配置环境变量

复制 `.env.example` 为 `.env`，并填入你的 Webhook URL：

```env
WECHAT_WEBHOOK_URL=https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=your_key_here
```

### 运行脚本

```bash
python scripts/query_bond.py
```

## 项目结构

```
bond-monitor/
├── .github/
│   └── workflows/
│       └── daily-query.yml      # GitHub Actions 配置
├── scripts/
│   ├── query_bond.py            # 主查询脚本
│   ├── utils.py                 # 工具函数
│   └── config.py                # 配置文件
├── data/                        # 数据存储目录
├── logs/                        # 日志目录
├── requirements.txt             # Python 依赖
├── .env.example                 # 环境变量示例
├── .gitignore                   # Git 忽略文件
└── README.md                    # 项目说明
```

## 消息示例

```
📢 新债提醒 (2026-03-13)

> **债券名称**：XX转债
> **债券代码**：123456
> **发行日期**：2026-03-13
> **发行规模**：10亿元
> **票面利率**：3.5%
> **期限**：5年
> **信用评级**：AAA
---
```

## 注意事项

1. GitHub Actions 使用 UTC 时区，配置时请注意时区转换
2. 仓库60天无活动会停用定时任务，需保持一定活跃度
3. 企业微信机器人每个机器人每分钟最多发送20条消息
4. 请勿将 `.env` 文件提交到代码仓库

## 许可证

MIT License

## 免责声明

本工具仅用于个人学习和研究，不构成任何投资建议。投资有风险，请谨慎决策。
