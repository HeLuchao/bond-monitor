# 新债监控自动化系统 - 部署指南

## 📋 前置条件

- GitHub 账号
- 企业微信账号
- 企业微信群（至少3人）

---

## 🚀 部署步骤

### 第一步：创建 GitHub 仓库

#### 方式一：使用自动化脚本（推荐）

在项目根目录下运行：

```bash
./setup_github.sh
```

按照脚本提示完成操作。

#### 方式二：手动创建

1. 打开浏览器，访问：https://github.com/new
2. 填写仓库信息：
   - Repository name: `bond-monitor`
   - Description: `新债监控自动化系统`
   - 选择 `Private`（私有）或 `Public`（公开）
   - **不要**勾选 "Initialize this repository with a README"
3. 点击 "Create repository"

### 第二步：推送代码到 GitHub

在项目根目录下执行：

```bash
# 添加远程仓库（替换 YOUR_USERNAME 为你的 GitHub 用户名）
git remote add origin https://github.com/YOUR_USERNAME/bond-monitor.git

# 推送代码
git push -u origin main
```

如果推送时需要身份验证，GitHub 会提示你使用 Personal Access Token 或密码。

### 第三步：配置企业微信机器人

1. 创建企业微信群（邀请至少2位好友，共3人）
2. 添加群机器人：
   - PC端：群聊 → 右上角三个点 → 添加群机器人
   - 手机端：群聊 → 右上角三个点 → 群机器人 → 添加机器人
3. 设置机器人名称（如"新债提醒"）
4. 复制 Webhook URL（格式：`https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxx`）

### 第四步：配置 GitHub Secrets

1. 打开你的 GitHub 仓库：`https://github.com/YOUR_USERNAME/bond-monitor`
2. 进入：`Settings` → `Secrets and variables` → `Actions`
3. 点击 `New repository secret`
4. 添加以下 Secret：

   | Name | Value |
   |------|-------|
   | `WECHAT_WEBHOOK_URL` | 你的企业微信 Webhook URL |

5. 点击 `Add secret`

### 第五步：测试工作流

1. 进入仓库的 `Actions` 标签
2. 点击 `Daily Bond Query` workflow
3. 点击 `Run workflow` → `Run workflow`
4. 等待执行完成
5. 查看执行日志
6. 检查企业微信群是否收到消息

### 第六步：验证定时任务

系统已配置为每天北京时间 **9:00**（UTC 1:00）自动执行。

第二天早上 9:00 后，检查：
1. GitHub Actions 执行记录
2. 企业微信群是否收到消息

---

## 🔧 本地测试

如果你想在本地测试，可以按照以下步骤操作：

### 1. 安装依赖

```bash
pip install -r requirements.txt
```

### 2. 配置环境变量

```bash
# 复制环境变量示例文件
cp .env.example .env

# 编辑 .env 文件，填入你的 Webhook URL
```

### 3. 运行脚本

```bash
python scripts/query_bond.py
```

---

## 📊 查看执行日志

### GitHub Actions 日志

1. 进入仓库的 `Actions` 标签
2. 点击对应的 workflow run
3. 点击对应的 job
4. 展开每个 step 查看详细日志

### 下载日志和数据

每次执行后，GitHub Actions 会自动上传日志和数据文件（保留7天）：

1. 进入对应的 workflow run
2. 在页面底部找到 `Artifacts` 部分
3. 下载 `logs-xxx` 和 `data-xxx`

---

## ⚙️ 自定义配置

### 修改执行时间

编辑 `.github/workflows/daily-query.yml` 文件：

```yaml
on:
  schedule:
    # 修改 cron 表达式
    # 格式：分 时 日 月 周（UTC 时区）
    - cron: '0 1 * * *'  # 每天 UTC 1:00（北京时间 9:00）
```

