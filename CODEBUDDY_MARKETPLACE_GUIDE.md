# CodeBuddy 插件市场上架指南

## 插件已准备好上架！

您的可转债监控插件已经完成开发和打包，现在可以上架到 CodeBuddy 插件市场。

## 插件信息

**插件名称**：bond-monitor（可转债申购监控）

**插件类型**：Skill（技能包）

**版本**：v1.0.0

**打包文件**：`bond-monitor.zip`

**插件位置**：`~/.codebuddy/skills/bond-monitor/`

## 上架方式

### 方式一：通过 GitHub 提交 Pull Request（推荐）

CodeBuddy 插件市场通常托管在 GitHub 上，可以通过 Pull Request 的方式提交插件。

#### 步骤 1：找到官方插件市场仓库

访问 CodeBuddy 官方 GitHub 组织，找到插件市场仓库：
- 可能的仓库名称：`codebuddy-plugins`, `plugin-marketplace`, `skills`
- 官方组织：`https://github.com/tencent-ai` 或 `https://github.com/codebuddy`

#### 步骤 2：Fork 仓库

1. 访问插件市场仓库
2. 点击右上角 "Fork" 按钮
3. 将仓库 Fork 到你的账号下

#### 步骤 3：添加插件文件

```bash
# 克隆你的 Fork
git clone https://github.com/YOUR_USERNAME/codebuddy-plugins.git
cd codebuddy-plugins

# 创建插件目录
mkdir -p skills/bond-monitor

# 复制插件文件
cp -r ~/.codebuddy/skills/bond-monitor/* skills/bond-monitor/

# 复制打包文件
cp /Users/heluchao/WorkBuddy/Claw/bond-monitor.zip skills/
```

#### 步骤 4：更新插件索引

在仓库根目录找到插件索引文件（通常是 `plugins.json` 或 `skills.json`），添加你的插件信息：

```json
{
  "skills": [
    {
      "name": "bond-monitor",
      "version": "1.0.0",
      "description": "可转债申购监控插件，自动查询今日/明日可申购的新债信息，并通过 Server酱 推送到个人微信",
      "author": "heluchao",
      "github": "https://github.com/HeLuchao/bond-monitor",
      "tags": ["finance", "investment", "bond", "notification"],
      "category": "finance",
      "requirements": ["akshare>=1.10.0", "pandas>=2.0.0", "requests>=2.28.0"],
      "icon": "💰",
      "status": "stable"
    }
  ]
}
```

#### 步骤 5：创建 README 文档

在 `skills/bond-monitor/` 目录下创建详细的 README.md：

```markdown
# 可转债申购监控插件

## 简介

自动查询今日/明日可申购的新债信息，并通过 Server酱 推送到个人微信。

## 功能特性

- ✅ 自动查询可转债申购信息
- ✅ 智能筛选今日/明日新债
- ✅ 微信推送通知
- ✅ 定时自动执行
- ✅ 完整的错误处理

## 安装

\`\`\`bash
# 解压插件
unzip bond-monitor.zip -d ~/.codebuddy/skills/

# 安装依赖
pip install -r ~/.codebuddy/skills/bond-monitor/requirements.txt
\`\`\`

## 使用

\`\`\`bash
python3 ~/.codebuddy/skills/bond-monitor/scripts/query_bond.py \
  --sendkey YOUR_SENDKEY \
  --daily-status
\`\`\`

## 配置

- `serverchan_sendkey`：Server酱 SendKey（必需）
- `send_daily_status`：是否发送每日状态通知（可选）
- `push_time`：推送时间（可选）

## 示例输出

\`\`\`
✅ 今日有1只新债申购

债券名称：AA转债
债券代码：123456
申购日期：2026-03-12
申购代码：073456
发行规模：10亿
转股价：15.20元
信用评级：AA+
\`\`\`

## 作者

- GitHub: [@HeLuchao](https://github.com/HeLuchao)
- 项目: [bond-monitor](https://github.com/HeLuchao/bond-monitor)

## 许可证

MIT License
```

#### 步骤 6：提交 Pull Request

```bash
# 添加文件
git add skills/bond-monitor/
git add skills/bond-monitor.zip
git add skills.json  # 如果有索引文件

# 提交
git commit -m "feat: add bond-monitor skill plugin

Add bond-monitor skill for monitoring convertible bond subscription.

Features:
- Query convertible bond subscription information
- Filter today's/tomorrow's new bonds
- Push notifications via Server酱
- Support scheduled execution
- Complete error handling

Category: Finance
Tags: finance, investment, bond, notification"

# 推送到你的 Fork
git push origin main
```

然后在 GitHub 上创建 Pull Request：

1. 访问你 Fork 的仓库
2. 点击 "New Pull Request"
3. 填写 PR 标题和描述
4. 提交 PR

---

### 方式二：通过官方邮箱提交

如果找不到 GitHub 仓库，可以通过官方邮箱提交：

**收件邮箱**：
- `codebuddy@tencent.com`
- `support@codebuddy.cn`

**邮件主题**：`[插件提交] bond-monitor - 可转债申购监控插件`

**邮件内容**：

