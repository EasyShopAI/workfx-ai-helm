#!/bin/bash

# WorkFX-AI Helm Deployment Script
# This script provides a convenient way to deploy WorkFX-AI to different environments

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
CHART_PATH="./charts/workfx-ai"
NAMESPACE="workfx-ai"
RELEASE_NAME="workfx-ai"
ENVIRONMENT="dev"
CLOUD_PROVIDER="local"
VALUES_FILE=""
DRY_RUN=false
UPGRADE=false
UNINSTALL=false

# Function to print usage
print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -e, --environment ENV     Environment (dev, staging, prod) [default: dev]"
    echo "  -c, --cloud-provider CP   Cloud provider (local, gcp, azure, aws) [default: local]"
    echo "  -n, --namespace NS        Kubernetes namespace [default: workfx-ai]"
    echo "  -r, --release-name RN     Helm release name [default: workfx-ai]"
    echo "  -f, --values-file FILE    Custom values file to use"
    echo "  -d, --dry-run            Perform a dry run (helm install --dry-run)"
    echo "  -u, --upgrade            Upgrade existing release"
    echo "  -x, --uninstall          Uninstall existing release"
    echo "  -h, --help               Show this help message"
    echo ""
    echo "Examples:"
    echo "  # Deploy to local development environment"
    echo "  $0 -e dev -c local"
    echo ""
    echo "  # Deploy to GCP production environment"
    echo "  $0 -e prod -c gcp -f examples/gcp-production.yaml"
    echo ""
    echo "  # Upgrade existing release"
    echo "  $0 -e prod -c gcp -u"
    echo ""
    echo "  # Uninstall release"
    echo "  $0 -x"
}

# Function to print colored output
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

# Function to check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."
    
    # Check if kubectl is installed
    if ! command -v kubectl &> /dev/null; then
        print_error "kubectl is not installed. Please install kubectl first."
        exit 1
    fi
    
    # Check if helm is installed
    if ! command -v helm &> /dev/null; then
        print_error "helm is not installed. Please install helm first."
        exit 1
    fi
    
    # Check if kubectl is configured
    if ! kubectl cluster-info &> /dev/null; then
        print_error "kubectl is not configured. Please configure kubectl first."
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Function to determine values file
determine_values_file() {
    if [[ -n "$VALUES_FILE" ]]; then
        if [[ ! -f "$VALUES_FILE" ]]; then
            print_error "Values file not found: $VALUES_FILE"
            exit 1
        fi
        return
    fi
    
    # Use default values.yaml with environment overrides
    VALUES_FILE="values.yaml"
    print_info "Using default values.yaml with environment overrides"
    
    if [[ ! -f "$VALUES_FILE" ]]; then
        print_warning "Values file not found: $VALUES_FILE, using default values.yaml"
        VALUES_FILE="values.yaml"
    fi
}

# Function to create namespace
create_namespace() {
    if [[ "$UNINSTALL" == true ]]; then
        return
    fi
    
    print_info "Creating namespace: $NAMESPACE"
    
    if kubectl get namespace "$NAMESPACE" &> /dev/null; then
        print_info "Namespace $NAMESPACE already exists"
    else
        kubectl create namespace "$NAMESPACE"
        print_success "Namespace $NAMESPACE created"
    fi
}

# Function to check secrets
check_secrets() {
    if [[ "$UNINSTALL" == true ]]; then
        return
    fi
    
    print_info "Checking required secrets..."
    
    case "$CLOUD_PROVIDER" in
        "gcp")
            if ! kubectl get secret gar-access -n "$NAMESPACE" &> /dev/null; then
                print_warning "Secret 'gar-access' not found in namespace $NAMESPACE"
                print_info "Please create it using:"
                echo "kubectl create secret docker-registry gar-access \\"
                echo "  --docker-server=us-central1-docker.pkg.dev \\"
                echo "  --docker-username=oauth2accesstoken \\"
                echo "  --docker-password=\"\$(gcloud auth print-access-token)\" \\"
                echo "  --docker-email=your-email@domain.com \\"
                echo "  -n $NAMESPACE"
            fi
            ;;
        "azure")
            if ! kubectl get secret aks-secret -n "$NAMESPACE" &> /dev/null; then
                print_warning "Secret 'aks-secret' not found in namespace $NAMESPACE"
                print_info "Please create it using:"
                echo "kubectl create secret docker-registry aks-secret \\"
                echo "  --docker-server=your-acr.azurecr.io \\"
                echo "  --docker-username=your-username \\"
                echo "  --docker-password=your-password \\"
                echo "  --docker-email=your-email@domain.com \\"
                echo "  -n $NAMESPACE"
            fi
            ;;
        "aws")
            if ! kubectl get secret ecr-secret -n "$NAMESPACE" &> /dev/null; then
                print_warning "Secret 'ecr-secret' not found in namespace $NAMESPACE"
                print_info "Please create it using:"
                echo "kubectl create secret docker-registry ecr-secret \\"
                echo "  --docker-server=your-account.dkr.ecr.region.amazonaws.com \\"
                echo "  --docker-username=AWS \\"
                echo "  --docker-password=\$(aws ecr get-login-password --region region) \\"
                echo "  -n $NAMESPACE"
            fi
            ;;
    esac
}

