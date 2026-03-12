# 🚀 GitHub 仓库创建和代码推送指南

## 📋 前置条件

- ✅ Git 远程仓库已配置：`https://github.com/heluchao/bond-monitor.git`
- ✅ 本地代码已提交到 Git 仓库（4个提交）

---

## 🎯 第一步：创建 GitHub 仓库

### 方法一：通过浏览器创建（推荐）

1. 打开浏览器，访问：**https://github.com/new**

2. 填写仓库信息：
   - **Repository name**: `bond-monitor`
   - **Description**: `新债监控自动化系统`
   - **Public/Private**: 选择 `Private`（私有）或 `Public`（公开）
   - **不要勾选**: "Initialize this repository with a README"
   - **不要勾选**: "Add .gitignore"
   - **不要勾选**: "Choose a license"

3. 点击 **"Create repository"** 按钮

4. 仓库创建成功后，你会看到仓库地址：
   ```
   https://github.com/heluchao/bond-monitor.git
   ```

### 方法二：使用 GitHub CLI（如果已安装）

如果你已安装 `gh` 命令，可以直接运行：

```bash
gh repo create bond-monitor --public --description "新债监控自动化系统" --source=. --remote=origin --push
```

---

## 📤 第二步：推送代码到 GitHub

### 方式一：使用 GitHub Personal Access Token（推荐）

由于 GitHub 已弃用密码认证，你需要使用 Personal Access Token。

#### 1. 生成 Personal Access Token

1. 登录 GitHub
2. 点击右上角头像 → **Settings**
3. 左侧菜单找到 **Developer settings**
4. 点击 **Personal access tokens** → **Tokens (classic)**
5. 点击 **"Generate new token (classic)"**
6. 配置 Token：
   - **Note**: `bond-monitor deployment`
   - **Expiration**: 选择过期时间（建议 30 days 或 No expiration）
   - **Scopes**: 勾选 `repo`（这会包含所有仓库权限）
7. 点击 **"Generate token"**
8. **重要**：立即复制 Token（只显示一次！）

#### 2. 推送代码

在项目根目录执行：

```bash
cd /Users/heluchao/WorkBuddy/Claw/bond-monitor

# 推送代码
git push -u origin main
```

**输入提示：**
- **Username**: `heluchao`
- **Password**: 粘贴你刚刚复制的 **Personal Access Token**（不是你的 GitHub 密码）

### 方式二：使用 SSH 密钥（高级用户）

如果你已配置 SSH 密钥，可以使用 SSH 方式：

```bash
# 修改远程仓库地址为 SSH
git remote set-url origin git@github.com:heluchao/bond-monitor.git

# 推送代码
git push -u origin main
```

### 方式三：使用 GitHub Credential Helper（Mac）

如果你使用 Mac，可以配置 GitHub 凭据助手：

```bash
# 配置凭据助手
git config --global credential.helper osxkeychain

# 推送代码（首次会弹出窗口让你输入）
git push -u origin main
```

---

## ✅ 第三步：验证推送成功

推送成功后，你会看到：

```
Enumerating objects: 15, done.
Counting objects: 100% (15/15), done.
Delta compression using up to 8 threads
Compressing objects: 100% (11/11), done.
Writing objects: 100% (15/15), 8.34 KiB | 1.04 MiB/s, done.
Total 15 (delta 3), reused 0 (delta 0), pack-reused 0
To https://github.com/heluchao/bond-monitor.git
 * [new branch]      main -> main
```

然后访问：**https://github.com/heluchao/bond-monitor**

你应该能看到你的仓库和所有文件。

---

## 🔐 第四步：配置 GitHub Secrets

推送成功后，需要配置企业微信 Webhook URL。

### 配置步骤

1. 打开你的仓库：**https://github.com/heluchao/bond-monitor**

2. 进入 **Settings**

3. 左侧菜单找到 **Secrets and variables** → **Actions**

4. 点击 **"New repository secret"**

