# 个人微信消息推送配置指南

## 推荐方案：Server酱（ServerChan）

Server酱是最流行、最简单的个人微信消息推送方案，5分钟即可配置完成！

## 为什么选择 Server酱？

- ✅ **超级简单**：5分钟完成配置
- ✅ **推送到微信**：直接在个人微信接收
- ✅ **无需企业认证**：个人账号即可使用
- ✅ **免费额度充足**：每天5条消息（完全够用）
- ✅ **稳定可靠**：官方维护，服务稳定
- ✅ **支持多种消息**：文本、Markdown、图片等

## 配置步骤（5分钟）

### 步骤 1：注册 Server酱账号（2分钟）

1. **访问官网**：https://sct.ftqq.com/

2. **微信扫码注册**：
   - 点击「微信登录」或「扫码登录」
   - 使用微信扫描二维码
   - 授权登录

3. **登录后台**：
   - 登录后会自动跳转到后台
   - 绑定你的微信账号

---

### 步骤 2：获取 SendKey（2分钟）

1. **进入 SendKey 管理**：
   - 在后台左侧菜单找到「SendKey」
   - 点击「SendKey 管理」

2. **生成 SendKey**：
   - 点击「生成 SendKey」按钮
   - 系统会自动生成一个 SendKey

3. **复制 SendKey**：
   - 复制生成的 SendKey
   - 格式类似：`SCT1234567890abcdef1234567890abcdef`

4. **保存 SendKey**：
   - 将 SendKey 保存到安全的地方
   - 后续配置需要用到

---

### 步骤 3：测试推送（1分钟）

在终端运行以下命令测试：

```bash
# 替换为你的 SendKey
SENDKEY="YOUR_SENDKEY_HERE"
TITLE="测试消息"
CONTENT="这是一条测试消息，Server酱配置成功！"

curl -X POST "https://sctapi.ftqq.com/$SENDKEY.send" \
  -d "title=$TITLE" \
  -d "desp=$CONTENT"
```

**预期结果**：
- 返回：`{"code":0,"message":"OK","data":{...}}`
- 个人微信收到测试消息

---

### 步骤 4：修改项目代码

#### 4.1 修改 scripts/config.py

添加 Server酱配置：

```python
# Server酱配置
SERVERCHAN_SENDKEY = os.getenv("SERVERCHAN_SENDKEY", "")
```

#### 4.2 修改 scripts/utils.py

在文件末尾添加 Server酱推送函数：

```python
def send_serverchan(title, content, sendkey):
    """通过 Server酱发送消息到个人微信"""
    if not sendkey:
        logger.warning("Server酱 SendKey 未配置，跳过推送")
        return False
    
    url = f"https://sctapi.ftqq.com/{sendkey}.send"
    data = {
        "title": title,
        "desp": content
    }
    
    try:
        response = requests.post(url, data=data, timeout=10)
        result = response.json()
        
        if result.get("code") == 0:
            logger.info(f"Server酱推送成功: {title}")
            return True
        else:
            logger.error(f"Server酱推送失败: {result}")
            return False
            
    except Exception as e:
        logger.error(f"Server酱推送异常: {e}")
        return False
```

#### 4.3 修改 scripts/query_bond.py

找到推送消息的部分，添加 Server酱推送：

在 `main()` 函数中，找到推送消息的代码（在 `send_wechat_message()` 调用之后），添加：

```python
# 通过 Server酱推送到个人微信
if config.SERVERCHAN_SENDKEY:
    logger.info("正在通过 Server酱推送消息到个人微信...")
    utils.send_serverchan(
        title=f"新债监控日报 - {date_str}",
        content=message_text,
        sendkey=config.SERVERCHAN_SENDKEY
    )
```

---

### 步骤 5：在 GitHub 添加 Secret（2分钟）

1. **访问 GitHub Secrets 页面**：
   https://github.com/HeLuchao/bond-monitor/settings/secrets/actions

2. **添加 Secret**：
   - 点击「New repository secret」
   - 填写：
     - **Name**: `SERVERCHAN_SENDKEY`（必须完全一致）
     - **Value**: 粘贴你的 SendKey
   - 点击「Add secret」

3. **确认配置**：
   - 在 Secrets 页面应该能看到：
     ```
     Actions secrets
     SERVERCHAN_SENDKEY • Updated just now
     ```

---

## 🎉 配置完成！

现在你的系统可以通过 Server酱推送到个人微信了！

## 测试工作流

1. **访问 Actions 页面**：
   https://github.com/HeLuchao/bond-monitor/actions

2. **手动触发工作流**：
   - 找到「Daily Bond Query」工作流
   - 点击「Run workflow」
   - 选择分支：main
   - 点击「Run workflow」

3. **查看执行日志**：
   - 查看各个步骤的执行状态
   - 检查是否有错误

4. **验证推送结果**：
   - 检查个人微信是否收到新债推送消息

---

## 消息格式示例

推送到个人微信的消息格式：