```
尊敬的 CodeBuddy 团队：

我开发了一个可转债申购监控插件，希望上架到 CodeBuddy 插件市场。

插件信息：
- 名称：bond-monitor
- 版本：1.0.0
- 类型：Skill（技能包）
- 描述：可转债申购监控插件，自动查询今日/明日可申购的新债信息，并通过 Server酱 推送到个人微信

插件特性：
- 自动查询可转债申购信息
- 智能筛选今日/明日新债
- 微信推送通知
- 定时自动执行
- 完整的错误处理

附件：
1. bond-monitor.zip（插件打包文件）
2. README.md（插件说明文档）
3. screenshots/（截图文件夹）

插件已通过验证和打包，符合 CodeBuddy 插件开发规范。

期待您的回复，谢谢！

作者：HeLuchao
GitHub: https://github.com/HeLuchao
项目地址: https://github.com/HeLuchao/bond-monitor
```

**附件**：
- `bond-monitor.zip`
- `README.md`
- 截图文件（可选）

---

### 方式三：通过官方网站提交

访问 CodeBuddy 官方网站，查找插件提交入口：

**可能的网址**：
- https://www.codebuddy.cn/plugins/submit
- https://www.codebuddy.cn/marketplace/contribute
- https://codebuddy.tencent.com/plugins

按照网站指引填写插件信息并上传文件。

---

## 准备材料

无论使用哪种方式，请准备好以下材料：

### 1. 插件文件

- ✅ `bond-monitor.zip`（已生成）
- ✅ 完整的插件源码
- ✅ README.md 文档
- ✅ requirements.txt

### 2. 插件信息

```yaml
name: bond-monitor
version: 1.0.0
description: 可转债申购监控插件，自动查询今日/明日可申购的新债信息，并通过 Server酱 推送到个人微信
author: HeLuchao
github: https://github.com/HeLuchao/bond-monitor
category: finance
tags: [finance, investment, bond, notification]
license: MIT
```

### 3. 截图（可选但推荐）

准备以下截图：
- 插件使用界面截图
- 推送消息截图
- 配置界面截图

### 4. 演示视频（可选）

录制一个简短的演示视频（1-2分钟）：
- 插件功能介绍
- 使用演示
- 推送效果展示

---

## 审核流程

提交后的审核流程通常包括：

### 1. 初审（1-3个工作日）

- 检查插件完整性
- 验证插件功能
- 检查代码质量

### 2. 测试（3-5个工作日）

- 功能测试
- 性能测试
- 安全测试

### 3. 审核（1-2个工作日）

- 内容审核
- 合规审核

### 4. 发布（1个工作日）

- 上架插件市场
- 更新索引

---

## 审核注意事项

为了提高通过率，请注意：

### 1. 代码质量

- ✅ 代码格式规范
- ✅ 注释清晰完整
- ✅ 错误处理完善
- ✅ 日志输出清晰

### 2. 文档完整性

- ✅ README 详细
- ✅ 使用示例清晰
- ✅ 配置说明完整
- ✅ 常见问题解答

### 3. 安全性

- ✅ 不包含恶意代码
- ✅ 不泄露敏感信息
- ✅ 依赖库安全可靠

### 4. 功能性

- ✅ 功能正常运行
- ✅ 无明显 Bug
- ✅ 性能良好
- ✅ 兼容性好

---

## 发布后维护

插件上架后，需要：

### 1. 及时响应问题

- 关注用户反馈
- 及时修复 Bug
- 回答用户问题

### 2. 持续更新

- 定期更新功能
- 修复安全问题
- 优化用户体验

### 3. 版本管理

- 遵循语义化版本
- 更新 CHANGELOG
- 保持向后兼容

---

## 联系方式

如果在提交过程中遇到问题，可以通过以下方式联系：

### 官方渠道

- **官网**：https://www.codebuddy.cn
- **GitHub**：https://github.com/tencent-ai/codebuddy
- **邮箱**：codebuddy@tencent.com
- **社区**：CodeBuddy 官方社区

### 开发者支持

- **文档**：https://www.codebuddy.cn/docs
- **论坛**：https://discuss.codebuddy.cn
- **Discord**：CodeBuddy 官方 Discord

---

## 推荐方案

**建议使用方式一（GitHub PR）**，原因：

1. ✅ 透明度高，审核过程可追踪
2. ✅ 社区参与，获得更多反馈
3. ✅ 版本控制，便于后续更新
4. ✅ 标准流程，通过率更高

---

## 快速检查清单

提交前请确认：

- [ ] 插件已通过验证和打包
- [ ] README 文档完整
- [ ] 配置说明清晰
- [ ] 使用示例有效
- [ ] 代码无错误
- [ ] 依赖库已列出
- [ ] 许可证已添加
- [ ] 作者信息完整
- [ ] GitHub 地址正确
- [ ] 截图已准备（可选）

---

## 下一步行动

1. **立即行动**：选择提交方式（推荐 GitHub PR）
2. **准备材料**：整理所有必需文件
3. **提交插件**：按照指引完成提交
4. **等待审核**：耐心等待审核结果
5. **响应反馈**：及时处理审核意见

---

**祝您的插件顺利上架！** 🎉