5. 添加 Secret：

   | 字段 | 值 |
   |------|-----|
   | **Name** | `WECHAT_WEBHOOK_URL` |
   | **Value** | 你的企业微信机器人 Webhook URL |

   例如：
   ```
   https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxxxx-xxxxx-xxxxx-xxxxx
   ```

6. 点击 **"Add secret"**

### 如何获取企业微信 Webhook URL

1. 创建企业微信群（至少3人）
2. 群聊 → 右上角三个点 → **群机器人** → **添加机器人**
3. 设置机器人名称（如"新债提醒"）
4. 点击 **"添加"**
5. 复制 Webhook URL

---

## 🧪 第五步：测试 GitHub Actions

### 手动触发测试

1. 访问：**https://github.com/heluchao/bond-monitor/actions**

2. 你会看到 **"Daily Bond Query"** workflow

3. 点击 **"Run workflow"**

4. 选择分支（默认 `main`）

5. 点击 **"Run workflow"** 按钮

6. 等待执行完成（约1-2分钟）

7. 查看执行日志：
   - 点击对应的 workflow run
   - 点击 job 展开
   - 查看各个 step 的详细日志

8. 检查企业微信群是否收到消息

---

## 📊 查看项目结构

推送成功后，你的仓库应该包含：

```
bond-monitor/
├── .github/
│   └── workflows/
│       └── daily-query.yml      # GitHub Actions 配置
├── scripts/
│   ├── query_bond.py            # 主查询脚本
│   ├── utils.py                 # 工具函数
│   └── config.py                # 配置文件
├── data/                        # 数据存储（空）
├── logs/                        # 日志目录（空）
├── .env.example                 # 环境变量示例
├── .gitignore                   # Git 忽略文件
├── setup_github.sh              # 自动化设置脚本
├── requirements.txt             # Python 依赖
├── README.md                    # 项目说明
├── DEPLOYMENT_GUIDE.md          # 详细部署指南
├── QUICKSTART.md                # 快速启动指南
├── PROJECT_SUMMARY.md           # 项目总结
└── PUSH_GUIDE.md               # 本文档
```

---

## ⚠️ 常见问题

### Q1: 推送时提示 "Authentication failed"

**原因**：GitHub 已弃用密码认证

**解决方法**：
- 使用 Personal Access Token（推荐）
- 或使用 SSH 密钥
- 或配置 GitHub 凭据助手

### Q2: 推送时提示 "remote repository not found"

**原因**：GitHub 仓库尚未创建

**解决方法**：
1. 先在 GitHub 网站上创建仓库
2. 然后再推送代码

### Q3: 推送时提示 "fatal: remote origin already exists"

**原因**：远程仓库已存在

**解决方法**：
```bash
# 删除现有远程仓库
git remote remove origin

# 重新添加
git remote add origin https://github.com/heluchao/bond-monitor.git

# 推送代码
git push -u origin main
```

### Q4: GitHub Actions 执行失败

**原因**：
- GitHub Secrets 未配置
- Webhook URL 无效
- 脚本错误

**解决方法**：
1. 检查 GitHub Secrets 是否正确添加
2. 查看 Actions 执行日志定位具体错误
3. 测试企业微信 Webhook 是否有效

---

## 🎉 完成检查清单

部署完成后，请确认以下事项：

- [ ] GitHub 仓库已创建
- [ ] 代码已成功推送到 GitHub
- [ ] 可以在浏览器中看到仓库
- [ ] GitHub Secrets 已配置
- [ ] 企业微信 Webhook URL 已添加
- [ ] GitHub Actions 手动测试成功
- [ ] 企业微信群收到测试消息

---

## 📚 相关资源

- [GitHub Personal Access Token 文档](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [企业微信机器人 API](https://developer.work.weixin.qq.com/document/path/91770)
- [项目 README](README.md)
- [详细部署指南](DEPLOYMENT_GUIDE.md)

---

## 🆘 需要帮助？

如果遇到问题：

1. 查看本文档的"常见问题"部分
2. 查看 [详细部署指南](DEPLOYMENT_GUIDE.md)
3. 提交 Issue 到 GitHub 仓库

---

**祝你部署成功！🎉**
