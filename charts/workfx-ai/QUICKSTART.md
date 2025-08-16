# 🚀 WorkFX AI 快速开始指南

## 📋 目录

- [快速部署](#快速部署)
- [配置说明](#配置说明)
- [依赖服务选择](#依赖服务选择)
- [常见部署场景](#常见部署场景)
- [故障排除](#故障排除)

## ⚡ 快速部署

### 1. 基本部署（使用默认配置）

```bash
# 克隆 Helm Chart 仓库
git clone https://github.com/workfx-ai/workfx-ai-helm.git
cd workfx-ai-helm

# 基本部署
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai
```

### 2. 使用 KA 示例配置

```bash
# 使用 KA 示例配置文件
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  -f values-ka-example.yaml
```

### 3. 自定义配置部署

```bash
# 自定义域名和副本数
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  -f values-ka-example.yaml \
  --set global.domain=your-domain.com \
  --set workfx.api.replicas=10
```

## ⚙️ 配置说明

### 🌍 全局配置

```yaml
global:
  environment: "prod"           # 环境标识
  cloudProvider: "azure"        # 云服务提供商
  domain: "workfx.ka-company.com"  # 对外域名
  imageRegistry: "..."          # 镜像仓库地址
```

**重要配置项**：
- `environment`: 环境标识，影响资源配置
- `cloudProvider`: 云服务提供商，影响存储和网络配置
- `domain`: 对外访问域名，需要配置 DNS 和证书

### 🐳 镜像配置

```yaml
image:
  api:
    tag: "1.0.0-20241220-a1b2c3d"  # API 服务版本
  dataSync:
    tag: "1.0.0-20241220-a1b2c3d"  # 数据同步服务版本
```

**建议**：
- 使用具体版本号，避免 `latest`
- 两个服务使用相同版本以确保兼容性

### 🚀 应用配置

```yaml
workfx:
  api:
    replicas: 5                # 副本数量
    resources:
      limits:
        cpu: "4000m"           # CPU 限制
        memory: "8Gi"          # 内存限制
      requests:
        cpu: "2000m"           # CPU 请求
        memory: "4Gi"          # 内存请求
```

**资源配置建议**：
- 生产环境：至少 3 个副本
- 资源限制：防止单个 Pod 占用过多资源
- 资源请求：确保 Pod 有足够资源运行

## 🗄️ 依赖服务选择

### 📊 依赖服务配置矩阵

| 服务 | 我们部署 | KA 自部署 | 说明 |
|------|----------|-----------|------|
| **PostgreSQL** | `enabled: true` | `enabled: false` + 配置外部连接 | 核心数据库 |
| **Redis** | `enabled: true` | `enabled: false` + 配置外部连接 | 缓存和会话 |
| **Elasticsearch** | `enabled: true` | `enabled: false` + 配置外部连接 | 搜索引擎 |
| **Kafka** | `enabled: true` | `enabled: false` + 配置外部连接 | 消息队列 |
| **Kibana** | `enabled: true` | `enabled: false` | ES 可视化界面 |
| **AKHQ** | `enabled: true` | `enabled: false` | Kafka 管理界面 |

### 🔧 配置外部服务

如果 KA 使用自己的服务：

```yaml
# 禁用内置服务
postgresql:
  enabled: false

redis:
  enabled: false

elasticsearch:
  enabled: false

kafka:
  enabled: false

# 配置外部服务连接
external:
  database:
    external: true
    url: "postgresql://user:pass@host:5432/db"
  
  redis:
    external: true
    url: "redis://user:pass@host:6379"
  
  elasticsearch:
    external: true
    url: "http://user:pass@host:9200"
  
  kafka:
    external: true
    bootstrapServers: "host:9092"
```

## 🎯 常见部署场景

### 1. 🧪 开发环境

```yaml
global:
  environment: "dev"
  cloudProvider: "local"

workfx:
  api:
    replicas: 1
    resources:
      limits:
        cpu: "1000m"
        memory: "2Gi"
      requests:
        cpu: "500m"
        memory: "1Gi"

# 启用所有依赖服务
postgresql:
  enabled: true
redis:
  enabled: true
elasticsearch:
  enabled: true
kafka:
  enabled: true
```

### 2. 🚀 生产环境

```yaml
global:
  environment: "prod"
  cloudProvider: "azure"

workfx:
  api:
    replicas: 5
    resources:
      limits:
        cpu: "4000m"
        memory: "8Gi"
      requests:
        cpu: "2000m"
        memory: "4Gi"

# 使用外部服务
postgresql:
  enabled: false
redis:
  enabled: false
elasticsearch:
  enabled: false
kafka:
  enabled: false

# 启用监控和安全
monitoring:
  prometheus:
    enabled: true
  grafana:
    enabled: true

security:
  networkPolicy:
    enabled: true
  rbac:
    enabled: true
```

### 3. ☁️ 混合云环境

```yaml
global:
  environment: "prod"
  cloudProvider: "azure"

# 部分使用外部服务，部分自部署
postgresql:
  enabled: false  # 使用外部数据库

redis:
  enabled: true   # 自部署 Redis

elasticsearch:
  enabled: false  # 使用外部 ES

kafka:
  enabled: true   # 自部署 Kafka
```

## 🔍 故障排除

### 1. 部署失败

```bash
# 检查 Helm 状态
helm status workfx-ai -n workfx-ai

# 查看 Pod 状态
kubectl get pods -n workfx-ai

# 查看 Pod 日志
kubectl logs -n workfx-ai deployment/workfx-ai-api
```

### 2. 服务无法访问

```bash
# 检查 Service 状态
kubectl get svc -n workfx-ai

# 检查 Ingress 状态
kubectl get ingress -n workfx-ai

# 检查网络策略
kubectl get networkpolicy -n workfx-ai
```

### 3. 资源不足

```bash
# 检查节点资源
kubectl describe nodes

# 检查 Pod 资源使用
kubectl top pods -n workfx-ai

# 检查 PVC 状态
kubectl get pvc -n workfx-ai
```

## 📚 下一步

1. **阅读完整配置**: 查看 `values-ka-example.yaml` 了解所有配置选项
2. **调整配置**: 根据实际需求修改配置
3. **测试部署**: 先在测试环境验证配置
4. **生产部署**: 确认无误后部署到生产环境
5. **监控运维**: 部署后监控系统状态

## 🆘 获取帮助

- 📖 **文档**: 查看项目 README 和文档
- 🐛 **问题**: 在 GitHub Issues 中报告问题
- 💬 **讨论**: 参与社区讨论
- 📧 **支持**: 联系技术支持团队

---

**祝您部署顺利！** 🎉
