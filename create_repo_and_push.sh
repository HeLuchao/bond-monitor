#!/bin/bash

# 新债监控自动化系统 - 创建仓库和推送代码

echo "=========================================="
echo "  新债监控自动化系统 - 部署助手"
echo "=========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}步骤 1：创建 GitHub 仓库${NC}"
echo "----------------------------------------"
echo ""
echo "请在浏览器中打开以下链接创建仓库："
echo ""
echo -e "${GREEN}https://github.com/new${NC}"
echo ""
echo "仓库信息："
echo "  - 仓库名称: bond-monitor"
echo "  - 描述: 新债监控自动化系统"
echo "  - 可见性: Private（私有）或 Public（公开）"
echo "  - 重要: 不要勾选 'Initialize this repository with a README'"
echo ""
read -p "仓库创建完成后，按回车键继续..."
echo ""

echo -e "${BLUE}步骤 2：推送代码到 GitHub${NC}"
echo "----------------------------------------"
echo ""

# 检查当前目录
if [ ! -d ".git" ]; then
    echo -e "${RED}错误：当前目录不是一个 Git 仓库${NC}"
    exit 1
fi

# 检查远程仓库配置
if ! git remote get-url origin &>/dev/null; then
    echo "未配置远程仓库，正在配置..."
    git remote add origin git@github.com:heluchao/bond-monitor.git
fi

echo -e "远程仓库: ${GREEN}git@github.com:heluchao/bond-monitor.git${NC}"
echo ""
echo "正在推送代码..."
echo ""

# 推送代码
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}=========================================="
    echo "  🎉 代码推送成功！"
    echo "=========================================="
    echo ""
    echo "你的仓库地址："
    echo -e "${GREEN}https://github.com/heluchao/bond-monitor${NC}"
    echo ""
    echo -e "${YELLOW}下一步：${NC}"
    echo "1. 配置 GitHub Secrets"
    echo "   - 访问: https://github.com/heluchao/bond-monitor/settings/secrets/actions"
    echo "   - 添加 Secret: WECHAT_WEBHOOK_URL"
    echo "   - 值: 你的企业微信机器人 Webhook URL"
    echo ""
    echo "2. 测试 GitHub Actions"
    echo "   - 访问: https://github.com/heluchao/bond-monitor/actions"
    echo "   - 点击 'Run workflow' 手动触发测试"
    echo ""
else
    echo ""
    echo -e "${RED}=========================================="
    echo "  ❌ 推送失败"
    echo "=========================================="
    echo ""
    echo "可能的原因："
    echo "1. GitHub 仓库尚未创建"
    echo "2. SSH 密钥未添加到 GitHub 账号"
    echo "3. 仓库名称不正确"
    echo ""
    echo -e "${YELLOW}解决方法：${NC}"
    echo "1. 确保已在 GitHub 网站上创建了仓库"
    echo "2. 添加 SSH 公钥到 GitHub:"
    echo "   - 复制公钥: cat ~/.ssh/id_rsa.pub"
    echo "   - 添加到: https://github.com/settings/keys"
    echo ""
    exit 1
fi
