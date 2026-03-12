# 🔐 GitHub Secrets 配置指南

## ✅ 代码推送成功！

代码已成功推送到 GitHub！

**📦 仓库地址**: https://github.com/HeLuchao/bond-monitor

---

## 📋 配置 GitHub Secrets

现在需要配置企业微信 Webhook URL，系统才能推送消息到你的微信。

### 步骤 1: 创建企业微信群机器人

#### 方法 1: 电脑端企业微信

1. 打开企业微信
2. 创建一个群（至少 3 人）
3. 点击群设置 → "群机器人" → "添加机器人"
4. 给机器人起个名字（如：新债监控助手）
5. 复制 Webhook URL（格式如下）：

```
https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

#### 方法 2: 手机端企业微信

1. 打开企业微信 App
2. 创建一个群（至少 3 人）
3. 点击群设置 → "群机器人" → "添加机器人"
4. 给机器人起个名字
5. 复制 Webhook URL

---

### 步骤 2: 在 GitHub 配置 Secret

1. 访问：**https://github.com/HeLuchao/bond-monitor/settings/secrets/actions**

2. 点击 "New repository secret"

3. 填写以下信息：
   - **Name**: `WECHAT_WEBHOOK_URL` （必须完全一致，区分大小写）
   - **Value**: 粘贴你的企业微信 Webhook URL

   示例：
   ```
   WECHAT_WEBHOOK_URL = https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   ```

4. 点击 "Add secret"

5. 确认 Secret 已成功添加

---

### 步骤 3: 验证配置

配置完成后，在 GitHub Secrets 页面应该能看到：

```
Actions secrets
WECHAT_WEBHOOK_URL • Updated just now
```

---

## 🧪 测试企业微信机器人

在配置 GitHub Secrets 之前，可以先测试企业微信机器人是否正常工作：

### 测试命令（在终端运行）

```bash
# 替换为你的 Webhook URL
WEBHOOK_URL="https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=YOUR_KEY"

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

**预期结果**: 企业微信群应该收到测试消息

---

## 🚀 配置完成后的步骤

### 步骤 1: 手动触发工作流测试

1. 访问：**https://github.com/HeLuchao/bond-monitor/actions**
2. 找到 "Daily Bond Query" 工作流
3. 点击 "Run workflow"
4. 选择分支：`main`
5. 点击 "Run workflow"

### 步骤 2: 查看执行日志

1. 点击正在运行的工作流
2. 查看每个步骤的执行状态：
   - ✅ Checkout repository
   - ✅ Set up Python
   - ✅ Install dependencies
   - ✅ Run bond query script
   - ✅ Upload logs
   - ✅ Upload data

3. 点击 "Run bond query script" 查看详细日志

### 步骤 3: 验证推送结果

检查企业微信群是否收到新债推送消息。

**预期消息格式**:
```
📊 新债监控日报 - 2026-03-12

🔍 发现新债:

1. 可转债
   - 代码: xxxxxx
   - 名称: 债券名称
   - 发行日期: 2026-03-xx
   - 规模: xx 亿元
   - 票面利率: x.xx%
   - 期限: xx 年
   - 主体评级: xx
```

---

## ⏰ 定时任务

配置完成后，系统将每天自动执行：

- **UTC 时间**: 01:00
- **北京时间**: 09:00
- **查询内容**: 可转债、企业债等新发行债券
- **推送方式**: 企业微信群机器人

---

## 🔍 故障排查

### 问题 1: Secret 配置后工作流仍然失败

**可能原因**:
- Secret 名称不正确（大小写敏感）
- Secret 值包含多余空格或换行
- Webhook URL 不正确

**解决方案**:
1. 确认 Secret 名称完全匹配：`WECHAT_WEBHOOK_URL`
2. 删除 Secret 重新添加，确保值正确
3. 测试 Webhook URL 是否有效（见上面的测试命令）

---

### 问题 2: 企业微信未收到消息

**可能原因**:
- Webhook URL 已过期或被禁用
- 群机器人被删除
- 网络连接问题

**解决方案**:
1. 在企业微信群重新添加机器人，获取新的 Webhook URL
2. 使用测试命令验证 Webhook URL
3. 查看工作流日志中的推送响应

---

### 问题 3: 工作流执行成功但无新债

**可能原因**:
- 当天确实没有新债发行
- 数据源问题

**解决方案**:
1. 查看工作流日志中的查询结果
2. 检查 AkShare API 是否正常
3. 第二天继续测试

---

## 📊 成功标志

配置成功的标志：

- ✅ GitHub Secrets 中有 `WECHAT_WEBHOOK_URL`
- ✅ 工作流所有步骤显示绿色勾号
- ✅ 企业微信群收到推送消息
- ✅ 日志文件和数据文件成功上传

---

## 📝 下一步

1. ✅ 配置 GitHub Secrets（当前步骤）
2. ✅ 测试企业微信机器人
3. ✅ 手动触发工作流
4. ✅ 验证推送结果
5. ✅ 等待第二天自动执行

---

## 🆘 快速链接

- **仓库主页**: https://github.com/HeLuchao/bond-monitor
- **Actions 页面**: https://github.com/HeLuchao/bond-monitor/actions
- **Secrets 配置**: https://github.com/HeLuchao/bond-monitor/settings/secrets/actions
- **工作流配置**: https://github.com/HeLuchao/bond-monitor/blob/main/.github/workflows/daily-query.yml

---

**现在请按照上述步骤配置 GitHub Secrets，然后测试工作流！**
