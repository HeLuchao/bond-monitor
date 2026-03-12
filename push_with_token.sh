#!/bin/bash

# 一次性推送命令 - 使用 HTTPS + Token

echo "======================================"
echo "  一键推送代码到 GitHub"
echo "======================================"
echo ""

cd "$(dirname "$0")"

echo "请输入你的 GitHub Personal Access Token:"
echo ""
echo "获取 Token 步骤:"
echo "1. 访问: https://github.com/settings/tokens"
echo "2. 点击 'Generate new token (classic)'"
echo "3. 勾选 'repo' 权限"
echo "4. 点击 'Generate token'"
echo "5. 复制生成的 Token"
echo ""

read -sp "Token: " token
echo ""

if [ -z "$token" ]; then
    echo "❌ Token 不能为空"
    exit 1
fi

echo ""
echo "🚀 正在推送代码..."
echo ""

# 使用 Token 推送
git push https://heluchao:${token}@github.com/heluchao/bond-monitor.git main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 代码推送成功！"
    echo ""
    echo "📦 仓库地址: https://github.com/heluchao/bond-monitor"
    echo ""
    echo "📝 下一步:"
    echo "1. 配置 GitHub Secrets (WECHAT_WEBHOOK_URL)"
    echo "2. 测试 Actions 工作流"
    echo ""
else
    echo ""
    echo "❌ 推送失败，请检查 Token 是否正确"
    echo ""
fi