常见时间设置：
- `0 0 * * *`：每天 UTC 0:00（北京时间 8:00）
- `0 1 * * *`：每天 UTC 1:00（北京时间 9:00）
- `0 2 * * *`：每天 UTC 2:00（北京时间 10:00）
- `0 6 * * *`：每天 UTC 6:00（北京时间 14:00）

注意：GitHub Actions 使用 UTC 时区，请根据需要调整。

### 修改消息格式

编辑 `scripts/utils.py` 中的 `format_bond_info()` 函数：

```python
def format_bond_info(row):
    """格式化单条债券信息"""
    return f"""
> **债券名称**：{row.get('债券简称', 'N/A')}
> **债券代码**：{row.get('债券代码', 'N/A')}
> **发行日期**：{row.get('发行日期', 'N/A')}
> **发行规模**：{row.get('发行规模', 'N/A')}亿元
> **票面利率**：{row.get('票面利率', 'N/A')}%
> **期限**：{row.get('期限', 'N/A')}年
> **信用评级**：{row.get('信用评级', 'N/A')}
---
"""
```

### 过滤特定债券

编辑 `scripts/query_bond.py` 中的 `filter_new_bonds()` 函数，添加你自己的过滤逻辑。

---

## 🐛 常见问题

### Q1: GitHub Actions 执行失败

**可能原因：**
- GitHub Secrets 未正确配置
- 企业微信 Webhook URL 无效
- 网络问题

**解决方法：**
1. 检查 GitHub Secrets 是否正确添加
2. 测试企业微信 Webhook URL 是否有效
3. 查看执行日志，定位具体错误

### Q2: 未收到微信消息

**可能原因：**
- 企业微信机器人配置错误
- 筛选条件过于严格，没有新债
- Webhook URL 已过期

**解决方法：**
1. 检查企业微信机器人是否正常工作
2. 查看 GitHub Actions 日志，确认是否有新债数据
3. 重新配置企业微信机器人

### Q3: 定时任务未执行

**可能原因：**
- GitHub Actions 定时任务有延迟
- 仓库60天无活动被停用
- cron 表达式配置错误

**解决方法：**
1. GitHub Actions 定时任务可能会有几分钟到几小时的延迟
2. 保持仓库活跃度（定期提交代码）
3. 检查 cron 表达式是否正确

### Q4: 推送代码时身份验证失败

**可能原因：**
- 密码不再支持（GitHub 已弃用密码认证）
- 需要使用 Personal Access Token

**解决方法：**
1. 生成 Personal Access Token：
   - GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
   - 点击 "Generate new token (classic)"
   - 选择 `repo` 权限
   - 点击 "Generate token"
   - 复制 token
2. 推送时使用 token 作为密码：
   ```bash
   git push -u origin main
   # Username: YOUR_USERNAME
   # Password: YOUR_TOKEN
   ```

---

## 📚 相关资源

- [AkShare 文档](https://akshare.akfamily.xyz/)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [企业微信机器人 API](https://developer.work.weixin.qq.com/document/path/91770)
- [Cron 表达式生成器](https://crontab.guru/)

---

## ⚠️ 注意事项

1. **时区问题**：GitHub Actions 使用 UTC 时区，配置时请注意时区转换
2. **活跃度要求**：仓库60天无活动会停用定时任务，需保持一定活跃度
3. **发送频率限制**：企业微信机器人每个机器人每分钟最多发送20条消息
4. **隐私保护**：不要将 `.env` 文件提交到代码仓库
5. **免责声明**：本工具仅用于个人学习和研究，不构成任何投资建议

---

## 🆘 获取帮助

如果遇到问题，请：

1. 查看 GitHub Actions 执行日志
2. 检查本文档的"常见问题"部分
3. 提交 Issue 到 GitHub 仓库

---

## 📝 更新日志

- **2026-03-12**: 初始版本发布
  - 实现基础新债查询功能
  - 集成企业微信机器人推送
  - 配置 GitHub Actions 定时任务
