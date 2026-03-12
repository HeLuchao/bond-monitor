# CodeBuddy 插件开发完整指南

## 插件概述

本文档详细记录了如何将可转债监控项目封装为符合 CodeBuddy 规范的插件。

## 插件信息

**插件名称**：bond-monitor（可转债申购监控）

**插件类型**：Skill（技能包）

**插件版本**：v1.0.0

**插件位置**：`~/.codebuddy/skills/bond-monitor/`

## 插件结构

```
bond-monitor/
├── SKILL.md                    # 插件主文档（必需）
├── requirements.txt            # Python 依赖
├── scripts/                    # 可执行脚本
│   └── query_bond.py          # 主查询脚本
├── references/                 # 参考文档
│   ├── api.md                 # AkShare API 指南
│   └── serverchan.md          # Server酱配置教程
└── assets/                     # 资源文件（可选）
```

## 插件文件说明

### 1. SKILL.md（核心文件）

**作用**：插件的入口文档，定义插件的名称、描述和使用方法。

**结构**：
```markdown
---
name: bond-monitor
description: 插件描述
---

# 插件标题

## 概述
## 何时使用
## 核心功能
## 使用方法
## 配置参数
...
```

**关键点**：
- YAML frontmatter 必须包含 `name` 和 `description`
- description 决定了插件何时被触发
- 使用命令式/不定式语言（非第二人称）

### 2. scripts/（脚本目录）

**作用**：存放可执行脚本，提供确定性可靠的功能。

**本插件脚本**：
- `query_bond.py`：主查询脚本
  - 参数解析
  - 数据查询
  - 消息推送
  - 错误处理

**最佳实践**：
- 脚本应该独立可执行
- 提供清晰的命令行参数
- 包含详细的帮助信息
- 处理所有可能的错误

### 3. references/（参考文档）

**作用**：存放详细的参考文档，按需加载到上下文。

**本插件文档**：
- `api.md`：AkShare API 使用指南
  - 接口说明
  - 数据字段
  - 使用示例
  - 错误处理

- `serverchan.md`：Server酱配置教程
  - 注册流程
  - 发送消息
  - 配置方法
  - 常见问题

**设计原则**：
- 详细的参考信息放在 references
- 核心流程放在 SKILL.md
- 避免重复信息

### 4. requirements.txt

**作用**：定义 Python 依赖。

**内容**：
```
akshare>=1.10.0
pandas>=2.0.0
requests>=2.28.0
```

## 插件开发流程

### Step 1：理解使用场景

**用户需求**：
- 查询可转债申购信息
- 自动推送到微信
- 定时执行

**触发场景**：
- "今天有什么新债申购"
- "查询可转债"
- "债券申购提醒"

### Step 2：规划插件内容

**可复用资源**：
1. **scripts/query_bond.py**
   - 避免重复编写查询代码
   - 提供确定性可靠的功能

2. **references/api.md**
   - AkShare API 文档
   - 按需加载，节省上下文

3. **references/serverchan.md**
   - Server酱配置教程
   - 用户常见问题解答

### Step 3：初始化插件目录

```bash
# 创建目录结构
mkdir -p ~/.codebuddy/skills/bond-monitor/{scripts,references,assets}
```

### Step 4：编写插件内容

#### 4.1 编写 SKILL.md

**关键部分**：

1. **YAML frontmatter**：
   ```yaml
   ---
   name: bond-monitor
   description: 清晰描述插件功能和使用场景
   ---
   ```

2. **核心内容**：
   - 概述：插件是什么
   - 何时使用：触发条件
   - 核心功能：主要能力
   - 使用方法：如何调用
   - 配置参数：必需和可选参数
   - 工作流程：执行步骤

3. **写作风格**：
   - 使用命令式/不定式
   - 客观、教学性的语言
   - 避免第二人称

#### 4.2 编写脚本

**脚本模板**：

```python
#!/usr/bin/env python3
"""
脚本描述

功能：
1. 功能1
2. 功能2

使用方法：
    python script.py --param value
"""

import argparse

def main():
    """主函数"""
    parser = argparse.ArgumentParser()
    parser.add_argument('--param', required=True)
    
    args = parser.parse_args()
    
    # 执行逻辑
    pass

if __name__ == '__main__':
    main()
```

#### 4.3 编写参考文档

**文档结构**：

```markdown
# 标题

## 简介
## 安装/配置
## 使用方法
## 常见问题
## 最佳实践
```

### Step 5：验证和打包

```bash
# 查找打包脚本
PACKAGER=$(find /Applications/WorkBuddy.app -name "package_skill.py" | head -1)

# 验证并打包
python3 "$PACKAGER" ~/.codebuddy/skills/bond-monitor
```

**输出示例**：
```
📦 Packaging skill: /Users/heluchao/.codebuddy/skills/bond-monitor

🔍 Validating skill...
✅ Skill is valid!

  Added: bond-monitor/SKILL.md
  Added: bond-monitor/scripts/query_bond.py
  ...

✅ Successfully packaged skill to: ./bond-monitor.zip
```

### Step 6：分发插件

**打包文件**：`bond-monitor.zip`

**分发方式**：
1. 直接分享给其他用户
2. 上传到插件市场
3. 包含在项目中

## 使用插件

