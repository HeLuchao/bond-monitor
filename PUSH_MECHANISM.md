# 推送机制说明

## 🔍 为什么没有收到推送？

### 推送触发条件

系统**只在有新债申购时**才会推送消息，具体条件：

```
查询条件：申购日期 = 今天 OR 明天
```

### 当前情况

- **今天日期**: 2026-03-12
- **明天日期**: 2026-03-13
- **最近申购**: 2026-03-09（长高转债）
- **结果**: 今天和明天都没有新债申购，所以**没有推送**

---

## 📊 实际债券数据

最近的申购日期：

| 债券代码 | 债券简称 | 申购日期 | 状态 |
|---------|---------|---------|------|
| 127113 | 长高转债 | 2026-03-09 | 已过期 |
| 113701 | 祥和转债 | 2026-03-03 | 已过期 |
| 118066 | 统联转债 | 2026-03-02 | 已过期 |

---

## ✅ 如何验证推送功能

### 方法1：运行测试脚本（推荐）

**本地测试**：
```bash
cd /Users/heluchao/WorkBuddy/Claw/bond-monitor
source venv/bin/activate
export SERVERCHAN_SENDKEY="SCT321629TV9CvNbMDefgPSwZRtqrJday0"
python test_push.py
```

**预期结果**：
- 终端显示 "✅ 推送成功！"
- 个人微信收到测试消息

---

### 方法2：启用每日状态通知

即使没有新债，也可以收到每日通知。

**步骤1：添加 GitHub Secret**

1. 访问：https://github.com/HeLuchao/bond-monitor/settings/secrets/actions
2. 点击 "New repository secret"
3. 填写：
   - **Name**: `SEND_DAILY_STATUS`
   - **Value**: `true`
4. 点击 "Add secret"

**步骤2：触发工作流**

重新运行 GitHub Actions，即使没有新债，也会收到每日状态通知。

**通知内容示例**：
```
新债监控日报

日期: 2026-03-12

数据统计:
- 总债券数量: 1006
- 今日申购: 0
- 明日申购: 0

最近申购债券:
- 长高转债 (127113)
  申购日期: 2026-03-09

---

💡 系统运行正常，暂无新债申购
```

---

### 方法3：修改筛选条件（临时测试）

**临时修改日期范围**，测试推送功能：

编辑 `scripts/query_bond.py`，找到 `filter_new_bonds` 函数，临时修改：

```python
# 原来的筛选条件
mask = (df['申购日期'].dt.strftime('%Y-%m-%d').isin([self.today, tomorrow]))

# 改为：筛选最近7天的债券（测试用）
recent_days = [(datetime.now() - pd.Timedelta(days=i)).strftime('%Y-%m-%d') for i in range(7)]
mask = (df['申购日期'].dt.strftime('%Y-%m-%d').isin(recent_days))
```

这样就能匹配到最近的债券，触发推送。

**注意**：测试完成后，记得改回原来的条件！

---

## 🎯 推送场景说明

### 场景1：有新债申购

**触发条件**：今天或明天有债券申购

**推送内容**：
```
新债监控日报

债券名称：长高转债
债券代码：127113
申购日期：2026-03-09
申购代码：072452
发行规模：10.00亿
转股价：15.50
信用评级：AA-
---
```

### 场景2：无新债申购

**默认行为**：不推送消息

**启用每日通知后**：发送每日状态通知

---

## 🔧 推送配置选项

### 必需配置

- `SERVERCHAN_SENDKEY`: Server酱的 SendKey（已配置 ✅）

### 可选配置

- `SEND_DAILY_STATUS`: 是否发送每日状态通知（默认: false）
  - `true`: 每天都发送通知（无论有无新债）
  - `false`: 只在有新债时发送

- `WECHAT_WEBHOOK_URL`: 企业微信群机器人 Webhook（可选）
  - 如果配置，会同时推送到企业微信群

---

## 📅 定时任务

- **执行时间**: 每天北京时间 9:00
- **查询内容**: 可转债申购信息
- **推送方式**: Server酱 → 个人微信
- **推送条件**: 有新债申购 OR 启用每日通知

---

## 🧪 验证清单

- [x] 本地测试推送成功
- [ ] GitHub Actions 执行成功
- [ ] 个人微信收到测试消息
- [ ] 配置 SEND_DAILY_STATUS（可选）
- [ ] 验证每日定时推送

---

## 📞 快速测试命令

### 本地测试（最快）
```bash
cd /Users/heluchao/WorkBuddy/Claw/bond-monitor
source venv/bin/activate
export SERVERCHAN_SENDKEY="SCT321629TV9CvNbMDefgPSwZRtqrJday0"
python test_push.py
```

### GitHub 测试
1. 访问 Actions 页面
2. 手动触发工作流
3. 查看执行日志
4. 检查个人微信

---

## 💡 常见问题

### Q1: 为什么本地测试成功，GitHub 上没有推送？

**A**: 因为今天没有新债申购，所以主脚本不会推送。

**解决方案**：
- 运行 `test_push.py` 测试推送功能
- 或配置 `SEND_DAILY_STATUS=true` 启用每日通知

### Q2: 如何确认系统正常工作？

**A**:
1. 本地运行 `test_push.py`，能收到消息说明推送正常
2. 查看 GitHub Actions 日志，显示 "任务执行完成" 说明脚本正常
3. 等待有新债申购时，系统会自动推送

### Q3: Server酱免费版够用吗？

**A**:
- 免费版每天5条消息
- 本项目每天最多1条
- 完全够用 ✅

---

## 🚀 推荐配置

**个人使用**：
- 只配置 `SERVERCHAN_SENDKEY`
- 不启用每日通知（默认）
- 有新债时才推送

**需要确认系统运行**：
- 配置 `SERVERCHAN_SENDKEY`
- 启用 `SEND_DAILY_STATUS=true`
- 每天收到状态通知

---

**现在请运行 `python test_push.py` 测试推送功能！**
