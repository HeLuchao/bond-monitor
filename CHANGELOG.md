# 更新日志 (Changelog)

本文档记录项目的所有重要更改。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

---

## [1.0.0] - 2026-03-12

### 🎉 首次发布

完整的新债监控自动化系统，支持自动查询和微信推送。

---

### ✨ 新增功能

#### 核心功能
- **自动查询**：每日自动查询可转债申购数据（使用 AkShare）
- **智能筛选**：筛选今日/明日申购的新债
- **微信推送**：通过 Server酱推送到个人微信
- **定时任务**：GitHub Actions 每天北京时间 9:00 自动执行

#### 推送功能
- **直观标题**：标题直接显示是否有新债申购
  - 有新债：`✅ 今日有X只新债申购`
  - 无新债：`❌ 今日无新债申购`（可选）
- **完整信息**：包含债券代码、申购代码、发行规模、转股价、信用评级等
- **双重推送**：支持同时推送到个人微信和企业微信群

#### 配置选项
- **SERVERCHAN_SENDKEY**：Server酱推送密钥（必需）
- **SEND_DAILY_STATUS**：每日状态通知开关（可选，默认 false）
- **WECHAT_WEBHOOK_URL**：企业微信群机器人（可选）

#### 测试工具
- **test_push.py**：推送功能测试脚本，强制发送测试消息
- **test_local.py**：本地完整测试脚本，验证所有功能
- **推送机制说明**：详细的推送触发机制文档

#### 文档完善
- **README.md**：完整的项目说明和快速开始指南
- **QUICKSTART.md**：快速启动指南
- **DEPLOYMENT_GUIDE.md**：详细部署指南
- **PROJECT_SUMMARY.md**：项目总结
- **PUSH_MECHANISM.md**：推送机制详细说明
- **GITHUB_ACTIONS_TROUBLESHOOTING.md**：GitHub Actions 故障排查
- **WECHAT_BOT_GUIDE.md**：企业微信群机器人创建指南
- **WECHAT_KF_GUIDE.md**：企业微信客服消息配置指南
- **PERSONAL_WECHAT_GUIDE.md**：个人微信推送配置指南
- **CONFIG_COMPLETE.md**：配置完成总结

---

### 🔧 技术实现

#### 数据获取
- 使用 AkShare `bond_zh_cov()` 接口获取可转债数据
- 自动处理数据格式和日期转换
- 支持数据持久化存储（JSON 格式）

#### 定时任务
- GitHub Actions 自动化工作流
- 使用最新版本的 Actions（v4/v5）
- 支持手动触发测试
- 自动上传日志和数据 artifacts

#### 消息推送
- Server酱 API 集成
- 企业微信机器人 API 集成
- Markdown 格式消息
- 错误处理和日志记录

---

### 📊 项目结构

```
bond-monitor/
├── .github/workflows/          # GitHub Actions 配置
│   └── daily-query.yml
├── scripts/                    # 核心脚本
│   ├── query_bond.py          # 主查询脚本
│   ├── utils.py               # 工具函数
│   └── config.py              # 配置管理
├── data/                       # 数据存储
├── logs/                       # 日志文件
├── test_push.py               # 推送测试
├── test_local.py              # 本地测试
├── requirements.txt           # Python 依赖
└── docs/                      # 文档目录
```

---

### 🐛 已知问题

1. **推送条件**：默认只在有新债申购时推送，无新债时不推送
   - **解决方案**：配置 `SEND_DAILY_STATUS=true` 启用每日通知

2. **Server酱限制**：免费版每天最多 5 条消息
   - **影响**：本项目每天最多 1 条，完全够用

3. **GitHub Actions 时区**：使用 UTC 时区，需转换为北京时间
   - **配置**：UTC 1:00 = 北京时间 9:00

---

### 🔐 安全性

- 所有敏感信息通过 GitHub Secrets 管理
- `.env` 文件已加入 `.gitignore`
- 不在代码中硬编码任何密钥或令牌
- SSH 密钥使用 ED25519 算法（更安全）

---

### 📈 性能优化

- 使用 Pandas 进行高效数据处理
- 数据缓存机制，避免重复查询
- 错误重试和超时处理
- 日志文件自动管理

---

### 🎯 版本规划

#### [1.1.0] - 计划中
- [ ] 支持更多债券类型（企业债、公司债等）
- [ ] 添加债券评分和推荐
- [ ] 支持邮件推送
- [ ] Web 界面查看历史数据

#### [1.2.0] - 计划中
- [ ] 多用户支持
- [ ] 自定义推送时间
- [ ] 债券收藏和提醒
- [ ] 数据分析和可视化

---

### 📝 提交记录

#### v1.0.0 (2026-03-12)

**初始提交**：
- `d8a7778` - Initial commit: 新债监控自动化系统

**核心功能**：
- `26fe253` - 添加部署指南和自动化脚本
- `91c3678` - 添加快速启动指南
- `7e01c42` - 添加项目总结文档
- `c5a6bd5` - 添加 GitHub 推送指南

**推送功能**：
- `da8c271` - 添加 Server酱支持，可推送到个人微信
- `734c34e` - 优化推送标题，显示今日是否有新债

**配置和文档**：
- `e80c6d7` - 添加 GitHub Secrets 配置指南
- `e61faf4` - 添加企业微信群机器人创建指南
- `35452c3` - 添加企业微信客服消息和 Server酱配置指南
- `61cd638` - 添加配置完成总结文档
- `b079429` - 优化推送机制并添加测试工具

**问题修复**：
- `f3cca86` - 修复 GitHub Actions 配置并优化代码
- `7dadb93` - 升级 GitHub Actions 到最新版本

**总计提交**：15+ commits

---

### 🙏 致谢

感谢以下开源项目和服务：

- [AkShare](https://github.com/akfamily/akshare) - 开源金融数据接口
- [Server酱](https://sct.ftqq.com/) - 免费的微信推送服务
- [GitHub Actions](https://github.com/features/actions) - 免费的 CI/CD 服务
- [Pandas](https://pandas.pydata.org/) - 数据处理库

---

### 📞 联系方式

- **GitHub**: [@HeLuchao](https://github.com/HeLuchao)
- **项目地址**: [bond-monitor](https://github.com/HeLuchao/bond-monitor)
- **问题反馈**: [Issues](https://github.com/HeLuchao/bond-monitor/issues)

---

**[完整版本历史](https://github.com/HeLuchao/bond-monitor/commits/main)**