# Function to deploy
deploy() {
    if [[ "$UNINSTALL" == true ]]; then
        uninstall_release
        return
    fi
    
    local helm_cmd="helm"
    local helm_args=()
    
    if [[ "$UPGRADE" == true ]]; then
        helm_cmd="helm upgrade"
        helm_args+=("$RELEASE_NAME" "$CHART_PATH")
    else
        helm_cmd="helm install"
        helm_args+=("$RELEASE_NAME" "$CHART_PATH")
    fi
    
    helm_args+=(
        "--namespace" "$NAMESPACE"
        "--create-namespace"
        "-f" "$VALUES_FILE"
    )
    
    # Add environment-specific overrides
    if [[ -n "$ENVIRONMENT" ]]; then
        helm_args+=("--set" "global.environment=$ENVIRONMENT")
    fi
    
    if [[ -n "$CLOUD_PROVIDER" ]]; then
        helm_args+=("--set" "global.cloudProvider=$CLOUD_PROVIDER")
    fi
    
    if [[ -n "$IMAGE_REGISTRY" ]]; then
        helm_args+=("--set" "global.imageRegistry=$IMAGE_REGISTRY")
    fi
    
    if [[ -n "$STORAGE_CLASS" ]]; then
        helm_args+=("--set" "global.storageClass=$STORAGE_CLASS")
    fi
    
    if [[ -n "$DOMAIN" ]]; then
        helm_args+=("--set" "global.domain=$DOMAIN")
    fi
    
    if [[ "$DRY_RUN" == true ]]; then
        helm_args+=("--dry-run" "--debug")
    fi
    
    print_info "Executing: $helm_cmd ${helm_args[*]}"
    
    if [[ "$DRY_RUN" == true ]]; then
        $helm_cmd "${helm_args[@]}"
    else
        if $helm_cmd "${helm_args[@]}"; then
            print_success "Deployment completed successfully!"
            
            if [[ "$UPGRADE" == true ]]; then
                print_info "Release upgraded: $RELEASE_NAME"
            else
                print_info "Release installed: $RELEASE_NAME"
            fi
            
            print_info "Namespace: $NAMESPACE"
            print_info "Values file: $VALUES_FILE"
            
            # Show deployment status
            sleep 5
            kubectl get pods -n "$NAMESPACE"
            
        else
            print_error "Deployment failed!"
            exit 1
        fi
    fi
}

# Function to uninstall release
uninstall_release() {
    print_info "Uninstalling release: $RELEASE_NAME"
    
    if helm uninstall "$RELEASE_NAME" -n "$NAMESPACE"; then
        print_success "Release uninstalled successfully!"
        
        # Ask if user wants to delete namespace
        read -p "Do you want to delete namespace $NAMESPACE? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            kubectl delete namespace "$NAMESPACE"
            print_success "Namespace $NAMESPACE deleted"
        fi
    else
        print_error "Failed to uninstall release!"
        exit 1
    fi
}

# Function to show deployment info
show_info() {
    print_info "Deployment Configuration:"
    echo "  Environment: $ENVIRONMENT"
    echo "  Cloud Provider: $CLOUD_PROVIDER"
    echo "  Namespace: $NAMESPACE"
    echo "  Release Name: $RELEASE_NAME"
    echo "  Values File: $VALUES_FILE"
    echo "  Chart Path: $CHART_PATH"
    echo "  Dry Run: $DRY_RUN"
    echo "  Upgrade: $UPGRADE"
    echo "  Uninstall: $UNINSTALL"
    echo ""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -c|--cloud-provider)
            CLOUD_PROVIDER="$2"
            shift 2
            ;;
        -n|--namespace)
            NAMESPACE="$2"
            shift 2
            ;;
        -r|--release-name)
            RELEASE_NAME="$2"
            shift 2
            ;;
        -f|--values-file)
            VALUES_FILE="$2"
            shift 2
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -u|--upgrade)
            UPGRADE=true
            shift
            ;;
        -x|--uninstall)
            UNINSTALL=true
            shift
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            print_usage
            exit 1
            ;;
    esac
done

# Main execution
main() {
    print_info "WorkFX-AI Helm Deployment Script"
    echo ""
    
    show_info
    
    if [[ "$UNINSTALL" == true ]]; then
        check_prerequisites
        uninstall_release
        exit 0
    fi
    
    check_prerequisites
    determine_values_file
    create_namespace
    check_secrets
    deploy
    
    print_success "Script completed successfully!"
}

# Run main function
main "$@"
