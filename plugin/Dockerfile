# CodeBuddy 新债监控插件 - Docker 镜像
# 基于 Python 3.11 构建

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

# 设置时区为中国标准时间
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 设置入口点
ENTRYPOINT ["/bin/entrypoint.sh"]

# 元数据标签
LABEL maintainer="HeLuchao"
LABEL version="1.0.0"
LABEL description="CodeBuddy 新债监控插件 - 自动查询可转债申购信息并推送微信提醒"
LABEL repository="https://github.com/HeLuchao/bond-monitor"
