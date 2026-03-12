#!/bin/bash

# 新债监控项目 - 交互式推送脚本
# 这个脚本会引导你完成 GitHub 认证和代码推送

set -e

echo "======================================"
echo "  新债监控项目 - GitHub 推送工具"
echo "======================================"
echo ""

# 检查仓库状态
echo "📂 检查仓库状态..."
cd "$(dirname "$0")"
git status --short

echo ""
echo "📋 当前分支:"
git branch --show-current

echo ""
echo "📊 提交历史（最近 5 条）:"
git log --oneline -5

echo ""
echo "======================================"
echo "  选择推送方式"
echo "======================================"
echo ""
echo "1. 使用 Personal Access Token (推荐)"
echo "2. 使用 SSH 密钥"
echo "3. 使用 GitHub CLI (需要安装)"
echo ""
read -p "请选择 (1-3): " choice

case $choice in
    1)
        echo ""
        echo "📝 使用 Personal Access Token 推送"
        echo ""
        echo "请按照以下步骤操作:"
        echo ""
        echo "1. 访问: https://github.com/settings/tokens"
        echo "2. 点击 'Generate new token (classic)'"
        echo "3. 勾选 'repo' 权限"
        echo "4. 点击 'Generate token'"
        echo "5. 复制生成的 Token"
        echo ""
        read -p "按回车键继续，然后粘贴 Token..." dummy
        
        echo ""
        read -sp "请输入你的 GitHub Personal Access Token: " token
        echo ""
        
        # 使用 Token 推送
        echo ""
        echo "🚀 正在推送代码..."
        echo ""
        git remote set-url origin https://heluchao:${token}@github.com/heluchao/bond-monitor.git
        git push -u origin main
        
        # 恢复原始 URL（不包含 Token）
        git remote set-url origin https://github.com/heluchao/bond-monitor.git
        
        echo ""
        echo "✅ 代码推送成功！"
        ;;
    
    2)
        echo ""
        echo "🔑 使用 SSH 密钥推送"
        echo ""
        echo "检查 SSH 密钥..."
        if [ -f ~/.ssh/id_rsa.pub ]; then
            echo "✅ 找到 SSH 公钥"
            echo ""
            echo "请按照以下步骤操作:"
            echo ""
            echo "1. 复制你的 SSH 公钥:"
            echo "   cat ~/.ssh/id_rsa.pub | pbcopy"
            echo ""
            echo "2. 访问: https://github.com/settings/keys"
            echo "3. 点击 'New SSH key'"
            echo "4. 粘贴公钥并保存"
            echo ""
            read -p "按回车键继续..." dummy
            
            echo ""
            echo "🚀 正在推送代码..."
            echo ""
            git remote set-url origin git@github.com:heluchao/bond-monitor.git
            git push -u origin main
            
            echo ""
            echo "✅ 代码推送成功！"
        else
            echo "❌ 未找到 SSH 密钥"
            echo ""
            echo "请先生成 SSH 密钥:"
            echo "  ssh-keygen -t rsa -b 4096 -C \"your_email@example.com\""
            echo ""
            exit 1
        fi
        ;;
    
    3)
        echo ""
        echo "🔧 使用 GitHub CLI 推送"
        echo ""
        
        if ! command -v gh &> /dev/null; then
            echo "❌ 未安装 GitHub CLI"
            echo ""
            echo "请先安装 GitHub CLI:"
            echo "  brew install gh  # macOS"
            echo ""
            exit 1
        fi
        
        # 检查是否已登录
        if ! gh auth status &> /dev/null; then
            echo "📝 需要先登录 GitHub"
            echo ""
            gh auth login
        fi
        
        echo ""
        echo "🚀 正在推送代码..."
        echo ""
        git push -u origin main
        
        echo ""
        echo "✅ 代码推送成功！"
        ;;
    
    *)
        echo "❌ 无效的选择"
        exit 1
        ;;
esac

echo ""
echo "======================================"
echo "  推送完成"
echo "======================================"
echo ""
echo "📦 仓库地址: https://github.com/heluchao/bond-monitor"
echo "🔗 Actions: https://github.com/heluchao/bond-monitor/actions"
echo ""
echo "📝 下一步:"
echo "1. 访问: https://github.com/heluchao/bond-monitor/settings/secrets/actions"
echo "2. 添加 Secret: WECHAT_WEBHOOK_URL"
echo "3. 测试 Actions 工作流"
echo ""
