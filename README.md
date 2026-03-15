# 新债监控自动化系统

[![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-自动执行-brightgreen)](https://github.com/HeLuchao/bond-monitor/actions)
[![Python](https://img.shields.io/badge/Python-3.11+-blue)](https://www.python.org/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

每日自动查询新债申购信息，并通过 **Server酱** 推送到个人微信，让你不错过任何新债申购机会。

## ✨ 核心功能

- 📊 **自动查询**：每日自动查询可转债申购数据
- 📱 **微信推送**：直接推送到个人微信，无需群聊
- 🎯 **智能筛选**：只推送今日/明日申购的新债
- 💡 **直观标题**：标题直接显示是否有新债，无需点进消息
- 🕗 **定时执行**：每天北京时间 8:00 自动推送（可自由配置）
- 💰 **完全免费**：基于 GitHub Actions + Server酱，零成本运行
- 📈 **数据完整**：包含申购代码、发行规模、转股价、信用评级等关键信息

## 📋 推送示例

### 有新债申购

```
标题：✅ 今日有1只新债申购

债券名称：长高转债
债券代码：127113
申购日期：2026-03-09
申购代码：072452
发行规模：10.00亿
转股价：15.50
信用评级：AA-
---
```

### 无新债申购（可选）

```
标题：❌ 今日无新债申购

日期: 2026-03-12

数据统计:
- 总债券数量: 1006
- 今日申购: 0
- 明日申购: 0
```

## 🚀 快速开始

### 1. Fork 本仓库

点击右上角 Fork 按钮，将仓库 Fork 到你的账号。

### 2. 配置 Server酱

#### 2.1 注册 Server酱账号

1. 访问 [Server酱官网](https://sct.ftqq.com/)
2. 微信扫码登录
3. 进入「SendKey 管理」
4. 点击「生成 SendKey」
5. 复制你的 SendKey（格式：`SCTxxxxxxxxxxxxxxxxxxxxxxxx`）

#### 2.2 配置 GitHub Secrets

1. 进入你 Fork 的仓库
2. `Settings` → `Secrets and variables` → `Actions`
3. 点击 `New repository secret`
4. 添加以下 Secret：
   - **Name**: `SERVERCHAN_SENDKEY`
   - **Value**: 粘贴你的 SendKey
5. 点击 `Add secret`

### 3. 测试运行

1. 进入仓库的 `Actions` 标签
2. 点击 `Daily Bond Query` workflow
3. 点击 `Run workflow` → `Run workflow`
4. 等待执行完成
5. 检查个人微信是否收到推送

### 4. 本地测试（可选）

```bash
# 克隆仓库
git clone https://github.com/你的用户名/bond-monitor.git
cd bond-monitor

# 安装依赖
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt

# 设置环境变量
export SERVERCHAN_SENDKEY="你的SendKey"

# 测试推送
python test_push.py

# 运行主程序
python scripts/query_bond.py
```

## ⚙️ 配置选项

### 必需配置

| Secret 名称 | 说明 | 获取方式 |
|------------|------|---------|
| `SERVERCHAN_SENDKEY` | Server酱的 SendKey | [Server酱官网](https://sct.ftqq.com/) |

### 可选配置

| Secret 名称 | 说明 | 默认值 |
|------------|------|--------|
| `SEND_DAILY_STATUS` | 是否发送每日状态通知（无新债时也推送） | `false` |
| `WECHAT_WEBHOOK_URL` | 企业微信群机器人 Webhook（多人推送用） | 无 |
| `PUSH_HOUR` | 推送时间：小时（北京时间，0-23） | `8` |
| `PUSH_MINUTE` | 推送时间：分钟（0-59） | `0` |

### 推送方式对比

| 推送方式 | 配置难度 | 接收对象 | 成本 | 推荐场景 |
|---------|---------|---------|------|---------|
| **Server酱** ⭐ | 最简单 | 个人微信 | 免费（5条/天） | 个人使用 |
| 企业微信群机器人 | 简单 | 企业微信群 | 免费 | 多人接收 |

## 📅 定时任务

- **执行时间**：每天北京时间 8:00（UTC 0:00），可自由配置
- **推送条件**：
  - 默认：有新债申购时推送
  - 可选：配置 `SEND_DAILY_STATUS=true` 每天推送状态通知
- **数据来源**：AkShare 可转债数据接口
- **筛选逻辑**：申购日期 = 今天 OR 明天

## 📁 项目结构

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
├── test_push.py                 # 推送测试脚本
├── test_local.py                # 本地测试脚本
├── requirements.txt             # Python 依赖
├── .env.example                 # 环境变量示例
├── README.md                    # 项目说明
├── CHANGELOG.md                 # 更新日志
├── PUSH_MECHANISM.md            # 推送机制说明
├── GITHUB_ACTIONS_TROUBLESHOOTING.md  # 故障排查指南
└── QUICKSTART.md                # 快速启动指南
```

## 📚 文档导航

- **[README.md](README.md)** - 项目说明（本文档）
- **[QUICKSTART.md](QUICKSTART.md)** - 快速启动指南
- **[CHANGELOG.md](CHANGELOG.md)** - 版本更新日志
- **[PUSH_MECHANISM.md](PUSH_MECHANISM.md)** - 推送机制详细说明
- **[GITHUB_ACTIONS_TROUBLESHOOTING.md](GITHUB_ACTIONS_TROUBLESHOOTING.md)** - GitHub Actions 故障排查

## 🔧 本地开发

### 安装依赖

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 运行测试

```bash
# 测试推送功能
export SERVERCHAN_SENDKEY="你的SendKey"
python test_push.py

# 测试完整流程
python test_local.py

# 运行主程序
python scripts/query_bond.py
```

### 环境变量

复制 `.env.example` 为 `.env` 并配置：

```env
# Server酱 SendKey（必需）
SERVERCHAN_SENDKEY=SCTxxxxxxxxxxxxxxxxxxxxxxxx

# 每日状态通知（可选）
SEND_DAILY_STATUS=false

# 企业微信机器人（可选）
WECHAT_WEBHOOK_URL=https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxx
```

## 💡 常见问题

### Q1: 为什么没有收到推送？

**A**: 系统默认只在有新债申购时推送。如果今天没有新债，不会推送消息。

**解决方案**：
- 运行 `python test_push.py` 测试推送功能
- 或配置 `SEND_DAILY_STATUS=true` 启用每日通知

### Q2: Server酱免费版够用吗？

**A**: 完全够用！
- 免费版：每天 5 条消息
- 本项目：每天最多 1 条消息
- 实际使用量远低于限制

### Q3: 如何确认系统正常工作？

**A**: 
1. 查看 GitHub Actions 日志，显示 "任务执行完成"
2. 本地运行 `test_push.py`，能收到消息说明推送正常
3. 配置 `SEND_DAILY_STATUS=true`，每天收到状态通知

### Q4: 推送时间可以修改吗？

**A**: 可以！支持三种配置方式，优先级从高到低：

**方式一：手动触发时临时指定**（一次性测试）

在 GitHub Actions 页面点击 "Run workflow"，填入 `push_hour` 和 `push_minute` 参数即可。

**方式二：通过仓库 Secrets 永久配置**（推荐）

进入 `Settings` → `Secrets and variables` → `Actions`，添加：
- `PUSH_HOUR` = `8`（想推送的小时，北京时间 0-23）
- `PUSH_MINUTE` = `0`（想推送的分钟 0-59）

> 注意：以上 Secrets 会改变脚本的推送时间说明，若同时需要调整 cron 触发时间，还需修改 `.github/workflows/daily-query.yml` 中的 cron 表达式（北京时间 = UTC + 8）：
> - `0 0 * * *` → 北京时间 08:00（默认）
> - `0 1 * * *` → 北京时间 09:00
> - `30 1 * * *` → 北京时间 09:30

**方式三：本地 `.env` 文件**（本地测试用）

```env
PUSH_TIME=08:00
```

### Q5: 可以推送到企业微信群吗？

**A**: 可以！
1. 参考 [企业微信群机器人创建指南](WECHAT_BOT_GUIDE.md)
2. 配置 `WECHAT_WEBHOOK_URL` Secret
3. 系统会同时推送到个人微信和企业微信群

## 📊 技术栈

- **数据获取**: AkShare（开源免费金融数据接口）
- **定时任务**: GitHub Actions（免费额度）
- **消息推送**: Server酱（免费版每天5条）
- **开发语言**: Python 3.11+
- **数据处理**: Pandas

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

如有问题或建议，也可通过以下方式联系：

- **Email**：heluchao1994@gmail.com
- **GitHub**：https://github.com/HeLuchao

## 📝 许可证

[MIT License](LICENSE)

## ⚠️ 免责声明

本工具仅用于个人学习和研究，不构成任何投资建议。投资有风险，请谨慎决策。

## 🌟 Star History

如果这个项目对你有帮助，请给一个 ⭐️ Star 支持一下！

---

**Made with ❤️ by [HeLuchao](https://github.com/HeLuchao)**
