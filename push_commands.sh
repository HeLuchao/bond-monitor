#!/bin/bash

# 新债监控自动化系统 - 代码推送脚本

echo "=========================================="
echo "  新债监控自动化系统 - 代码推送"
echo "=========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 检查当前目录
if [ ! -d ".git" ]; then
    echo -e "${RED}错误：当前目录不是一个 Git 仓库${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Git 仓库检查通过${NC}"
echo ""

echo -e "${GREEN}当前 Git 配置：${NC}"
echo "用户名: $(git config user.name)"
echo "邮箱: $(git config user.email)"
echo ""

echo -e "${GREEN}远程仓库配置：${NC}"
git remote -v
echo ""

echo -e "${YELLOW}=========================================="
echo "  📋 准备推送代码到 GitHub"
echo "==========================================${NC}"
echo ""
echo "推送目标: https://github.com/heluchao/bond-monitor.git"
echo ""

read -p "确认推送？(y/n): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "已取消推送"
    exit 0
fi

echo ""
echo -e "${GREEN}=========================================="
echo "  🚀 开始推送代码"
echo "==========================================${NC}"
echo ""

echo -e "${YELLOW}提示：${NC}"
echo "1. GitHub 已弃用密码认证"
echo "2. 你需要使用 Personal Access Token（推荐）"
echo "3. 访问：https://github.com/settings/tokens"
echo "4. 生成新 Token，勾选 'repo' 权限"
echo ""

read -p "是否已准备好 Personal Access Token？(y/n): " token_ready

if [ "$token_ready" != "y" ] && [ "$token_ready" != "Y" ]; then
    echo ""
    echo -e "${YELLOW}请先获取 Personal Access Token，然后重新运行此脚本${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}正在推送代码...${NC}"
echo ""
echo -e "${YELLOW}推送时需要输入：${NC}"
echo "  Username: heluchao"
echo "  Password: <粘贴你的 Personal Access Token>"
echo ""
echo -e "${YELLOW}注意：${NC}密码输入时不会显示任何字符，这是正常的"
echo ""

# 执行推送
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}=========================================="
    echo "  🎉 代码推送成功！"
    echo "=========================================="
    echo ""
    echo "你的仓库地址：https://github.com/heluchao/bond-monitor"
    echo ""
    echo -e "${YELLOW}下一步：${NC}"
    echo "1. 配置 GitHub Secrets（查看 PUSH_GUIDE.md）"
    echo "2. 测试 GitHub Actions 工作流"
    echo "3. 配置企业微信机器人"
    echo ""
else
    echo ""
    echo -e "${RED}=========================================="
    echo "  ❌ 代码推送失败"
    echo "=========================================="
    echo ""
    echo "可能的原因："
    echo "1. GitHub 仓库尚未创建"
    echo "2. Personal Access Token 无效或过期"
    echo "3. 网络问题"
    echo ""
    echo -e "${YELLOW}解决方法：${NC}"
    echo "1. 确保已在 GitHub 网站上创建了仓库"
    echo "2. 重新生成 Personal Access Token"
    echo "3. 检查网络连接"
    echo ""
    echo -e "${YELLOW}手动推送命令：${NC}"
    echo "  git push -u origin main"
    echo ""
    exit 1
fi
