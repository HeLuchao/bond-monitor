#!/bin/bash

# 新债监控自动化系统 - GitHub 仓库创建和推送脚本

echo "=========================================="
echo "  新债监控自动化系统 - GitHub 仓库设置"
echo "=========================================="
echo ""

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查当前目录
if [ ! -d ".git" ]; then
    echo -e "${RED}错误：当前目录不是一个 Git 仓库${NC}"
    echo "请在 bond-monitor 项目根目录下运行此脚本"
    exit 1
fi

echo -e "${GREEN}步骤 1：创建 GitHub 仓库${NC}"
echo "----------------------------------------"
echo "请按以下步骤创建 GitHub 仓库："
echo ""
echo "1. 打开浏览器，访问：https://github.com/new"
echo "2. 仓库名称输入：bond-monitor"
echo "3. 描述输入：新债监控自动化系统"
echo "4. 选择：Private（私有仓库）或 Public（公开仓库）"
echo "5. 不要勾选 'Initialize this repository with a README'"
echo "6. 点击 'Create repository'"
echo ""
read -p "仓库创建完成后，按回车键继续..."
echo ""

echo -e "${GREEN}步骤 2：配置 Git 远程仓库${NC}"
echo "----------------------------------------"
echo "请输入你的 GitHub 用户名："
read github_username

if [ -z "$github_username" ]; then
    echo -e "${RED}错误：用户名不能为空${NC}"
    exit 1
fi

echo ""
echo "正在添加远程仓库..."
git remote add origin "https://github.com/${github_username}/bond-monitor.git"

if [ $? -ne 0 ]; then
    echo -e "${RED}错误：添加远程仓库失败${NC}"
    echo "如果远程仓库已存在，请先删除：git remote remove origin"
    exit 1
fi

echo -e "${GREEN}远程仓库添加成功：https://github.com/${github_username}/bond-monitor.git${NC}"
echo ""

echo -e "${GREEN}步骤 3：推送代码到 GitHub${NC}"
echo "----------------------------------------"
echo "正在推送代码..."

git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}=========================================="
    echo "  🎉 代码推送成功！"
    echo "=========================================="
    echo ""
    echo "你的仓库地址：https://github.com/${github_username}/bond-monitor"
    echo ""
    echo -e "${YELLOW}下一步：配置 GitHub Secrets${NC}"
    echo "----------------------------------------"
    echo "1. 打开你的仓库：https://github.com/${github_username}/bond-monitor"
    echo "2. 进入 Settings → Secrets and variables → Actions"
    echo "3. 点击 'New repository secret'"
    echo "4. 添加以下 Secret："
    echo "   - Name: WECHAT_WEBHOOK_URL"
    echo "   - Value: 你的企业微信机器人 Webhook URL"
    echo ""
    echo -e "${YELLOW}如何获取企业微信 Webhook URL：${NC}"
    echo "1. 创建企业微信群（至少3人）"
    echo "2. 群聊 → 右上角三个点 → 群机器人 → 添加机器人"
    echo "3. 复制 Webhook URL"
    echo ""
    echo -e "${GREEN}配置完成后，你可以手动测试工作流：${NC}"
    echo "https://github.com/${github_username}/bond-monitor/actions"
    echo ""
else
    echo ""
    echo -e "${RED}=========================================="
    echo "  ❌ 代码推送失败"
    echo "=========================================="
    echo ""
    echo "可能的原因："
    echo "1. GitHub 仓库尚未创建"
    echo "2. 仓库名称不正确"
    echo "3. 需要进行身份验证"
    echo ""
    echo "请检查后重试，或手动执行："
    echo "git push -u origin main"
    echo ""
    exit 1
fi
