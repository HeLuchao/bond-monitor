# 🔑 新 SSH 密钥添加指南

## ✅ 密钥已生成

新的 SSH 密钥已成功生成并复制到剪贴板！

**密钥类型**: ED25519（更安全、更现代）
**密钥指纹**: `SHA256:NrY8H3cMWVxuYmI4EOHXuPaMTrBWtTzuBWFQ/HKPpnE`

---

## 📋 在 GitHub 添加 SSH 密钥

### 步骤 1: 打开 GitHub SSH 设置

访问：**https://github.com/settings/keys**

---

### 步骤 2: 添加新的 SSH 密钥

1. 点击绿色的 "New SSH key" 按钮
2. 填写以下信息：
   - **Title**: `WorkBuddy Bond Monitor (ED25519)` 或任意名称
   - **Key type**: `Authentication Key`（默认）
   - **Key**: 粘贴剪贴板中的内容（已自动复制）
     ```
     ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMvsYOsDxBr8GrpnYdtSFp4ZSD1NMuRh7VBbYio1GbHJ heluchao@workbuddy
     ```
3. 点击 "Add SSH key"

---

### 步骤 3: 测试 SSH 连接

添加完成后，在终端运行以下命令测试：

```bash
ssh -T git@github.com
```

**预期输出**:
```
Hi heluchao! You've successfully authenticated, but GitHub does not provide shell access.
```

如果看到这个消息，说明 SSH 连接成功！

---

## 🚀 推送代码到 GitHub

SSH 连接成功后，运行以下命令推送代码：

```bash
cd /Users/heluchao/WorkBuddy/Claw/bond-monitor
git push -u origin main
```

---

## 📊 当前项目状态

- **本地提交**: 7 个
- **远程仓库**: https://github.com/heluchao/bond-monitor.git
- **SSH 密钥**: 已生成 ED25519 密钥
- **状态**: 准备推送

---

## 🔍 故障排查

### 问题 1: "Permission denied (publickey)"

**原因**: SSH 密钥未添加到 GitHub

**解决方案**:
1. 确认已在 GitHub 添加公钥
2. 确认公钥内容完整（从 `ssh-ed25519` 开始）
3. 检查 GitHub 账号是否正确

---

### 问题 2: "Connection refused"

**原因**: 网络问题或 GitHub 服务不可用

**解决方案**:
1. 检查网络连接
2. 尝试访问 https://github.com
3. 稍后重试

---

### 问题 3: "Key already in use"

**原因**: 该密钥已添加到其他 GitHub 账号

**解决方案**:
- 需要为每个账号生成单独的 SSH 密钥

---

## 💡 提示

1. **旧密钥备份**: 旧的 SSH 密钥已备份到 `~/.ssh/backup/` 目录
2. **密钥安全**: 私钥 `id_ed25519` 已设置为只读权限，不要分享给他人
3. **多设备**: 如果需要在其他设备使用，需要单独生成密钥

---

## 📝 下一步

1. ✅ 在 GitHub 添加 SSH 密钥
2. ✅ 测试 SSH 连接
3. ✅ 推送代码到 GitHub
4. ✅ 配置 GitHub Secrets (WECHAT_WEBHOOK_URL)
5. ✅ 测试 GitHub Actions 工作流

---

## 🆘 快速命令

```bash
# 测试 SSH 连接
ssh -T git@github.com

# 推送代码
cd /Users/heluchao/WorkBuddy/Claw/bond-monitor
git push -u origin main

# 查看远程仓库配置
git remote -v

# 查看提交历史
git log --oneline
```

---

**SSH 公钥已复制到剪贴板，现在可以按照上述步骤添加到 GitHub 了！**
