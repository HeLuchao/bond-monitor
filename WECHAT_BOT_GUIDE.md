# 🤖 企业微信群机器人创建指南

## 📋 前置条件

创建企业微信群机器人需要满足以下条件：

- ✅ 已安装企业微信（电脑端或手机端）
- ✅ 有企业微信账号
- ✅ 创建一个群（至少 3 人）

---

## 💻 方法一：电脑端企业微信（推荐）

### 步骤 1: 创建企业微信群

1. **打开企业微信**（电脑端）
2. 点击左侧的「+」号或「通讯录」
3. 选择「发起群聊」
4. 选择至少 3 个联系人（包括你自己）
5. 点击「确定」创建群

**提示**:
- 群成员至少需要 3 人
- 可以邀请同事、朋友或家人
- 可以创建测试群，测试成功后可以删除

---

### 步骤 2: 添加群机器人

1. **进入刚创建的群聊**
2. 点击群聊右上角的「...」（群设置）
3. 在弹出的菜单中找到「群机器人」
4. 点击「群机器人」
5. 点击「添加机器人」

---

### 步骤 3: 配置机器人

1. **给机器人起个名字**，例如：
   - `新债监控助手`
   - `债券推送机器人`
   - `每日新债提醒`

2. 点击「确定」或「添加」

3. **复制 Webhook URL**（非常重要！）
   - 系统会自动生成一个 Webhook URL
   - 格式如下：
     ```
     https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
     ```
   - 点击「复制」按钮复制这个 URL

4. **保存 Webhook URL**
   - 将这个 URL 保存到记事本或剪贴板
   - 后续配置 GitHub Secrets 时需要用到

---

### 步骤 4: 测试机器人（可选）

1. 在群里发送一条消息，看看机器人是否在线
2. 或者先完成 GitHub 配置，通过测试工作流来验证

---

## 📱 方法二：手机端企业微信

### 步骤 1: 创建企业微信群

1. **打开企业微信 App**（手机端）
2. 点击底部的「+」号
3. 选择「发起群聊」
4. 选择至少 3 个联系人
5. 点击「确定」创建群

---

### 步骤 2: 添加群机器人

1. **进入刚创建的群聊**
2. 点击群聊右上角的「...」（群设置）
3. 找到「群机器人」选项
4. 点击「群机器人」
5. 点击「添加机器人」

---

### 步骤 3: 配置机器人

1. **给机器人起个名字**
2. 点击「确定」
3. **复制 Webhook URL**
   - 系统会生成一个 Webhook URL
   - 点击「复制」按钮复制 URL
4. **保存 Webhook URL** 到剪贴板或记事本

---

## 🔑 Webhook URL 说明

### 格式

```
https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

### 组成部分

- `https://qyapi.weixin.qq.com/cgi-bin/webhook/send` - 企业微信 API 地址
- `?key=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx` - 你的机器人唯一标识

### 重要提示

⚠️ **请妥善保管你的 Webhook URL**：
- 不要分享给他人
- 不要公开到网上
- 每个机器人的 Webhook URL 是唯一的
- 如果泄露了，可以删除机器人重新创建

---

## 🧪 测试 Webhook URL

在配置 GitHub Secrets 之前，可以先测试 Webhook URL 是否正常工作。

### 方法一：使用 curl（终端）

```bash
# 替换为你的 Webhook URL
WEBHOOK_URL="https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=YOUR_KEY_HERE"

# 发送测试消息
curl -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d '{
    "msgtype": "text",
    "text": {
      "content": "🧪 测试消息\n\n新债监控系统测试成功！"
    }
  }'
```

### 方法二：使用 Python

```python
import requests

# 替换为你的 Webhook URL
webhook_url = "https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=YOUR_KEY_HERE"

# 发送测试消息
data = {
    "msgtype": "text",
    "text": {
        "content": "🧪 测试消息\n\n新债监控系统测试成功！"
    }
}

response = requests.post(webhook_url, json=data)
print(response.json())
```

**预期结果**:
- 返回 `{"errcode":0,"errmsg":"ok"}` 表示成功
- 企业微信群收到测试消息

---

## 🔧 常见问题

### Q1: 为什么群里至少需要 3 个人？

**A**: 企业微信群机器人要求群成员至少 3 人才能添加。这是企业微信的限制。

**解决方案**:
- 邀请同事或朋友加入群
- 可以创建测试群，测试完成后可以删除
- 也可以使用自己创建的多个账号（如果有的话）

---

### Q2: 可以在哪些群添加机器人？

**A**: 只能在企业微信群中添加机器人，不能在普通微信群添加。

**解决方案**:
- 确保你在企业微信群中
- 企业微信群有明显的标识（通常有企业名称）

---

### Q3: Webhook URL 有有效期吗？

**A**: 不会过期。只要机器人没有被删除，Webhook URL 就一直有效。

**注意事项**:
- 如果机器人被删除，Webhook URL 会失效
- 建议定期检查机器人是否在线
- 可以在群里发送消息测试

---

### Q4: 一个群可以添加多少个机器人？

**A**: 一个群最多可以添加 5 个机器人。

**解决方案**:
- 如果需要更多机器人，可以创建多个群
- 每个机器人的 Webhook URL 是独立的

---

### Q5: 机器人可以发送什么类型的消息？

**A**: 企业微信群机器人支持以下消息类型：

- ✅ 文本消息（text）- 本系统使用
- ✅ Markdown 消息（markdown）
- ✅ 图片消息（image）
- ✅ 图文消息（news）
- ✅ 文件消息（file）
- ✅ 模板卡片消息（template_card）

本系统使用**文本消息**，格式简洁清晰。

---

### Q6: 如何删除机器人？

**A**: 删除机器人的步骤：

1. 进入群设置
2. 点击「群机器人」
3. 找到要删除的机器人
4. 点击「删除」

**注意**: 删除机器人后，Webhook URL 会失效，需要重新创建。

---

### Q7: 机器人发送消息有频率限制吗？

**A**: 有，每个机器人每分钟最多发送 20 条消息。

**解决方案**:
- 本系统每天只发送 1 次，不会超过限制
- 如果需要频繁发送，可以创建多个机器人

---

## 📝 创建完成检查清单

创建完成后，确认以下几点：

- ✅ 企业微信群已创建（至少 3 人）
- ✅ 群机器人已添加
- ✅ 机器人已命名
- ✅ Webhook URL 已复制
- ✅ Webhook URL 已保存到安全位置
- ✅ 可选：Webhook URL 已测试成功

---

## 🎯 下一步

1. ✅ 创建企业微信群机器人（当前步骤）
2. 复制 Webhook URL
3. 在 GitHub 配置 Secrets:
   - 访问：https://github.com/HeLuchao/bond-monitor/settings/secrets/actions
   - 添加 Secret: `WECHAT_WEBHOOK_URL`
   - 值: 粘贴你的 Webhook URL
4. 手动触发工作流测试
5. 验证企业微信是否收到消息

---

## 🆘 获取帮助

如果遇到问题：

1. 查看企业微信官方文档：
   https://developer.work.weixin.qq.com/document/path/91770

2. 检查 Webhook URL 是否正确
3. 确认企业微信群是否为企业微信群
4. 尝试测试命令验证 Webhook URL

---

**现在开始创建企业微信群机器人，获取 Webhook URL，然后在 GitHub 配置 Secrets！**