```
📊 新债监控日报 - 2026-03-12

🔍 发现新债:

1. 可转债
   - 代码: 123456
   - 名称: 测试转债
   - 发行日期: 2026-03-15
   - 规模: 10.00 亿元
   - 票面利率: 1.50%
   - 期限: 5 年
   - 主体评级: AAA

查询时间: 2026-03-12 09:00:00
```

---

## 支持的同时推送

配置 Server酱后，你可以**同时**使用：

- ✅ Server酱 → 推送到个人微信
- ✅ 企业微信群机器人 → 推送到企业微信群

在 `scripts/config.py` 中同时配置：

```python
# Server酱配置
SERVERCHAN_SENDKEY = os.getenv("SERVERCHAN_SENDKEY", "")

# 企业微信机器人配置
WECHAT_WEBHOOK_URL = os.getenv("WECHAT_WEBHOOK_URL", "")
```

在 `scripts/query_bond.py` 中同时调用：

```python
# 推送到个人微信（Server酱）
if config.SERVERCHAN_SENDKEY:
    utils.send_serverchan(
        title=f"新债监控日报 - {date_str}",
        content=message_text,
        sendkey=config.SERVERCHAN_SENDKEY
    )

# 推送到企业微信群
if config.WECHAT_WEBHOOK_URL:
    send_wechat_message(
        message_text,
        config.WECHAT_WEBHOOK_URL
    )
```

---

## 高级功能

### 1. Markdown 格式

Server酱支持 Markdown 格式：

```python
content = """
# 新债监控日报

## 发现新债

| 代码 | 名称 | 利率 | 期限 |
|------|------|------|------|
| 123456 | 测试转债 | 1.50% | 5年 |
"""

utils.send_serverchan(
    title="新债监控",
    content=content,
    sendkey=sendkey
)
```

### 2. 添加时间戳

```python
from datetime import datetime

timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
content = f"""
新债监控日报

查询时间: {timestamp}

{bond_details}
"""
```

### 3. 多条消息

如果有多条消息，可以循环发送：

```python
for bond in new_bonds:
    utils.send_serverchan(
        title=f"新债提醒: {bond['name']}",
        content=f"代码: {bond['code']}\n利率: {bond['rate']}",
        sendkey=sendkey
    )
```

---

## 常见问题

### Q1: Server酱免费吗？

**A**: 是的，Server酱提供免费服务：
- 免费版：每天5条消息
- 付费版：每天1000条消息（¥5/月）

对于新债监控（每天1条），免费版完全够用！

---

### Q2: 消息会延迟吗？

**A**: 通常不会有明显延迟，几秒内就能收到。

---

### Q3: 可以推送图片吗？

**A**: 可以，Server酱支持推送图片，需要使用图片URL。

---

### Q4: 可以推送给多人吗？

**A**: Server酱只能推送给绑定的微信账号。如果需要推送给多人：
- 方案1：让每个人注册 Server酱，配置不同的 SendKey
- 方案2：使用企业微信群机器人（当前方案）

---

### Q5: SendKey 泄露了怎么办？

**A**:
1. 立即在 Server酱后台删除 SendKey
2. 重新生成新的 SendKey
3. 更新 GitHub Secrets
4. 测试新的 SendKey 是否有效

---

### Q6: 如何查看发送历史？

**A**: 登录 Server酱后台，可以查看发送历史和统计信息。

---

### Q7: 推送失败了怎么办？

**A**:
1. 检查 SendKey 是否正确
2. 检查网络连接
3. 查看 GitHub Actions 日志
4. 在 Server酱后台查看发送记录

---

## 🆘 快速参考

### Server酱相关

- **官网**: https://sct.ftqq.com/
- **文档**: https://sct.ftqq.com/forward
- **SendKey 管理**: 登录后台查看

### GitHub 相关

- **Secrets 配置**: https://github.com/HeLuchao/bond-monitor/settings/secrets/actions
- **Actions 页面**: https://github.com/HeLuchao/bond-monitor/actions
- **仓库主页**: https://github.com/HeLuchao/bond-monitor

### 项目相关

- **配置文件**: `scripts/config.py`
- **工具函数**: `scripts/utils.py`
- **主脚本**: `scripts/query_bond.py`

---

## 📋 配置检查清单

配置完成后，确认以下几点：

- ✅ 已注册 Server酱账号
- ✅ 已获取 SendKey
- ✅ 已测试 SendKey 有效
- ✅ 已修改 Python 代码（config.py, utils.py, query_bond.py）
- ✅ 已在 GitHub 添加 SERVERCHAN_SENDKEY Secret
- ✅ 已手动触发工作流测试
- ✅ 个人微信已收到测试消息

---

## 需要我帮你修改代码吗？

如果你想切换到 Server酱，我可以帮你：

1. ✅ 修改 `scripts/config.py` 添加配置
2. ✅ 修改 `scripts/utils.py` 添加推送函数
3. ✅ 修改 `scripts/query_bond.py` 添加推送逻辑
4. ✅ 提交并推送到 GitHub

只需要你：
1. 注册 Server酱账号
2. 获取 SendKey
3. 告诉我 SendKey

我会帮你完成所有代码修改！

---

**现在开始配置 Server酱，5分钟后就能在个人微信接收新债推送了！**
