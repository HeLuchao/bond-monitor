#!/bin/sh

# ============================================================================
# CodeBuddy 新债监控插件 - 入口脚本
# ============================================================================
# 
# 功能：查询可转债申购信息，通过微信推送新债提醒
# 
# 参数说明（CodeBuddy 会自动添加 PLUGIN_ 前缀）：
#   - PLUGIN_SERVERCHAN_SENDKEY: Server酱 SendKey（必需）
#   - PLUGIN_SEND_DAILY_STATUS: 是否发送每日状态通知（可选，默认 false）
#   - PLUGIN_PUSH_TIME: 推送时间（可选，默认 09:00）
#
# 使用示例：
#   docker run --rm \
#     -e PLUGIN_SERVERCHAN_SENDKEY="SCTxxxxxx" \
#     -e PLUGIN_SEND_DAILY_STATUS="true" \
#     heluchao/bond-monitor-plugin:latest
# 
# ============================================================================

set -e  # 遇到错误立即退出

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印标题
print_header() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║     新债监控 - CodeBuddy Plugin       ║${NC}"
    echo -e "${BLUE}║          Bond Monitor Plugin           ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    echo ""
}

# 打印信息
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# 打印成功
print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# 打印警告
print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# 打印错误
print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 主函数
main() {
    print_header
    
    # ========================================
    # 1. 获取并验证参数
    # ========================================
    print_info "正在加载插件配置..."
    
    SERVERCHAN_SENDKEY="${PLUGIN_SERVERCHAN_SENDKEY:-}"
    SEND_DAILY_STATUS="${PLUGIN_SEND_DAILY_STATUS:-false}"
    PUSH_TIME="${PLUGIN_PUSH_TIME:-09:00}"
    
    # 验证必需参数
    if [ -z "$SERVERCHAN_SENDKEY" ]; then
        print_error "缺少必需参数：SERVERCHAN_SENDKEY"
        echo ""
        echo "请在插件配置中提供 Server酱 SendKey"
        echo "获取地址：https://sct.ftqq.com/"
        echo ""
        exit 1
    fi
    
    # 显示配置信息（隐藏敏感信息）
    print_info "插件配置："
    echo "  ├─ SendKey: ${SERVERCHAN_SENDKEY:0:10}****"
    echo "  ├─ 每日通知: $SEND_DAILY_STATUS"
    echo "  └─ 推送时间: $PUSH_TIME"
    echo ""
    
    # ========================================
    # 2. 导出环境变量
    # ========================================
    export SERVERCHAN_SENDKEY
    export SEND_DAILY_STATUS
    
    # ========================================
    # 3. 执行查询脚本
    # ========================================
    print_info "开始查询新债信息..."
    echo ""
    
    # 执行 Python 脚本
    cd /app
    python scripts/query_bond.py
    
    # 检查执行结果
    EXIT_CODE=$?
    
    echo ""
    
    if [ $EXIT_CODE -eq 0 ]; then
        print_success "执行成功！"
        echo ""
        echo "📊 查询结果："
        echo "  ├─ 请检查个人微信是否收到推送消息"
        echo "  ├─ 如果今天有新债申购，会收到详细信息"
        echo "  └─ 如果今天无新债，可能不会收到推送（取决于配置）"
        echo ""
        echo "💡 提示："
        echo "  - 新债申购时间通常在上午 9:30-11:30"
        echo "  - 建议设置每天早上 9:00 自动执行"
        echo "  - 配置 SEND_DAILY_STATUS=true 可每日接收状态通知"
        echo ""
    else
        print_error "执行失败"
        echo ""
        echo "请检查以下内容："
        echo "  1. SendKey 是否正确"
        echo "  2. 网络连接是否正常"
        echo "  3. AkShare API 是否可访问"
        echo ""
        echo "如需帮助，请访问：https://github.com/HeLuchao/bond-monitor"
        echo ""
        exit 1
    fi
}

# 执行主函数
main "$@"
