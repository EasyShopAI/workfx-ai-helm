# WorkFX-AI Helm Quick Start Guide

Get WorkFX-AI running on Kubernetes in minutes!

## 🚀 Quick Deploy

### 1. Prerequisites

```bash
# Check Kubernetes
kubectl cluster-info

# Check Helm
helm version

# Check storage classes
kubectl get storageclass
```

### 2. Deploy in One Command

```bash
# Development environment
make install ENVIRONMENT=dev CLOUD_PROVIDER=gcp

# Production environment  
make install ENVIRONMENT=prod CLOUD_PROVIDER=azure

# Local development
make install ENVIRONMENT=dev CLOUD_PROVIDER=local
```

### 3. Verify Deployment

```bash
# Check pods
make pods

# Check services
make services

# Check status
make status
```

## 🌍 Cloud-Specific Examples

### Google Cloud Platform (GCP)

```bash
# Set GCP environment
export IMAGE_REGISTRY="gcr.io/your-project"
export STORAGE_CLASS="standard"
export DOMAIN="dev.workfx.ai"

# Deploy
make install ENVIRONMENT=dev CLOUD_PROVIDER=gcp
```

### Microsoft Azure

```bash
# Set Azure environment
export IMAGE_REGISTRY="yourregistry.azurecr.io"
export STORAGE_CLASS="managed-premium"
export DOMAIN="workfx.ai"

# Deploy
make install ENVIRONMENT=prod CLOUD_PROVIDER=azure
```

### Amazon Web Services (AWS)

```bash
# Set AWS environment
export IMAGE_REGISTRY="public.ecr.aws"
export STORAGE_CLASS="gp2"
export DOMAIN="aws.workfx.ai"

# Deploy
make install ENVIRONMENT=staging CLOUD_PROVIDER=aws
```

### Local Kubernetes

```bash
# Local deployment (minikube, kind, etc.)
make install ENVIRONMENT=dev CLOUD_PROVIDER=local
```

## 🔧 Custom Configuration

### Using Values File

```bash
# Create custom values
cp values.yaml my-values.yaml
# Edit my-values.yaml

# Deploy with custom values
helm install workfx-ai . \
  --namespace workfx-ai \
  --create-namespace \
  -f my-values.yaml \
  --set global.environment=dev
```

### Using Command Line Overrides

```bash
helm install workfx-ai . \
  --namespace workfx-ai \
  --create-namespace \
  --set global.environment=prod \
  --set workfx.api.replicas=3 \
  --set monitoring.enabled=true \
  --set security.networkPolicy.enabled=true
```

## 📊 Environment Comparison

| Feature | Dev | Staging | Prod |
|---------|-----|---------|------|
| API Replicas | 1 | 2 | 3 |
| Resources | Minimal | Moderate | Full |
| Monitoring | Basic | Enhanced | Full |
| Security | Basic | Enhanced | Strict |
| Backup | Disabled | Optional | Enabled |
| Dev Tools | Enabled | Optional | Disabled |

## 🛠️ Common Operations

### Update Configuration

```bash
# Upgrade with new values
make upgrade ENVIRONMENT=prod CLOUD_PROVIDER=azure

# Or with Helm
helm upgrade workfx-ai . \
  --set global.environment=prod
```

### Scale Services

```bash
# Scale API service
kubectl scale deployment workfx-ai-api --replicas=5 -n workfx-ai

# Or update values and upgrade
helm upgrade workfx-ai . \
  --set workfx.api.replicas=5
```

### View Logs

```bash
# API logs
make logs

# CDC logs
make logs-cdc

# IDB logs
make logs-idb
```

### Troubleshoot

```bash
# Check events
make events

# Check PVCs
make pvc

# Check ingress
make ingress
```

## 🧹 Cleanup

```bash
# Uninstall
make uninstall

# Remove namespace
kubectl delete namespace workfx-ai
```

## 📚 Next Steps

1. **Configure Monitoring**: Enable Prometheus and Grafana
2. **Set up Backup**: Configure backup schedules
3. **Security**: Enable network policies and RBAC
4. **Scaling**: Configure HPA and VPA
5. **CI/CD**: Integrate with your deployment pipeline

## 🆘 Need Help?

- Check the [main README](README.md) for detailed documentation
- Use `make help` to see all available commands
- Check pod logs: `make logs`
- View events: `make events`
- Check status: `make status`
