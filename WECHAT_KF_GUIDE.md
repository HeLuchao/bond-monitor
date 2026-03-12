# 企业微信客服消息推送配置指南

## 概述

企业微信客服消息相比群机器人的优势：

**优势**：
- 支持推送到个人
- 无群成员限制
- 更丰富的消息类型
- 更好的权限控制

**劣势**：
- 配置更复杂
- 需要企业认证
- 需要配置 API 密钥

## 方案对比

| 特性 | 群机器人 | 客服消息 | Server酱 |
|------|---------|---------|---------|
| 推送对象 | 群聊 | 个人 | 微信 |
| 群成员限制 | 至少3人 | 无限制 | 无限制 |
| 配置难度 | 简单 | 复杂 | 最简单 |
| 权限要求 | 无 | 企业认证 | 无 |

## 推荐方案：Server酱（最简单）

### 为什么推荐 Server酱？

1. 配置超级简单，5分钟搞定
2. 无需企业认证，个人可用
3. 直接推送到微信
4. 免费额度充足（每天5条）
5. 完美满足个人使用需求

### 配置步骤

#### 步骤1：注册账号

1. 访问：https://sct.ftqq.com/
2. 微信扫码注册
3. 登录后台

#### 步骤2：获取 SendKey

1. 进入「SendKey 管理」
2. 点击「生成 SendKey」
3. 复制 SendKey

#### 步骤3：测试推送

```python
import requests

SENDKEY = "YOUR_SENDKEY"
title = "测试消息"
content = "这是一条测试消息"

url = f"https://sctapi.ftqq.com/{SENDKEY}.send"
data = {
    "title": title,
    "desp": content
}

response = requests.post(url, data=data)
print(response.json())
```

### 修改项目代码

#### 1. 修改 scripts/utils.py

添加 Server酱推送函数：

```python
def send_serverchan(title, content, sendkey):
    """通过 Server酱发送消息"""
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

#### 2. 修改 scripts/config.py

添加配置：

```python
# Server酱配置
SERVERCHAN_SENDKEY = os.getenv("SERVERCHAN_SENDKEY", "")
```

#### 3. 修改 scripts/query_bond.py

在推送逻辑中添加 Server酱选项：

```python
# 在推送函数中
if config.SERVERCHAN_SENDKEY:
    utils.send_serverchan(
        title="新债监控日报",
        content=message_text,
        sendkey=config.SERVERCHAN_SENDKEY
    )
```

#### 4. 在 GitHub 添加 Secret

1. 访问：https://github.com/HeLuchao/bond-monitor/settings/secrets/actions
2. 点击 "New repository secret"
3. 添加：
   - Name: `SERVERCHAN_SENDKEY`
   - Value: 你的 SendKey

## 方案对比总结

### 当前方案：群机器人

**适合**：多人同时接收
**优势**：已配置完成，免费
**劣势**：需要创建群（至少3人）

### 推荐方案：Server酱

**适合**：个人使用
**优势**：配置最简单，推送到微信，无需群
**劣势**：每天限制5条消息（足够用）

### 企业微信应用消息

**适合**：企业内部用户
**优势**：推送到企业微信内部
**劣势**：需要企业认证

### 企业微信客服消息

**适合**：对外客户服务
**优势**：专业功能
**劣势**：配置最复杂

## 我的建议

根据你的需求「新债监控+个人使用」，我强烈推荐使用 **Server酱**：

1. **配置最简单**：5分钟完成
2. **推送到微信**：直接在微信接收
3. **无需创建群**：一个人就够了
4. **免费额度充足**：每天5条，完全够用
5. **稳定可靠**：官方维护

## 需要我帮你修改代码吗？

如果你想切换到 Server酱，我可以帮你：

1. 修改 Python 脚本，添加 Server酱推送功能
2. 更新配置文件
3. 创建迁移指南
4. 推送到 GitHub

只需要你：
1. 注册 Server酱账号
2. 获取 SendKey
3. 告诉我 SendKey

我会帮你完成所有代码修改！
