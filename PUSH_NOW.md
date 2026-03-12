# 🚀 代码推送指南 - 立即操作

GitHub 仓库已创建，现在需要推送代码！

## ⚡ 最快方法（推荐）

运行交互式推送脚本：

```bash
cd /Users/heluchao/WorkBuddy/Claw/bond-monitor
./interactive_push.sh
```

脚本会引导你完成认证和推送。

---

## 📋 手动推送方法

### 方法一：使用 Personal Access Token（最简单）

#### 步骤 1：生成 Token
1. 访问：https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 勾选 `repo` 权限
4. 点击 "Generate token"
5. **复制 Token**（只显示一次）

#### 步骤 2：推送代码

运行以下命令（替换 `YOUR_TOKEN`）：

```bash
cd /Users/heluchao/WorkBuddy/Claw/bond-monitor
git push https://heluchao:YOUR_TOKEN@github.com/heluchao/bond-monitor.git main
```

或者使用带 Token 的 URL：

```bash
cd /Users/heluchao/WorkBuddy/Claw/bond-monitor
git remote set-url origin https://heluchao:YOUR_TOKEN@github.com/heluchao/bond-monitor.git
git push -u origin main
```

### 方法二：使用 SSH 密钥

#### 步骤 1：添加 SSH 公钥到 GitHub

```bash
# 1. 复制 SSH 公钥
cat ~/.ssh/id_rsa.pub | pbcopy
```

#### 步骤 2：在 GitHub 添加密钥
1. 访问：https://github.com/settings/keys
2. 点击 "New SSH key"
3. 粘贴公钥
4. 保存

#### 步骤 3：推送代码

```bash
cd /Users/heluchao/WorkBuddy/Claw/bond-monitor
git remote set-url origin git@github.com:heluchao/bond-monitor.git
git push -u origin main
```

---

## ✅ 推送成功后的下一步

### 1. 配置 GitHub Secrets

访问：https://github.com/heluchao/bond-monitor/settings/secrets/actions

添加以下 Secret：

- **Name**: `WECHAT_WEBHOOK_URL`
- **Value**: 你的企业微信 Webhook URL

### 2. 测试工作流

访问：https://github.com/heluchao/bond-monitor/actions

点击 "Run workflow" 手动触发测试。

### 3. 验证推送

检查企业微信群是否收到消息。

---

## 📊 当前仓库状态

- **本地提交数**: 6
- **远程仓库**: https://github.com/heluchao/bond-monitor.git
- **分支**: main

## 🆘 遇到问题？

### 问题：Permission denied (publickey)
**解决方案**：使用 Personal Access Token 方法

### 问题：Authentication failed
**解决方案**：
1. 检查 Token 是否正确
2. 确认 Token 有 `repo` 权限
3. 重新生成 Token

### 问题：远程仓库不存在
**解决方案**：确认仓库已在 GitHub 创建

---

## 📞 快速帮助

运行以下命令获取帮助：

```bash
cd /Users/heluchao/WorkBuddy/Claw/bond-monitor
./interactive_push.sh
```

或者查看详细文档：

```bash
cat PUSH_GUIDE.md
```
