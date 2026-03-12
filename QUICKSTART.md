# 🚀 快速启动指南

## 一键启动（推荐）

```bash
# 1. 运行自动化设置脚本
./setup_github.sh

# 2. 按照提示完成 GitHub 仓库创建

# 3. 在 GitHub 仓库中配置 WECHAT_WEBHOOK_URL Secret

# 4. 手动触发一次测试
# 访问：https://github.com/YOUR_USERNAME/bond-monitor/actions
# 点击 "Daily Bond Query" → "Run workflow"
```

---

## 手动启动步骤

### 1️⃣ 创建 GitHub 仓库

访问：https://github.com/new
- 仓库名：`bond-monitor`
- 选择 Private 或 Public
- 不初始化 README

### 2️⃣ 推送代码

```bash
git remote add origin https://github.com/YOUR_USERNAME/bond-monitor.git
git push -u origin main
```

### 3️⃣ 配置企业微信机器人

1. 创建企业微信群（3人以上）
2. 添加群机器人，复制 Webhook URL

### 4️⃣ 配置 GitHub Secrets

在 GitHub 仓库中：
- Settings → Secrets and variables → Actions
- 添加 Secret：
  - Name: `WECHAT_WEBHOOK_URL`
  - Value: 你的 Webhook URL

### 5️⃣ 测试运行

访问 GitHub 仓库的 Actions 页面，手动触发一次测试。

---

## 📞 查看详细文档

- [完整部署指南](DEPLOYMENT_GUIDE.md)
- [项目说明](README.md)

---

## ✅ 检查清单

部署前，请确认以下事项：

- [ ] 已创建 GitHub 账号
- [ ] 已创建企业微信账号
- [ ] 已创建企业微信群（至少3人）
- [ ] 已添加企业微信机器人
- [ ] 已复制企业微信 Webhook URL
- [ ] 已阅读部署指南

---

## 🎉 完成后

系统将在每天北京时间 9:00 自动运行，检查新债并发送微信提醒。
