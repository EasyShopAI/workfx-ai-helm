#!/bin/bash

# WorkFX-AI Helm Chart 打包脚本
# 用于将Chart打包成tgz文件，便于分发和安装

set -e

# 配置
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHART_DIR="$SCRIPT_DIR/../charts/workfx-ai"
OUTPUT_DIR="$SCRIPT_DIR/../packaged"
VERSION=""
CHART_NAME="workfx-ai"
FORCE=false
SIGN=false

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 显示帮助
show_help() {
    cat << EOF
WorkFX-AI Helm Chart 打包脚本

用法: $0 [选项]

选项:
    -v, --version VERSION    指定Chart版本 (必需)
    -o, --output DIR         输出目录 (默认: ./packaged)
    -c, --chart DIR          Chart目录 (默认: ./charts/workfx-ai)
    -f, --force              强制覆盖已存在的包
    -s, --sign               签名Chart包
    -h, --help               显示此帮助信息

示例:
    # 打包Chart
    $0 -v 1.0.0

    # 指定输出目录
    $0 -v 1.0.0 -o ./my-charts

    # 强制覆盖
    $0 -v 1.0.0 -f

    # 签名Chart包
    $0 -v 1.0.0 -s

EOF
}

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--version)
            VERSION="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -c|--chart)
            CHART_DIR="$2"
            shift 2
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -s|--sign)
            SIGN=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            print_error "未知选项: $1"
            show_help
            exit 1
            ;;
    esac
done

# 验证参数
if [[ -z "$VERSION" ]]; then
    print_error "必须指定Chart版本"
    show_help
    exit 1
fi

if [[ ! -d "$CHART_DIR" ]]; then
    print_error "Chart目录不存在: $CHART_DIR"
    exit 1
fi

if [[ ! -f "$CHART_DIR/Chart.yaml" ]]; then
    print_error "Chart.yaml文件不存在: $CHART_DIR/Chart.yaml"
    exit 1
fi

# 创建输出目录
mkdir -p "$OUTPUT_DIR"

# 检查是否已存在相同版本
PACKAGE_NAME="$CHART_NAME-$VERSION.tgz"
PACKAGE_PATH="$OUTPUT_DIR/$PACKAGE_NAME"

if [[ -f "$PACKAGE_PATH" && "$FORCE" != true ]]; then
    print_warning "Chart包已存在: $PACKAGE_PATH"
    read -p "是否覆盖？(y/N): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        print_info "打包已取消"
        exit 0
    fi
fi

print_info "开始打包WorkFX-AI Helm Chart..."
print_info "Chart目录: $CHART_DIR"
print_info "输出目录: $OUTPUT_DIR"
print_info "版本: $VERSION"
print_info "包名: $PACKAGE_NAME"
echo ""

# 验证Chart
print_info "验证Chart..."
if ! helm lint "$CHART_DIR"; then
    print_error "Chart验证失败"
    exit 1
fi
print_success "Chart验证通过"

# 更新依赖
print_info "更新Chart依赖..."
if ! helm dependency update "$CHART_DIR"; then
    print_error "依赖更新失败"
    exit 1
fi
print_success "依赖更新完成"

# 打包Chart
print_info "打包Chart..."
if helm package "$CHART_DIR" --destination "$OUTPUT_DIR" --version "$VERSION"; then
    print_success "Chart打包成功!"
else
    print_error "Chart打包失败"
    exit 1
fi

# 验证打包结果
if [[ -f "$PACKAGE_PATH" ]]; then
    print_success "Chart包创建成功: $PACKAGE_PATH"
    
    # 显示包信息
    print_info "Chart包信息:"
    ls -lh "$PACKAGE_PATH"
    
    # 验证包内容
    print_info "验证包内容..."
    if helm lint "$PACKAGE_PATH"; then
        print_success "包内容验证通过"
    else
        print_warning "包内容验证失败"
    fi
else
    print_error "Chart包创建失败"
    exit 1
fi

# 签名Chart包（如果启用）
if [[ "$SIGN" == true ]]; then
    print_info "签名Chart包..."
    if command -v cosign &> /dev/null; then
        if cosign sign-blob "$PACKAGE_PATH" --key cosign.key; then
            print_success "Chart包签名成功"
        else
            print_warning "Chart包签名失败"
        fi
    else
        print_warning "cosign未安装，跳过签名"
    fi
fi

# 创建仓库索引
print_info "创建仓库索引..."
if helm repo index "$OUTPUT_DIR" --url https://your-company.com/helm-charts; then
    print_success "仓库索引创建成功"
else
    print_warning "仓库索引创建失败"
fi

# 显示使用说明
echo ""
print_success "🎉 Chart打包完成!"
echo ""
print_info "📋 打包结果:"
echo "   Chart文件: $PACKAGE_PATH"
echo "   Chart目录: $CHART_DIR"
echo "   版本: $VERSION"
echo "   大小: $(du -h "$PACKAGE_PATH" | cut -f1)"
echo ""
print_info "💡 使用方法:"
echo "   # 安装Chart"
echo "   helm install my-release $PACKAGE_PATH \\"
echo "     --namespace my-namespace \\"
echo "     --values my-values.yaml"
echo ""
echo "   # 升级Chart"
echo "   helm upgrade my-release $PACKAGE_PATH \\"
echo "     --namespace my-namespace \\"
echo "     --values my-values.yaml"
echo ""
echo "   # 验证Chart"
echo "   helm lint $PACKAGE_PATH"
echo ""
print_info "🔗 下一步操作:"
echo "   1. 将 $OUTPUT_DIR 目录上传到你的Helm仓库服务"
echo "   2. 更新Helm仓库索引"
echo "   3. 通知用户新版本可用"
echo ""
print_info "📁 输出目录内容:"
ls -la "$OUTPUT_DIR"
