# 快速启动指南

5分钟快速部署新债监控系统，开始接收每日新债推送。

## 📋 前提条件

- GitHub 账号
- 微信（用于接收推送）

---

## 🚀 3步快速开始

### 第1步：Fork 仓库（1分钟）

1. 点击右上角 `Fork` 按钮
2. 确认 Fork 到你的账号

---

### 第2步：配置 Server酱（3分钟）

#### 2.1 获取 SendKey

1. 访问 [Server酱官网](https://sct.ftqq.com/)
2. 微信扫码登录
3. 进入「SendKey 管理」
4. 点击「生成 SendKey」
5. 复制 SendKey（格式：`SCTxxxxxxxxxxxxxxxx`）

#### 2.2 配置 GitHub Secrets

1. 进入你 Fork 的仓库
2. `Settings` → `Secrets and variables` → `Actions`
3. 点击 `New repository secret`
4. 填写：
   - **Name**: `SERVERCHAN_SENDKEY`
   - **Value**: 粘贴你的 SendKey
5. 点击 `Add secret`

---

### 第3步：测试运行（1分钟）

1. 进入 `Actions` 标签
2. 点击 `Daily Bond Query`
3. 点击 `Run workflow` → `Run workflow`
4. 等待执行完成（约2分钟）
5. 检查微信是否收到推送

---

## ✅ 成功标志

### 有新债申购

微信收到标题：`✅ 今日有X只新债申购`

### 无新债申购

- 默认：不推送
- 可选：配置 `SEND_DAILY_STATUS=true` 收到每日通知

---

## 🎯 下一步

### 可选配置

#### 1. 每日状态通知

即使无新债也收到通知：

1. 添加 Secret：
   - **Name**: `SEND_DAILY_STATUS`
   - **Value**: `true`

2. 每天收到推送：`❌ 今日无新债申购`

#### 2. 企业微信群推送

多人接收推送：

1. 参考 [企业微信群机器人指南](WECHAT_BOT_GUIDE.md)
2. 添加 Secret：
   - **Name**: `WECHAT_WEBHOOK_URL`
   - **Value**: 你的 Webhook URL

---

## 🔧 本地测试

```bash
# 克隆仓库
git clone https://github.com/你的用户名/bond-monitor.git
cd bond-monitor

# 安装依赖
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt

# 测试推送
export SERVERCHAN_SENDKEY="你的SendKey"
python test_push.py
```

---

## 📅 定时任务

- **执行时间**：每天北京时间 9:00
- **推送条件**：有新债申购
- **推送方式**：Server酱 → 个人微信

---

## ❓ 常见问题

### 没收到推送？

1. 检查 GitHub Actions 是否执行成功
2. 运行 `python test_push.py` 测试推送
3. 确认今天是否有新债申购
4. 查看 [故障排查指南](GITHUB_ACTIONS_TROUBLESHOOTING.md)

### 想修改推送时间？

编辑 `.github/workflows/daily-query.yml`：

```yaml
on:
  schedule:
    - cron: '0 1 * * *'  # UTC 时间
```

时间对照表：
- `0 0 * * *` = 北京时间 8:00
- `0 1 * * *` = 北京时间 9:00（默认）
- `0 2 * * *` = 北京时间 10:00

---

## 📚 更多文档

- [完整 README](README.md)
- [更新日志](CHANGELOG.md)
- [推送机制说明](PUSH_MECHANISM.md)
- [故障排查](GITHUB_ACTIONS_TROUBLESHOOTING.md)

---

## 🆘 获取帮助

- **问题反馈**: [GitHub Issues](https://github.com/HeLuchao/bond-monitor/issues)
- **项目地址**: [bond-monitor](https://github.com/HeLuchao/bond-monitor)

---

**祝你使用愉快！每天不错过新债申购！** 🎉
