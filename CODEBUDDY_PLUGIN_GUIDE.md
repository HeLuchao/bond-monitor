# CodeBuddy 插件开发指南 - 新债监控系统

> 将新债监控项目封装成 CodeBuddy 插件并上架插件市场

## 目录

- [插件概述](#插件概述)
- [技术架构](#技术架构)
- [开发步骤](#开发步骤)
- [插件配置](#插件配置)
- [测试部署](#测试部署)
- [上架流程](#上架流程)

---

## 插件概述

### 插件定位

**新债监控插件** 是一个基于 Docker 的自动化工具插件，帮助用户：
- 自动查询可转债申购信息
- 通过微信推送新债提醒
- 支持定时自动执行

### 核心功能

1. **数据查询**：使用 AkShare 查询可转债数据
2. **智能筛选**：筛选今日/明日申购的新债
3. **消息推送**：通过 Server酱推送到个人微信
4. **定时执行**：支持 GitHub Actions 自动化

---

## 技术架构

### 插件类型

根据 CodeBuddy 插件开发文档，本插件采用 **Docker 镜像插件** 方式：

```
插件 = Docker 镜像 + 配置参数
```

### 架构图

```
┌─────────────────────────────────────┐
│      CodeBuddy 插件系统             │
│  (用户配置参数，触发执行)           │
└──────────────┬──────────────────────┘
               │ 环境变量注入
               ↓
┌─────────────────────────────────────┐
│     Docker 容器 (插件主体)          │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  entrypoint.sh (入口脚本)   │  │
│  │  - 接收参数                  │  │
│  │  - 执行查询                  │  │
│  │  - 发送推送                  │  │
│  └──────────────────────────────┘  │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  Python 环境                 │  │
│  │  - akshare                   │  │
│  │  - pandas                    │  │
│  │  - requests                  │  │
│  └──────────────────────────────┘  │
└─────────────────────────────────────┘
```

---

## 开发步骤

### 第一步：设计插件参数

```yaml
# 用户需要配置的参数
settings:
  # 必需参数
  serverchan_sendkey:
    type: string
    description: "Server酱 SendKey（从 https://sct.ftqq.com 获取）"
    required: true
  
  # 可选参数
  send_daily_status:
    type: boolean
    description: "是否发送每日状态通知（即使无新债）"
    default: false
  
  push_time:
    type: string
    description: "推送时间（格式：HH:MM，如 09:00）"
    default: "09:00"
```

### 第二步：创建插件目录结构

```
bond-monitor-plugin/
├── Dockerfile           # Docker 镜像构建文件
├── entrypoint.sh        # 插件入口脚本
├── scripts/
│   ├── query_bond.py    # 主查询脚本
│   └── utils.py         # 工具函数
├── requirements.txt     # Python 依赖
├── plugin.json          # 插件元数据
└── README.md            # 插件说明文档
```

---

## 插件配置

### 1. Dockerfile

```dockerfile
# 使用 Python 3.11 作为基础镜像
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 安装依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制脚本文件
COPY scripts/ ./scripts/

# 复制入口脚本
COPY entrypoint.sh /bin/
RUN chmod +x /bin/entrypoint.sh

# 设置环境变量默认值
ENV SEND_DAILY_STATUS=false
ENV PUSH_TIME="09:00"

# 设置入口点
ENTRYPOINT ["/bin/entrypoint.sh"]
```

---

### 2. entrypoint.sh

```bash
#!/bin/sh

# CodeBuddy 新债监控插件入口脚本
# 参数会以环境变量形式传入，格式：PLUGIN_<参数名大写>

echo "========================================="
echo "  新债监控插件 - CodeBuddy Plugin"
echo "========================================="
echo ""

# 获取参数（CodeBuddy 会自动添加 PLUGIN_ 前缀）
SERVERCHAN_SENDKEY="${PLUGIN_SERVERCHAN_SENDKEY}"
SEND_DAILY_STATUS="${PLUGIN_SEND_DAILY_STATUS:-false}"
PUSH_TIME="${PLUGIN_PUSH_TIME:-09:00}"

# 验证必需参数
if [ -z "$SERVERCHAN_SENDKEY" ]; then
    echo "❌ 错误：缺少必需参数 SERVERCHAN_SENDKEY"
    echo "请在插件配置中提供 Server酱 SendKey"
    exit 1
fi

echo "📋 插件配置："
echo "  - SendKey: ${SERVERCHAN_SENDKEY:0:10}..."
echo "  - 每日通知: $SEND_DAILY_STATUS"
echo "  - 推送时间: $PUSH_TIME"
echo ""

# 执行查询脚本
echo "🔍 开始查询新债信息..."
python scripts/query_bond.py

# 检查执行结果
if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 执行成功！"
    echo "  - 检查你的个人微信是否收到推送消息"
    echo "  - 如果今天有新债申购，会收到详细信息"
else
    echo ""
    echo "❌ 执行失败，请检查日志"
    exit 1
fi
```

---

### 3. plugin.json

```json
{
  "name": "bond-monitor",
  "version": "1.0.0",
  "displayName": "新债监控",
  "description": "自动查询可转债申购信息，通过微信推送新债提醒",
  "author": "HeLuchao",
  "license": "MIT",
  "repository": "https://github.com/HeLuchao/bond-monitor",
  "keywords": [
    "可转债",
    "债券监控",
    "微信推送",
    "Server酱",
    "投资理财"
  ],
  "category": "finance",
  "icon": "icon.png",
  "settings": {
    "serverchan_sendkey": {
      "type": "string",
      "title": "Server酱 SendKey",
      "description": "从 https://sct.ftqq.com 获取",
      "required": true,
      "placeholder": "SCTxxxxxxxxxxxxxxxxxxxxxxxx"
    },
    "send_daily_status": {
      "type": "boolean",
      "title": "每日状态通知",
      "description": "即使无新债也发送每日通知",
      "default": false
    },
    "push_time": {
      "type": "string",
      "title": "推送时间",
      "description": "定时推送时间（格式：HH:MM）",
      "default": "09:00",
      "pattern": "^([01][0-9]|2[0-3]):[0-5][0-9]$"
    }
  },
  "outputs": {
    "bonds_count": {
      "type": "number",
      "description": "查询到的债券数量"
    },
    "new_bonds_count": {
      "type": "number",
      "description": "今日/明日申购的新债数量"
    },
    "push_status": {
      "type": "string",
      "description": "推送状态：success/failed/no_bonds"
    }
  }
}
```

---

### 4. requirements.txt

```
akshare>=1.12.0
pandas>=2.0.0
requests>=2.31.0
```

---

### 5. 使用示例

在 CodeBuddy 中使用插件：

```yaml
# .codebuddy/workflows/daily-bond.yml
name: Daily Bond Query

on:
  schedule:
    - cron: '0 1 * * *'  # 每天 UTC 1:00（北京时间 9:00）
  workflow_dispatch:

jobs:
  query-bonds:
    runs-on: ubuntu-latest
    steps:
      - name: Query new bonds
        uses: heluchao/bond-monitor-plugin@v1.0.0
        with:
          serverchan_sendkey: ${{ secrets.SERVERCHAN_SENDKEY }}
          send_daily_status: true
          push_time: "09:00"
```

---

## 测试部署

### 本地测试

#### 1. 构建镜像

```bash
cd bond-monitor-plugin
docker build -t bond-monitor-plugin:latest .
```

#### 2. 测试运行

```bash
# 基础测试
docker run --rm \
  -e PLUGIN_SERVERCHAN_SENDKEY="SCTxxxxxxxxxxxxxxxxxxxxxxxx" \
  bond-monitor-plugin:latest

# 完整参数测试
docker run --rm \
  -e PLUGIN_SERVERCHAN_SENDKEY="SCTxxxxxxxxxxxxxxxxxxxxxxxx" \
  -e PLUGIN_SEND_DAILY_STATUS="true" \
  -e PLUGIN_PUSH_TIME="09:00" \
  bond-monitor-plugin:latest
```

#### 3. 验证结果

检查输出日志，确认：
- ✅ 查询成功
- ✅ 推送成功
- ✅ 个人微信收到消息

---

### 发布镜像

#### 1. 登录 Docker Hub

```bash
docker login
```

#### 2. 标记镜像

```bash
docker tag bond-monitor-plugin:latest heluchao/bond-monitor-plugin:1.0.0
docker tag bond-monitor-plugin:latest heluchao/bond-monitor-plugin:latest
```

#### 3. 推送镜像

```bash
docker push heluchao/bond-monitor-plugin:1.0.0
docker push heluchao/bond-monitor-plugin:latest
```

---

## 上架流程

### 1. 准备插件仓库

创建 GitHub 仓库，包含以下文件：

```
bond-monitor-plugin/
├── Dockerfile
├── entrypoint.sh
├── scripts/
│   ├── query_bond.py
│   └── utils.py
├── requirements.txt
├── plugin.json          # 插件元数据
├── README.md            # 插件文档
├── CHANGELOG.md         # 更新日志
├── LICENSE              # 开源协议
└── icon.png             # 插件图标（可选）
```

---

### 2. 提交到插件市场

#### 方式一：官方插件市场

1. Fork CodeBuddy 官方插件市场仓库
2. 在 `plugins/` 目录下创建插件目录
3. 添加插件配置文件
4. 提交 Pull Request
5. 等待审核通过

#### 方式二：自建插件市场

创建插件市场配置文件：

```json
{
  "name": "Bond Monitor Plugin Market",
  "plugins": [
    {
      "id": "bond-monitor",
      "name": "新债监控",
      "version": "1.0.0",
      "image": "heluchao/bond-monitor-plugin:1.0.0",
      "description": "自动查询可转债申购信息，通过微信推送新债提醒",
      "author": "HeLuchao",
      "repository": "https://github.com/HeLuchao/bond-monitor-plugin",
      "documentation": "https://github.com/HeLuchao/bond-monitor-plugin/blob/main/README.md"
    }
  ]
}
```

---

### 3. 用户安装使用

用户在 CodeBuddy 中添加插件市场：

```json
// .codebuddy/marketplaces.json
{
  "marketplaces": [
    {
      "name": "Bond Monitor Plugins",
      "url": "https://raw.githubusercontent.com/HeLuchao/bond-monitor-plugin/main/marketplace.json"
    }
  ]
}
```

然后搜索并安装插件。

---

## 完整示例项目

我已经在当前项目中创建了完整的插件开发示例：

### 文件清单

- `plugin/` - 插件开发目录
  - `Dockerfile` - Docker 镜像构建文件
  - `entrypoint.sh` - 插件入口脚本
  - `plugin.json` - 插件元数据
  - `README.md` - 插件说明文档
  - `scripts/` - Python 脚本（复用现有代码）

---

## 优势分析

### 为什么封装成插件？

1. **开箱即用**
   - 用户无需编写代码
   - 只需配置参数即可使用
   - 降低使用门槛

2. **易于分享**
   - 发布到插件市场
   - 其他用户可以直接安装
   - 扩大项目影响力

3. **版本管理**
   - 插件版本化管理
   - 用户可以选择使用特定版本
   - 便于维护和更新

4. **集成便利**
   - 与 CodeBuddy 深度集成
   - 支持 CI/CD 流程
   - 自动化执行更简单

---

## 下一步计划

### 功能增强

1. **多推送渠道**
   - 支持企业微信
   - 支持 WxPusher
   - 支持钉钉、飞书

2. **高级筛选**
   - 按信用评级筛选
   - 按发行规模筛选
   - 自定义筛选条件

3. **数据分析**
   - 历史数据统计
   - 新债收益分析
   - 投资建议

---

## 参考资源

- [CodeBuddy 插件开发文档](https://docs.cnb.cool/zh/bash-plugins.html)
- [Docker 官方文档](https://docs.docker.com/)
- [Server酱文档](https://sct.ftqq.com/)
- [AkShare 文档](https://akshare.akfamily.xyz/)

---

## 总结

通过封装成 CodeBuddy 插件，新债监控系统变得：

- ✅ **更易用**：配置参数即可使用
- ✅ **更专业**：标准化插件架构
- ✅ **更易分享**：发布到插件市场
- ✅ **更易维护**：版本化管理

这不仅能帮助更多用户，还能提升项目的影响力和专业度！
