# WorkFX-AI Helm Chart

A Helm chart for deploying WorkFX-AI on Kubernetes.

## Features

- **Multi-service architecture**: API, CDC, and IDB services
- **Environment-aware configuration**: Development, staging, and production environments
- **Cloud provider support**: GCP, Azure, AWS, and local deployments
- **Flexible configuration**: Single values.yaml with environment overrides
- **Easy deployment**: Simple commands for different environments

## Quick Start

### Prerequisites

- Kubernetes cluster (1.19+)
- Helm 3.0+
- kubectl configured

### Basic Installation

```bash
# Install in development environment
make install ENVIRONMENT=dev CLOUD_PROVIDER=gcp

# Install in production environment
make install ENVIRONMENT=prod CLOUD_PROVIDER=azure

# Install locally
make install ENVIRONMENT=dev CLOUD_PROVIDER=local
```

### Using Helm Directly

```bash
# Development on GCP
helm install workfx-ai . \
  --namespace workfx-ai \
  --create-namespace \
  --set global.environment=dev \
  --set global.cloudProvider=gcp

# Production on Azure
helm install workfx-ai . \
  --namespace workfx-ai \
  --create-namespace \
  --set global.environment=prod \
  --set global.cloudProvider=azure

# With custom values file
helm install workfx-ai . \
  --namespace workfx-ai \
  --create-namespace \
  -f values-dev.yaml \
  --set global.environment=dev
```

## Configuration

### Environment Variables

The chart supports three environments:

- **dev**: Development environment with minimal resources
- **staging**: Staging environment with moderate resources
- **prod**: Production environment with full resources and security

### Cloud Providers

Supported cloud providers:

- **gcp**: Google Cloud Platform
- **azure**: Microsoft Azure
- **aws**: Amazon Web Services
- **local**: Local Kubernetes cluster

### Key Configuration Options

```yaml
# Global settings
global:
  environment: "dev"        # dev, staging, prod
  cloudProvider: "gcp"      # gcp, azure, aws, local
  imageRegistry: ""         # Custom image registry
  storageClass: ""          # Storage class name
  domain: ""                # Domain for ingress

# Service configuration
workfx:
  api:
    replicas: 1
    resources:
      limits:
        cpu: "1000m"
        memory: "1Gi"
      requests:
        cpu: "500m"
        memory: "512Mi"

# Enable/disable features
monitoring:
  enabled: false

devTools:
  enabled: false

security:
  networkPolicy:
    enabled: false
```

## Environment-Specific Overrides

### Development Environment

```bash
# Enable development tools and monitoring
helm install workfx-ai . \
  --set global.environment=dev \
  --set devTools.enabled=true \
  --set monitoring.enabled=true
```

### Production Environment

```bash
# Enable production features
helm install workfx-ai . \
  --set global.environment=prod \
  --set security.networkPolicy.enabled=true \
  --set backup.enabled=true \
  --set monitoring.enabled=true
```

## Makefile Targets

```bash
# Install
make install ENVIRONMENT=dev CLOUD_PROVIDER=gcp

# Upgrade
make upgrade ENVIRONMENT=prod CLOUD_PROVIDER=azure

# Uninstall
make uninstall

# Status
make status

# View resources
make pods
make services
make ingress
make pvc

# View logs
make logs
make logs-cdc
make logs-idb
```

## Deployment Script

Use the deployment script for more control:

```bash
# Deploy with script
./scripts/deploy.sh \
  --environment dev \
  --cloud-provider gcp \
  --namespace workfx-ai-dev

# Dry run
./scripts/deploy.sh \
  --environment prod \
  --cloud-provider azure \
  --dry-run

# Upgrade existing deployment
./scripts/deploy.sh \
  --environment staging \
  --cloud-provider aws \
  --upgrade
```

## Examples

### GCP Development

```bash
# Set GCP-specific values
export IMAGE_REGISTRY="gcr.io/your-project"
export STORAGE_CLASS="standard"
export DOMAIN="dev.workfx.ai"

# Deploy
make install ENVIRONMENT=dev CLOUD_PROVIDER=gcp
```

### Azure Production

```bash
# Set Azure-specific values
export IMAGE_REGISTRY="yourregistry.azurecr.io"
export STORAGE_CLASS="managed-premium"
export DOMAIN="workfx.ai"

# Deploy
make install ENVIRONMENT=prod CLOUD_PROVIDER=azure
```

### Local Development

```bash
# Local deployment
make install ENVIRONMENT=dev CLOUD_PROVIDER=local

# Or with custom values
helm install workfx-ai . \
  --namespace workfx-ai \
  --create-namespace \
  -f values-dev.yaml
```

## Troubleshooting

### Common Issues

1. **Storage class not found**: Set the correct storage class for your cluster
2. **Image pull errors**: Ensure image registry credentials are configured
3. **Resource limits**: Adjust resource requests/limits based on your cluster capacity

### Debug Commands

```bash
# Check deployment status
kubectl get pods -n workfx-ai

# View events
kubectl get events -n workfx-ai --sort-by='.lastTimestamp'

# Check logs
kubectl logs -f deployment/workfx-ai-api -n workfx-ai

# Describe resources
kubectl describe deployment workfx-ai-api -n workfx-ai
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with different environments
5. Submit a pull request

## License

This project is licensed under the MIT License.
