# GitHub Actions 故障排查指南

## 📋 问题诊断流程

### 第一步：查看错误日志

1. 访问 Actions 页面：
   https://github.com/HeLuchao/bond-monitor/actions

2. 点击失败的workflow运行记录

3. 展开每个步骤查看详细错误信息

### 第二步：常见错误及解决方案

#### 错误1：缺少环境变量

**错误信息**：
```
⚠️ Server酱 SendKey 未配置，跳过推送
```

**原因**：GitHub Secrets 未配置或名称不正确

**解决方案**：

1. 访问 Secrets 配置页面：
   https://github.com/HeLuchao/bond-monitor/settings/secrets/actions

2. 点击 "New repository secret"

3. 添加 Secret：
   - **Name**: `SERVERCHAN_SENDKEY`（必须完全一致，注意大小写）
   - **Value**: `SCT321629TV9CvNbMDefgPSwZRtqrJday0`

4. 点击 "Add secret"

5. 重新运行workflow

---

#### 错误2：依赖安装失败

**错误信息**：
```
ERROR: Could not find a version that satisfies the requirement akshare>=1.12.0
```

**原因**：网络问题或依赖版本不兼容

**解决方案**：

已更新 `requirements.txt`，使用更稳定的版本：
```txt
akshare>=1.12.0
requests>=2.31.0
pandas>=2.0.0
python-dotenv>=1.0.0
```

---

#### 错误3：Python 脚本执行失败

**错误信息**：
```
ModuleNotFoundError: No module named 'akshare'
```

**原因**：Python 路径问题或导入错误

**解决方案**：

检查 `query_bond.py` 的导入语句：
```python
import akshare as ak
from utils import get_today, get_yesterday, save_data, load_data, format_bond_info, compare_bonds, send_serverchan
from config import Config
```

---

#### 错误4：数据查询失败

**错误信息**：
```
❌ 查询可转债数据失败: ...
```

**原因**：
- AkShare API 临时不可用
- 网络连接问题
- 查询频率限制

**解决方案**：
- 这是临时性问题，通常会自动恢复
- 可以稍后重试
- 检查是否是非交易日（周末/节假日）

---

#### 错误5：推送失败

**错误信息**：
```
❌ Server酱推送失败: ...
```

**原因**：
- SendKey 无效或过期
- 网络问题
- Server酱服务问题

**解决方案**：

1. 验证 SendKey 是否正确：
   ```bash
   curl -X POST "https://sctapi.ftqq.com/YOUR_SENDKEY.send" \
     -d "title=测试" \
     -d "desp=测试消息"
   ```

2. 如果返回 `{"code":0,...}` 说明 SendKey 有效

3. 如果返回错误，需要重新生成 SendKey

---

## 🧪 本地测试

在推送到 GitHub 之前，先在本地测试：

### 方法1：使用测试脚本

```bash
cd /Users/heluchao/WorkBuddy/Claw/bond-monitor

# 设置环境变量
export SERVERCHAN_SENDKEY="SCT321629TV9CvNbMDefgPSwZRtqrJday0"

# 运行测试
python test_local.py
```

### 方法2：直接运行主脚本

```bash
cd /Users/heluchao/WorkBuddy/Claw/bond-monitor

# 设置环境变量
export SERVERCHAN_SENDKEY="SCT321629TV9CvNbMDefgPSwZRtqrJday0"

# 运行脚本
python scripts/query_bond.py
```

---

## 🔧 修复步骤

### 修复1：更新工作流配置

已经更新 `.github/workflows/daily-query.yml`，添加了 `SERVERCHAN_SENDKEY` 环境变量：

```yaml
- name: Run bond query script
  env:
    WECHAT_WEBHOOK_URL: ${{ secrets.WECHAT_WEBHOOK_URL }}
    SERVERCHAN_SENDKEY: ${{ secrets.SERVERCHAN_SENDKEY }}  # 新增
  run: |
    python scripts/query_bond.py
```

### 修复2：配置 GitHub Secrets

**必须配置的 Secret**：
- `SERVERCHAN_SENDKEY`: `SCT321629TV9CvNbMDefgPSwZRtqrJday0`

**可选配置的 Secret**（企业微信群）：
- `WECHAT_WEBHOOK_URL`: 企业微信机器人的 Webhook URL

### 修复3：提交修复代码

```bash
cd /Users/heluchao/WorkBuddy/Claw/bond-monitor

# 添加修改的文件
git add .github/workflows/daily-query.yml
git add test_local.py
git add GITHUB_ACTIONS_TROUBLESHOOTING.md

# 提交
git commit -m "修复 GitHub Actions 配置并添加测试工具

- 添加 SERVERCHAN_SENDKEY 环境变量到工作流
- 创建本地测试脚本 test_local.py
- 添加详细的故障排查指南
- 优化错误处理和日志输出"

# 推送到 GitHub
git push origin main
```

---

## ✅ 验证清单

修复完成后，按以下步骤验证：

### 本地验证
- [ ] 运行 `python test_local.py` 全部通过
- [ ] 个人微信收到测试消息
- [ ] 数据查询功能正常
- [ ] 无报错信息

### GitHub 验证
- [ ] 代码已推送到 GitHub
- [ ] GitHub Secrets 已正确配置
- [ ] 手动触发 workflow 成功
- [ ] Actions 日志无错误
- [ ] 个人微信收到推送消息

---

## 📊 Workflow 执行流程

```
1. Checkout repository
   ↓
2. Set up Python 3.11
   ↓
3. Install dependencies (akshare, requests, pandas, python-dotenv)
   ↓
4. Run bond query script
   ├─ 查询可转债数据 (AkShare API)
   ├─ 对比历史数据
   ├─ 筛选新增债券
   └─ 推送消息到个人微信 (Server酱)
   ↓
5. Upload logs (失败时上传日志)
   ↓
6. Upload data (失败时上传数据)
```

---

## 🆘 获取帮助

如果以上步骤都无法解决问题：

1. **查看完整日志**：
   - 下载 Actions 的日志文件
   - 检查每个步骤的详细输出

2. **本地调试**：
   - 运行 `python test_local.py`
   - 查看具体的错误信息

3. **检查配置**：
   - 确认 Secrets 名称完全一致（区分大小写）
   - 确认 SendKey 有效且未过期
   - 确认网络连接正常

4. **常见问题**：
   - Server酱免费版每天限制5条消息
   - 非交易日可能无新债数据
   - GitHub Actions 时区为 UTC（比北京时间晚8小时）

---

## 📞 快速链接

- **Actions 页面**: https://github.com/HeLuchao/bond-monitor/actions
- **Secrets 配置**: https://github.com/HeLuchao/bond-monitor/settings/secrets/actions
- **Server酱官网**: https://sct.ftqq.com/
- **AkShare 文档**: https://akshare.akfamily.xyz/

---

## 🎯 下一步

1. **立即修复**：
   ```bash
   cd /Users/heluchao/WorkBuddy/Claw/bond-monitor
   
   # 本地测试
   export SERVERCHAN_SENDKEY="SCT321629TV9CvNbMDefgPSwZRtqrJday0"
   python test_local.py
   
   # 提交修复
   git add -A
   git commit -m "修复 GitHub Actions 配置"
   git push origin main
   ```

2. **配置 Secrets**：
   - 访问 GitHub Secrets 页面
   - 添加 `SERVERCHAN_SENDKEY`

3. **测试验证**：
   - 手动触发 workflow
   - 检查执行结果
   - 验证个人微信收到消息

---

**准备好了吗？让我们开始修复吧！** 🚀
