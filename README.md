# WorkFX AI Helm Chart

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Helm](https://img.shields.io/badge/Helm-3.8+-blue.svg)](https://helm.sh/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.20+-blue.svg)](https://kubernetes.io/)

## 🚀 **像开源软件一样简单部署！**

WorkFX AI 是一个企业级 AI 平台，现在支持像 APISIX、Redis 等开源软件一样的一键部署！KA 只需要几个命令就能完成部署，无需复杂的配置。

## ✨ **主要特性**

- 🎯 **一键部署**: 像其他 Helm chart 一样简单
- 🔧 **智能默认值**: 开箱即用，无需复杂配置
- 🌍 **多云支持**: GCP、Azure、AWS 一键切换
- 📊 **内置服务**: PostgreSQL、Redis、Elasticsearch、RabbitMQ
- 🔐 **自动密钥生成**: 无需手动创建密钥
- 📈 **生产就绪**: 自动扩缩容、监控、备份
- 🎨 **高度可定制**: 支持 KA 自定义所有配置

## 📋 **前置要求**

- Kubernetes 1.20+
- Helm 3.8+
- 至少 4GB 可用内存
- 至少 20GB 可用存储空间

## 🚀 **快速开始**

### 1. 从 GitHub 克隆部署（推荐）

#### **步骤 1: 克隆仓库**
```bash
# 克隆 WorkFX AI Helm 仓库
git clone https://github.com/workfx-ai/workfx-ai-helm.git
cd workfx-ai-helm
```

#### **步骤 2: 配置部署参数**
```bash
# 编辑配置文件，替换关键参数
vim charts/workfx-ai/values-ka-example.yaml

# 或者直接使用命令行参数覆盖
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  --set global.domain=your-company.com \
  --set global.imageRegistry=your-registry.com/workfx-ai
```

#### **步骤 3: 执行部署**
```bash
# 使用配置文件部署
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  -f charts/workfx-ai/values-ka-example.yaml

# 或者使用命令行参数部署
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  --set global.domain=your-company.com
```

### 2. 自定义部署

```bash
# 自定义配置部署
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  --set global.domain=your-domain.com \
  --set global.cloudProvider=azure \
  --set workfx.api.replicas=3 \
  --set workfx.api.resources.limits.cpu=4000m
```

### 3. 使用配置文件

```bash
# 使用自定义配置文件
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  -f values-ka-example.yaml
```

## 🌟 **部署示例**

### GCP 环境

```bash
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  --set global.domain=workfx.yourcompany.com \
  --set global.cloudProvider=gcp \
  --set gcp.enabled=true \
  --set gcp.projectId=your-gcp-project
```

### Azure 环境

```bash
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  --set global.domain=workfx.yourcompany.com \
  --set global.cloudProvider=azure \
  --set azure.enabled=true \
  --set azure.tenantId=your-tenant-id
```

### 使用外部服务

```bash
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  --set postgresql.enabled=false \
  --set external.database.external=true \
  --set external.database.url="your-db-url"
```

## 📚 **详细部署指南**

### **方法 1: 从 GitHub 克隆部署（推荐）**

#### **前置要求**
- Kubernetes 1.20+
- Helm 3.8+
- Git
- 至少 4GB 可用内存
- 至少 20GB 可用存储空间

#### **完整部署步骤**

##### **步骤 1: 克隆仓库**
```bash
# 克隆 WorkFX AI Helm 仓库
git clone https://github.com/workfx-ai/workfx-ai-helm.git
cd workfx-ai-helm

# 验证文件结构
ls -la charts/workfx-ai/
```

##### **步骤 2: 配置部署参数**

**选项 A: 编辑配置文件（推荐）**
```bash
# 编辑示例配置文件
vim charts/workfx-ai/values-ka-example.yaml

# 关键配置项说明：
# - global.domain: 替换为你的域名
# - global.imageRegistry: 替换为你的镜像仓库
# - secrets.jwt.secretKey: 替换为实际的 JWT 密钥
# - external.database.url: 替换为实际的数据库连接字符串
```

**选项 B: 使用命令行参数覆盖**
```bash
# 直接使用命令行参数，无需编辑文件
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  --set global.domain=workfx.yourcompany.com \
  --set global.imageRegistry=your-registry.com/workfx-ai \
  --set secrets.jwt.secretKey=your-actual-secret-key \
  --set external.database.url="postgresql://user:pass@host:5432/db"
```

##### **步骤 3: 执行部署**
```bash
# 使用配置文件部署
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  -f charts/workfx-ai/values-ka-example.yaml

# 验证部署状态
helm list -n workfx-ai
kubectl get pods -n workfx-ai
```

##### **步骤 4: 验证部署**
```bash
# 检查所有 Pod 状态
kubectl get pods -n workfx-ai

# 检查服务状态
kubectl get svc -n workfx-ai

# 查看日志
kubectl logs -n workfx-ai deployment/workfx-ai-api
```

#### **配置参数说明**

**必需配置项**
```bash
# 域名配置
--set global.domain=workfx.yourcompany.com

# 镜像仓库
--set global.imageRegistry=your-registry.com/workfx-ai

# JWT 密钥
--set secrets.jwt.secretKey=your-secret-key
--set secrets.jwt.audience=https://workfx.yourcompany.com
--set secrets.jwt.issuer=https://workfx.yourcompany.com
```

**可选配置项**
```bash
# 云提供商
--set global.cloudProvider=azure  # 或 gcp, aws

# 资源限制
--set workfx.api.replicas=3
--set workfx.api.resources.limits.cpu=4000m
--set workfx.api.resources.limits.memory=8Gi

# 存储配置
--set postgresql.primary.persistence.size=50Gi
--set redis.master.persistence.size=20Gi
```

#### **常见问题解决**

**问题 1: 镜像拉取失败**
```bash
# 检查镜像仓库配置
kubectl describe pod -n workfx-ai <pod-name>

# 解决方案：确保镜像仓库地址正确且可访问
--set global.imageRegistry=your-registry.com/workfx-ai
```

**问题 2: 数据库连接失败**
```bash
# 检查数据库配置
kubectl logs -n workfx-ai deployment/workfx-ai-api | grep database

# 解决方案：验证数据库连接字符串
--set external.database.url="postgresql://user:pass@host:5432/db"
```

**问题 3: 域名无法访问**
```bash
# 检查 Ingress 配置
kubectl get ingress -n workfx-ai

# 解决方案：确保域名 DNS 解析正确
--set global.domain=workfx.yourcompany.com
```

### **方法 2: 使用外部 Helm 仓库（未来支持）**

> **注意**: 此功能正在开发中，未来将支持直接从 Helm Hub 安装。

```bash
# 未来将支持的一键安装方式
helm repo add workfx-ai https://helm.workfx.ai
helm repo update
helm install workfx-ai workfx-ai/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  --set global.domain=your-company.com
```

## 📋 **配置选项**

### 基础配置

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `global.domain` | 应用域名 | `workfx-ai.local` |
| `global.cloudProvider` | 云提供商 | `gcp` |
| `workfx.api.replicas` | API 服务副本数 | `2` |
| `workfx.api.resources.limits.cpu` | CPU 限制 | `2000m` |
| `workfx.api.resources.limits.memory` | 内存限制 | `4Gi` |

### 模型配置

```bash
# 使用 OpenAI 模型
--set config.models.embedding.provider=openai \
--set config.models.embedding.name=text-embedding-ada-002

# 使用 Azure OpenAI
--set config.models.embedding.provider=azure_openai \
--set config.models.embedding.name=text-embedding-ada-002
```

### 存储配置

```bash
# 自定义存储大小
--set postgresql.primary.persistence.size=20Gi \
--set redis.master.persistence.size=10Gi \
--set elasticsearch.master.persistence.size=50Gi

# 使用外部存储
--set postgresql.enabled=false \
--set external.database.external=true \
--set external.database.url="your-db-url"
```

## 🔐 **密钥管理**

### 自动生成（推荐）

```bash
# Helm 会自动生成所有必要的密钥
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai
```

### 手动提供

```bash
# 提供自定义密钥
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  --set secrets.jwt.secretKey="your-secret-key" \
  --set secrets.external.openaiApiKey="your-openai-key"
```

## 📊 **监控和扩展**

### 启用监控

```bash
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  --set monitoring.prometheus.enabled=true \
  --set monitoring.grafana.enabled=true \
  --set monitoring.jaeger.enabled=true
```

### 自动扩缩容

```bash
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  --set workfx.api.autoscaling.enabled=true \
  --set workfx.api.autoscaling.minReplicas=3 \
  --set workfx.api.autoscaling.maxReplicas=20
```

## 🚨 **故障排除**

### 检查部署状态

```bash
# 查看所有资源
kubectl get all -n workfx-ai

# 查看 Pod 状态
kubectl get pods -n workfx-ai

# 查看服务状态
kubectl get svc -n workfx-ai
```

### 查看日志

```bash
# 查看 API 服务日志
kubectl logs -f deployment/workfx-ai-api -n workfx-ai

# 查看数据同步服务日志
kubectl logs -f deployment/workfx-ai-data-sync -n workfx-ai
```

## 🔄 **升级和回滚**

### 升级应用

```bash
# 升级到新版本
helm upgrade workfx-ai ./charts/workfx-ai \
  --namespace workfx-ai \
  --set image.api.tag=1.1.0 \
  --set image.dataSync.tag=1.1.0
```

### 回滚

```bash
# 查看发布历史
helm history workfx-ai -n workfx-ai

# 回滚到指定版本
helm rollback workfx-ai 1 -n workfx-ai
```

## 📁 **文件结构**

```
charts/workfx-ai/
├── Chart.yaml              # Chart 元数据
├── values.yaml             # 默认配置
├── values-ka-example.yaml  # KA 配置示例
├── QUICKSTART.md           # 快速开始指南
├── templates/              # Kubernetes 模板
│   ├── configmap.yaml      # 配置映射
│   ├── secret.yaml         # 密钥
│   ├── deployment.yaml     # 部署
│   ├── service.yaml        # 服务
│   └── ...
└── charts/                 # 依赖 charts
    ├── postgresql/         # PostgreSQL
    ├── redis/              # Redis
    ├── elasticsearch/      # Elasticsearch
    └── rabbitmq/           # RabbitMQ
```

## 🎯 **最佳实践**

### 1. 使用命名空间

```bash
# 为每个环境创建独立的命名空间
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai-prod
```

### 2. 使用配置文件

```bash
# 为不同环境创建配置文件
# values-prod.yaml, values-staging.yaml, values-dev.yaml
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai-prod \
  -f values-prod.yaml
```

### 3. 启用监控

```bash
# 生产环境建议启用监控
--set monitoring.prometheus.enabled=true \
--set monitoring.grafana.enabled=true
```

### 4. 配置备份

```bash
# 生产环境建议启用备份
--set backup.enabled=true \
--set backup.schedule="0 2 * * *" \
--set backup.retention=30
```

## 🤝 **支持**

- 📖 [快速开始指南](./charts/workfx-ai/QUICKSTART.md)
- 📋 [完整配置选项](./charts/workfx-ai/values.yaml)
- 🎨 [KA 配置示例](./charts/workfx-ai/values-ka-example.yaml)
- 🚨 [故障排除指南](./TROUBLESHOOTING.md)
- 📧 [技术支持](https://workfx.ai/support)

## 📄 **许可证**

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🤝 **贡献**

我们欢迎社区贡献！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解如何参与。

## 🎉 **总结**

### **当前部署方式**

WorkFX AI 目前支持从 GitHub 克隆部署，步骤简单清晰：

```bash
# 1. 克隆仓库
git clone https://github.com/workfx-ai/workfx-ai-helm.git
cd workfx-ai-helm

# 2. 配置参数
vim charts/workfx-ai/values-ka-example.yaml

# 3. 执行部署
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  -f charts/workfx-ai/values-ka-example.yaml

# 完成！🎉
```

### **部署优势**

- ✅ **配置清晰** - 每个配置项都有详细注释和说明
- ✅ **结构完整** - 包含所有必要的服务和依赖
- ✅ **高度可定制** - 支持 KA 自定义所有配置
- ✅ **开箱即用** - 内置 PostgreSQL、Redis、Elasticsearch 等服务
- ✅ **生产就绪** - 支持自动扩缩容、监控、备份

### **未来计划**

- 🚧 **Helm Hub 发布** - 未来将支持直接从 Helm Hub 安装
- 🚧 **一键安装脚本** - 提供自动化部署脚本
- 🚧 **配置向导** - 交互式配置生成工具

**现在 KA 可以按照详细部署指南，轻松完成 WorkFX AI 的部署！**