### 方式 1：命令行调用

```bash
# 解压插件到用户技能目录
unzip bond-monitor.zip -d ~/.codebuddy/skills/

# 运行脚本
python3 ~/.codebuddy/skills/bond-monitor/scripts/query_bond.py \
  --sendkey SCT321629TV9CvNbMDefg \
  --daily-status
```

### 方式 2：在对话中使用

```
用户：今天有什么新债申购吗？
CodeBuddy：让我为你查询今日的可转债申购信息...
[调用 bond-monitor 插件]
```

### 方式 3：在 workflow 中使用

```yaml
name: Daily Bond Monitor

on:
  schedule:
    - cron: '0 1 * * *'  # UTC 1:00 = 北京时间 9:00

jobs:
  monitor:
    runs-on: ubuntu-latest
    steps:
      - name: Query bonds
        run: |
          python3 scripts/query_bond.py \
            --sendkey ${{ secrets.SERVERCHAN_SENDKEY }} \
            --daily-status
```

## 插件特性

### 1. 渐进式加载

插件使用三级加载系统：

1. **元数据**（始终加载）
   - name: bond-monitor
   - description: ~100 词

2. **SKILL.md 主体**（触发时加载）
   - 核心流程和说明
   - < 5000 词

3. **参考文档**（按需加载）
   - API 文档
   - 配置教程
   - 无限制

### 2. 参数化执行

**必需参数**：
- `serverchan_sendkey`：Server酱 SendKey

**可选参数**：
- `send_daily_status`：是否发送每日状态（默认 false）
- `push_time`：推送时间（默认 09:00）

### 3. 错误处理

脚本包含完整的错误处理：

```python
try:
    df = ak.bond_zh_cov()
except Exception as e:
    print(f"❌ 获取数据失败: {str(e)}")
    return None
```

### 4. 日志输出

清晰的执行日志：

```
============================================================
[2026-03-12 09:00:00] 🔔 可转债申购监控启动
============================================================

[2026-03-12 09:00:01] 🔄 正在获取可转债数据...
[2026-03-12 09:00:05] ✅ 成功获取 450 条债券数据
[2026-03-12 09:00:05] 📊 筛选出 2 条新债
[2026-03-12 09:00:06] 📤 正在推送消息到微信...
[2026-03-12 09:00:07] ✅ 推送成功: 今日有2只新债申购

============================================================
[2026-03-12 09:00:07] ✅ 任务执行完成
============================================================
```

## 验证检查项

插件打包时会自动验证：

✅ **YAML frontmatter**
- 必须包含 name 和 description
- 格式正确

✅ **文件组织**
- SKILL.md 存在
- 目录结构正确

✅ **描述质量**
- description 清晰完整
- 说明触发场景

✅ **命名规范**
- 使用小写字母
- 使用连字符分隔

## 最佳实践

### 1. 保持 SKILL.md 精简

- 核心流程和触发条件
- < 5000 词
- 详细信息放 references

### 2. 脚本独立可执行

- 包含参数解析
- 包含错误处理
- 包含帮助信息

### 3. 文档分离

- SKILL.md：核心流程
- references/：详细文档
- 避免重复

### 4. 使用命令式语言

```
❌ 你应该使用这个插件来...
✅ 使用此插件查询可转债信息...
```

### 5. 提供清晰示例

```markdown
## 使用方法

快速查询：
```
查询今天有什么新债申购
```
```

## 常见问题

### Q1: 插件没有被触发？

检查：
- description 是否清晰描述了触发场景
- 用户的问题是否匹配触发条件

### Q2: 脚本执行失败？

检查：
- 依赖是否安装（requirements.txt）
- 参数是否正确
- 环境变量是否设置

### Q3: 如何更新插件？

1. 修改插件文件
2. 重新打包
3. 分享新版本

### Q4: 如何调试插件？

1. 直接运行脚本测试
2. 检查日志输出
3. 使用 print 调试

## 参考资源

- [Skill Creator 技能文档](~/.codebuddy/skills/skill-creator/SKILL.md)
- [CodeBuddy 官方文档](https://www.codebuddy.cn/docs)
- [AkShare 文档](https://akshare.akfamily.xyz/)
- [Server酱 文档](https://sct.ftqq.com/)

## 更新日志

### v1.0.0 (2026-03-12)

**首次发布**：

- ✅ 完整的插件结构
- ✅ SKILL.md 核心文档
- ✅ 可执行查询脚本
- ✅ AkShare API 参考
- ✅ Server酱 配置教程
- ✅ 通过验证和打包

**核心功能**：

- 查询可转债申购信息
- 智能筛选今日/明日新债
- 微信推送通知
- 定时自动执行

**技术特点**：

- 符合 CodeBuddy 插件规范
- 渐进式文档加载
- 参数化配置
- 完整的错误处理

## 总结

本插件严格遵循 CodeBuddy 插件开发规范：

1. ✅ **标准结构**：SKILL.md + scripts + references
2. ✅ **清晰描述**：明确定义触发场景
3. ✅ **可复用资源**：脚本、文档、配置
4. ✅ **渐进式加载**：三级加载系统
5. ✅ **独立可执行**：脚本包含完整功能
6. ✅ **通过验证**：自动验证和打包

插件已准备就绪，可以立即使用！
