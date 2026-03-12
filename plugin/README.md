# 新债监控 - CodeBuddy 插件

[![GitHub Stars](https://img.shields.io/github/stars/HeLuchao/bond-monitor?style=social)](https://github.com/HeLuchao/bond-monitor)
[![License](https://img.shields.io/github/license/HeLuchao/bond-monitor)](https://github.com/HeLuchao/bond-monitor/blob/main/LICENSE)
[![Docker](https://img.shields.io/docker/v/heluchao/bond-monitor-plugin?label=Docker)](https://hub.docker.com/r/heluchao/bond-monitor-plugin)

> 自动查询可转债申购信息，通过微信推送新债提醒

## 功能特点

✅ **自动查询** - 使用 AkShare 实时查询可转债数据  
✅ **智能筛选** - 筛选今日/明日申购的新债  
✅ **微信推送** - 通过 Server酱推送到个人微信  
✅ **定时执行** - 支持 CodeBuddy 自动化任务  
✅ **完全免费** - 无需付费，开箱即用  

---

## 快速开始

### 1. 获取 SendKey

访问 [Server酱官网](https://sct.ftqq.com/)，使用微信扫码登录，获取 SendKey。

### 2. 安装插件

在 CodeBuddy 中搜索 "新债监控" 并安装，或使用以下配置：

```yaml
# .codebuddy/config.yml
plugins:
  - name: bond-monitor
    version: 1.0.0
```

### 3. 配置参数

```yaml
# .codebuddy/workflows/daily-bond.yml
name: Daily Bond Query

on:
  schedule:
    - cron: '0 1 * * *'  # 每天 UTC 1:00（北京时间 9:00）

jobs:
  query-bonds:
    runs-on: ubuntu-latest
    steps:
      - name: Query new bonds
        uses: heluchao/bond-monitor-plugin@v1.0.0
        with:
          serverchan_sendkey: ${{ secrets.SERVERCHAN_SENDKEY }}
          send_daily_status: true
```

### 4. 运行测试

手动触发工作流，检查个人微信是否收到推送消息。

---

## 配置参数

| 参数 | 类型 | 必需 | 默认值 | 说明 |
|------|------|------|--------|------|
| `serverchan_sendkey` | string | ✅ 是 | - | Server酱 SendKey |
| `send_daily_status` | boolean | 否 | false | 是否发送每日状态通知 |
| `push_time` | string | 否 | 09:00 | 推送时间（格式：HH:MM） |

---

## 使用示例

### 示例 1：基础使用

最简单的配置方式：

```yaml
steps:
  - name: Query new bonds
    uses: heluchao/bond-monitor-plugin@v1.0.0
    with:
      serverchan_sendkey: ${{ secrets.SERVERCHAN_SENDKEY }}
```

### 示例 2：每日通知

启用每日状态通知，即使无新债也会推送：

```yaml
steps:
  - name: Query new bonds
    uses: heluchao/bond-monitor-plugin@v1.0.0
    with:
      serverchan_sendkey: ${{ secrets.SERVERCHAN_SENDKEY }}
      send_daily_status: true
```

### 示例 3：自定义时间

设置每天早上 8:30 推送：

```yaml
steps:
  - name: Query new bonds
    uses: heluchao/bond-monitor-plugin@v1.0.0
    with:
      serverchan_sendkey: ${{ secrets.SERVERCHAN_SENDKEY }}
      send_daily_status: true
      push_time: "08:30"
```

---

## 推送效果

### 有新债申购

```
标题：✅ 今日有1只新债申购

内容：
债券名称：XXX转债
债券代码：123456
申购日期：2026-03-12
申购代码：072452
发行规模：10.00亿
转股价：15.50
信用评级：AA-
---
```

### 无新债申购（启用每日通知）

```
标题：❌ 今日无新债申购

内容：
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

## 本地测试

### 使用 Docker 测试

```bash
# 构建镜像
docker build -t bond-monitor-plugin .

# 运行测试
docker run --rm \
  -e PLUGIN_SERVERCHAN_SENDKEY="SCTxxxxxxxxxxxxxxxxxxxxxxxx" \
  -e PLUGIN_SEND_DAILY_STATUS="true" \
  bond-monitor-plugin
```

### 使用 Docker Compose

```yaml
# docker-compose.yml
version: '3.8'

services:
  bond-monitor:
    build: .
    environment:
      - PLUGIN_SERVERCHAN_SENDKEY=SCTxxxxxxxxxxxxxxxxxxxxxxxx
      - PLUGIN_SEND_DAILY_STATUS=true
      - PLUGIN_PUSH_TIME=09:00
```

```bash
docker-compose up
```

---

## 输出变量

插件执行后可输出以下变量：

| 变量名 | 类型 | 说明 |
|--------|------|------|
| `bonds_count` | number | 查询到的债券总数 |
| `new_bonds_count` | number | 今日/明日申购的新债数量 |
| `push_status` | string | 推送状态：success/failed/no_bonds |
| `push_message` | string | 推送的消息内容摘要 |

---

## 常见问题

### 1. 没有收到推送消息？

**可能原因**：
- SendKey 配置错误
- 今天没有新债申购
- 未启用每日状态通知

**解决方法**：
1. 检查 SendKey 是否正确
2. 启用 `send_daily_status: true`
3. 查看执行日志

### 2. 如何查看历史推送记录？

访问 [Server酱控制台](https://sct.ftqq.com/sendlog) 查看推送历史。

### 3. 推送频率限制？

Server酱免费版每天最多 5 条消息，本插件每天最多发送 1 条，完全够用。

### 4. 支持其他推送方式吗？

当前版本仅支持 Server酱，后续版本将支持：
- 企业微信
- WxPusher
- 钉钉
- 飞书

---

## 更新日志

### v1.0.0 (2026-03-12)

- ✨ 首次发布
- ✅ 支持可转债数据查询
- ✅ 支持微信推送
- ✅ 支持定时执行
- ✅ 支持每日状态通知

---

## 贡献指南

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 提交 Pull Request

---

## 技术支持

- **文档**：[GitHub Wiki](https://github.com/HeLuchao/bond-monitor/wiki)
- **问题反馈**：[GitHub Issues](https://github.com/HeLuchao/bond-monitor/issues)
- **讨论交流**：[GitHub Discussions](https://github.com/HeLuchao/bond-monitor/discussions)

---

## 相关资源

- [AkShare 文档](https://akshare.akfamily.xyz/)
- [Server酱文档](https://sct.ftqq.com/)
- [CodeBuddy 文档](https://docs.cnb.cool/)

---

## 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件

---

## 致谢

感谢以下开源项目：
- [AkShare](https://github.com/akfamily/akshare) - 金融数据接口
- [Server酱](https://sct.ftqq.com/) - 微信推送服务
- [CodeBuddy](https://www.codebuddy.cn/) - 插件平台

---

**⭐ 如果这个插件对你有帮助，请给一个 Star！**
