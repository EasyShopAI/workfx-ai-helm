# 📚 WorkFX AI 配置参考文档

## 📋 目录

- [全局配置](#全局配置)
- [镜像配置](#镜像配置)
- [应用配置](#应用配置)
- [依赖服务配置](#依赖服务配置)
- [外部服务配置](#外部服务配置)
- [监控配置](#监控配置)
- [安全配置](#安全配置)
- [高级配置](#高级配置)

## 🌍 全局配置 (Global Configuration)

### `global.environment`
**说明**: 环境标识，影响资源配置和默认值  
**类型**: string  
**可选值**: `dev`, `test`, `staging`, `prod`  
**默认值**: `prod`  
**示例**:
```yaml
global:
  environment: "prod"
```

### `global.cloudProvider`
**说明**: 云服务提供商，影响存储、网络等配置  
**类型**: string  
**可选值**: `azure`, `aws`, `gcp`, `local`  
**默认值**: `azure`  
**示例**:
```yaml
global:
  cloudProvider: "azure"
```

### `global.domain`
**说明**: 对外访问域名，需要配置 DNS 和证书  
**类型**: string  
**必需**: 是  
**示例**:
```yaml
global:
  domain: "workfx.ka-company.com"
```

### `global.imageRegistry`
**说明**: Docker 镜像仓库地址  
**类型**: string  
**默认值**: `us-central1-docker.pkg.dev/workfxai-dev/workfx-ai-gar-dev`  
**示例**:
```yaml
global:
  imageRegistry: "your-registry.com/workfx-ai"
```

### `global.imagePullPolicy`
**说明**: 镜像拉取策略  
**类型**: string  
**可选值**: `Always`, `IfNotPresent`, `Never`  
**默认值**: `IfNotPresent`  
**建议**: 生产环境使用 `IfNotPresent`  
**示例**:
```yaml
global:
  imagePullPolicy: "IfNotPresent"
```

### `global.imagePullSecrets`
**说明**: 镜像拉取密钥，用于私有镜像仓库  
**类型**: array  
**默认值**: `[]`  
**示例**:
```yaml
global:
  imagePullSecrets: ["regcred", "dockerhub-secret"]
```

## 🐳 镜像配置 (Image Configuration)

### `image.api.tag`
**说明**: API 服务镜像标签  
**类型**: string  
**必需**: 是  
**建议**: 使用具体版本号，避免 `latest`  
**示例**:
```yaml
image:
  api:
    tag: "1.0.0-20241220-a1b2c3d"
```

### `image.dataSync.tag`
**说明**: 数据同步服务镜像标签  
**类型**: string  
**必需**: 是  
**建议**: 与 API 服务使用相同版本  
**示例**:
```yaml
image:
  dataSync:
    tag: "1.0.0-20241220-a1b2c3d"
```

## 🚀 应用配置 (Application Configuration)

### `workfx.api.replicas`
**说明**: API 服务副本数量  
**类型**: integer  
**默认值**: `2`  
**建议**: 生产环境至少 3 个副本  
**示例**:
```yaml
workfx:
  api:
    replicas: 5
```

### `workfx.api.resources.limits.cpu`
**说明**: API 服务 CPU 限制  
**类型**: string  
**默认值**: `2000m`  
**建议**: 根据实际负载调整  
**示例**:
```yaml
workfx:
  api:
    resources:
      limits:
        cpu: "4000m"  # 4 核
```

### `workfx.api.resources.limits.memory`
**说明**: API 服务内存限制  
**类型**: string  
**默认值**: `4Gi`  
**建议**: 根据实际负载调整  
**示例**:
```yaml
workfx:
  api:
    resources:
      limits:
        memory: "8Gi"  # 8GB
```

### `workfx.api.resources.requests.cpu`
**说明**: API 服务 CPU 请求  
**类型**: string  
**默认值**: `1000m`  
**建议**: 通常设置为 limits 的 50%  
**示例**:
```yaml
workfx:
  api:
    resources:
      requests:
        cpu: "2000m"  # 2 核
```

### `workfx.api.resources.requests.memory`
**说明**: API 服务内存请求  
**类型**: string  
**默认值**: `2Gi`  
**建议**: 通常设置为 limits 的 50%  
**示例**:
```yaml
workfx:
  api:
    resources:
      requests:
        memory: "4Gi"  # 4GB
```

### `workfx.api.ingress.enabled`
**说明**: 是否启用入口  
**类型**: boolean  
**默认值**: `false`  
**示例**:
```yaml
workfx:
  api:
    ingress:
      enabled: true
```

### `workfx.api.ingress.hosts`
**说明**: 入口主机配置  
**类型**: array  
**必需**: 如果启用 ingress  
**示例**:
```yaml
workfx:
  api:
    ingress:
      hosts:
        - host: workfx.ka-company.com
          paths:
            - path: /
              pathType: Prefix
```

### `workfx.api.ingress.tls`
**说明**: TLS 配置，用于 HTTPS  
**类型**: array  
**示例**:
```yaml
workfx:
  api:
    ingress:
      tls:
        - secretName: workfx-ai-tls
          hosts:
            - workfx.ka-company.com
```

### `workfx.api.autoscaling.enabled`
**说明**: 是否启用自动扩缩容  
**类型**: boolean  
**默认值**: `false`  
**示例**:
```yaml
workfx:
  api:
    autoscaling:
      enabled: true
```

### `workfx.api.autoscaling.minReplicas`
**说明**: 自动扩缩容最小副本数  
**类型**: integer  
**默认值**: `1`  
**示例**:
```yaml
workfx:
  api:
    autoscaling:
      minReplicas: 3
```

### `workfx.api.autoscaling.maxReplicas`
**说明**: 自动扩缩容最大副本数  
**类型**: integer  
**默认值**: `10`  
**示例**:
```yaml
workfx:
  api:
    autoscaling:
      maxReplicas: 20
```

### `workfx.api.autoscaling.targetCPUUtilizationPercentage`
**说明**: CPU 使用率目标百分比  
**类型**: integer  
**默认值**: `80`  
**建议**: 生产环境使用 60-70%  
**示例**:
```yaml
workfx:
  api:
    autoscaling:
      targetCPUUtilizationPercentage: 60
```

### `workfx.api.autoscaling.targetMemoryUtilizationPercentage`
**说明**: 内存使用率目标百分比  
**类型**: integer  
**默认值**: `80`  
**建议**: 生产环境使用 70-80%  
**示例**:
```yaml
workfx:
  api:
    autoscaling:
      targetMemoryUtilizationPercentage: 70
```

### `workfx.dataSync.replicas`
**说明**: 数据同步服务副本数量  
**类型**: integer  
**默认值**: `1`  
**示例**:
```yaml
workfx:
  dataSync:
    replicas: 3
```

### `workfx.dataSync.resources`
**说明**: 数据同步服务资源配置，格式同 API 服务  
**类型**: object  
**示例**:
```yaml
workfx:
  dataSync:
    resources:
      limits:
        cpu: "2000m"
        memory: "4Gi"
      requests:
        cpu: "1000m"
        memory: "2Gi"
```

## ⚙️ 应用配置覆盖 (Configuration Overrides)

### `config.environment`
**说明**: 应用环境标识  
**类型**: string  
**默认值**: `prod`  
**示例**:
```yaml
config:
  environment: "prod"
```

### `config.cloudProvider`
**说明**: 应用云服务提供商  
**类型**: string  
**默认值**: `azure`  
**示例**:
```yaml
config:
  cloudProvider: "azure"
```

### `config.kaName`
**说明**: KA 公司名称标识  
**类型**: string  
**必需**: 是  
**示例**:
```yaml
config:
  kaName: "ka-company"
```

### `config.models.embedding.provider`
**说明**: 嵌入模型提供商  
**类型**: string  
**可选值**: `openai`, `azure_openai`, `anthropic`, `cohere`  
**默认值**: `azure_openai`  
**示例**:
```yaml
config:
  models:
    embedding:
      provider: "azure_openai"
```

### `config.models.embedding.name`
**说明**: 嵌入模型名称  
**类型**: string  
**默认值**: `text-embedding-ada-002`  
**示例**:
```yaml
config:
  models:
    embedding:
      name: "text-embedding-ada-002"
```

### `config.models.rerank.provider`
**说明**: 重排序模型提供商  
**类型**: string  
**可选值**: `cohere`, `azure_ai_foundry`  
**默认值**: `azure_ai_foundry`  
**示例**:
```yaml
config:
  models:
    rerank:
      provider: "azure_ai_foundry"
```

### `config.models.rerank.name`
**说明**: 重排序模型名称  
**类型**: string  
**默认值**: `Cohere-rerank-v3.5`  
**示例**:
```yaml
config:
  models:
    rerank:
      name: "Cohere-rerank-v3.5"
```

## 🔗 外部服务配置 (External Service Configuration)

### `external.database.external`
**说明**: 是否使用外部数据库  
**类型**: boolean  
**默认值**: `false`  
**示例**:
```yaml
external:
  database:
    external: true
```

### `external.database.url`
**说明**: 外部数据库连接 URL  
**类型**: string  
**必需**: 如果使用外部数据库  
**示例**:
```yaml
external:
  database:
    url: "postgresql://user:pass@host:5432/db"
```

### `external.redis.external`
**说明**: 是否使用外部 Redis  
**类型**: boolean  
**默认值**: `false`  
**示例**:
```yaml
external:
  redis:
    external: true
```

### `external.redis.url`
**说明**: 外部 Redis 连接 URL  
**类型**: string  
**必需**: 如果使用外部 Redis  
**示例**:
```yaml
external:
  redis:
    url: "redis://user:pass@host:6379"
```

### `external.elasticsearch.external`
**说明**: 是否使用外部 Elasticsearch  
**类型**: boolean  
**默认值**: `false`  
**示例**:
```yaml
external:
  elasticsearch:
    external: true
```

### `external.elasticsearch.url`
**说明**: 外部 Elasticsearch 连接 URL  
**类型**: string  
**必需**: 如果使用外部 Elasticsearch  
**示例**:
```yaml
external:
  elasticsearch:
    url: "http://user:pass@host:9200"
```

### `external.kafka.external`
**说明**: 是否使用外部 Kafka  
**类型**: boolean  
**默认值**: `false`  
**示例**:
```yaml
external:
  kafka:
    external: true
```

### `external.kafka.bootstrapServers`
**说明**: 外部 Kafka 服务器地址  
**类型**: string  
**必需**: 如果使用外部 Kafka  
**示例**:
```yaml
external:
  kafka:
    bootstrapServers: "host:9092"
```

## 🗄️ 依赖服务配置 (Dependency Services Configuration)

### `postgresql.enabled`
**说明**: 是否部署 PostgreSQL  
**类型**: boolean  
**默认值**: `true`  
**注意**: 如果使用外部数据库，设置为 `false`  
**示例**:
```yaml
postgresql:
  enabled: false  # 使用外部数据库
```

### `redis.enabled`
**说明**: 是否部署 Redis  
**类型**: boolean  
**默认值**: `true`  
**注意**: 如果使用外部 Redis，设置为 `false`  
**示例**:
```yaml
redis:
  enabled: false  # 使用外部 Redis
```

### `elasticsearch.enabled`
**说明**: 是否部署 Elasticsearch  
**类型**: boolean  
**默认值**: `true`  
**注意**: 如果使用外部 Elasticsearch，设置为 `false`  
**示例**:
```yaml
elasticsearch:
  enabled: false  # 使用外部 Elasticsearch
```

### `kafka.enabled`
**说明**: 是否部署 Kafka  
**类型**: boolean  
**默认值**: `true`  
**注意**: 如果使用外部 Kafka，设置为 `false`  
**示例**:
```yaml
kafka:
  enabled: false  # 使用外部 Kafka
```

### `kibana.enabled`
**说明**: 是否部署 Kibana  
**类型**: boolean  
**默认值**: `true`  
**注意**: 如果使用外部 Kibana，设置为 `false`  
**示例**:
```yaml
kibana:
  enabled: false  # 使用外部 Kibana
```

### `akhq.enabled`
**说明**: 是否部署 AKHQ  
**类型**: boolean  
**默认值**: `true`  
**注意**: 如果使用外部 Kafka 管理界面，设置为 `false`  
**示例**:
```yaml
akhq:
  enabled: false  # 使用外部管理界面
```

## 📊 监控配置 (Monitoring Configuration)

### `monitoring.prometheus.enabled`
**说明**: 是否启用 Prometheus  
**类型**: boolean  
**默认值**: `false`  
**示例**:
```yaml
monitoring:
  prometheus:
    enabled: true
```

### `monitoring.grafana.enabled`
**说明**: 是否启用 Grafana  
**类型**: boolean  
**默认值**: `false`  
**示例**:
```yaml
monitoring:
  grafana:
    enabled: true
```

### `monitoring.grafana.adminPassword`
**说明**: Grafana 管理员密码  
**类型**: string  
**必需**: 如果启用 Grafana  
**示例**:
```yaml
monitoring:
  grafana:
    adminPassword: "secure-password"
```

### `monitoring.jaeger.enabled`
**说明**: 是否启用 Jaeger  
**类型**: boolean  
**默认值**: `false`  
**示例**:
```yaml
monitoring:
  jaeger:
    enabled: true
```

## 🔒 安全配置 (Security Configuration)

### `security.podSecurityContext.fsGroup`
**说明**: 文件系统组 ID  
**类型**: integer  
**默认值**: `1000`  
**示例**:
```yaml
security:
  podSecurityContext:
    fsGroup: 1000
```

### `security.podSecurityContext.runAsNonRoot`
**说明**: 是否不以 root 用户运行  
**类型**: boolean  
**默认值**: `true`  
**建议**: 生产环境必须启用  
**示例**:
```yaml
security:
  podSecurityContext:
    runAsNonRoot: true
```

### `security.podSecurityContext.runAsUser`
**说明**: 运行用户 ID  
**类型**: integer  
**默认值**: `1000`  
**示例**:
```yaml
security:
  podSecurityContext:
    runAsUser: 1000
```

### `security.containerSecurityContext.allowPrivilegeEscalation`
**说明**: 是否允许权限提升  
**类型**: boolean  
**默认值**: `false`  
**建议**: 生产环境必须禁用  
**示例**:
```yaml
security:
  containerSecurityContext:
    allowPrivilegeEscalation: false
```

### `security.containerSecurityContext.capabilities.drop`
**说明**: 删除的 Linux 能力  
**类型**: array  
**默认值**: `["ALL"]`  
**建议**: 生产环境删除所有能力  
**示例**:
```yaml
security:
  containerSecurityContext:
    capabilities:
      drop:
        - ALL
```

### `security.containerSecurityContext.readOnlyRootFilesystem`
**说明**: 是否使用只读根文件系统  
**类型**: boolean  
**默认值**: `true`  
**建议**: 生产环境启用  
**示例**:
```yaml
security:
  containerSecurityContext:
    readOnlyRootFilesystem: true
```

### `security.networkPolicy.enabled`
**说明**: 是否启用网络策略  
**类型**: boolean  
**默认值**: `false`  
**建议**: 生产环境启用  
**示例**:
```yaml
security:
  networkPolicy:
    enabled: true
```

### `security.rbac.enabled`
**说明**: 是否启用 RBAC  
**类型**: boolean  
**默认值**: `false`  
**建议**: 生产环境启用  
**示例**:
```yaml
security:
  rbac:
    enabled: true
```

### `security.rbac.create`
**说明**: 是否创建 RBAC 资源  
**类型**: boolean  
**默认值**: `true`  
**示例**:
```yaml
security:
  rbac:
    create: true
```

## ⚡ 高级配置 (Advanced Configuration)

### `advanced.podDisruptionBudget.enabled`
**说明**: 是否启用 Pod 中断预算  
**类型**: boolean  
**默认值**: `false`  
**建议**: 生产环境启用  
**示例**:
```yaml
advanced:
  podDisruptionBudget:
    enabled: true
```

### `advanced.podDisruptionBudget.minAvailable`
**说明**: 最少可用 Pod 数量  
**类型**: integer  
**默认值**: `1`  
**示例**:
```yaml
advanced:
  podDisruptionBudget:
    minAvailable: 3
```

### `advanced.hpa.enabled`
**说明**: 是否启用水平 Pod 自动扩缩容  
**类型**: boolean  
**默认值**: `false`  
**注意**: 与 `workfx.api.autoscaling.enabled` 重复，建议使用后者  
**示例**:
```yaml
advanced:
  hpa:
    enabled: true
```

### `advanced.podAntiAffinity.enabled`
**说明**: 是否启用 Pod 反亲和性  
**类型**: boolean  
**默认值**: `false`  
**建议**: 生产环境启用，确保高可用性  
**示例**:
```yaml
advanced:
  podAntiAffinity:
    enabled: true
```

### `advanced.podAntiAffinity.type`
**说明**: Pod 反亲和性类型  
**类型**: string  
**可选值**: `required`, `preferred`  
**默认值**: `preferred`  
**建议**: 生产环境使用 `required`  
**示例**:
```yaml
advanced:
  podAntiAffinity:
    type: "required"
```

### `advanced.topologySpreadConstraints.enabled`
**说明**: 是否启用拓扑分布约束  
**类型**: boolean  
**默认值**: `false`  
**建议**: 生产环境启用，跨节点分布 Pod  
**示例**:
```yaml
advanced:
  topologySpreadConstraints:
    enabled: true
```

### `advanced.topologySpreadConstraints.maxSkew`
**说明**: 最大偏差  
**类型**: integer  
**默认值**: `1`  
**示例**:
```yaml
advanced:
  topologySpreadConstraints:
    maxSkew: 1
```

### `advanced.topologySpreadConstraints.topologyKey`
**说明**: 拓扑键  
**类型**: string  
**默认值**: `kubernetes.io/hostname`  
**示例**:
```yaml
advanced:
  topologySpreadConstraints:
    topologyKey: "kubernetes.io/hostname"
```

### `advanced.topologySpreadConstraints.whenUnsatisfiable`
**说明**: 不满足时的行为  
**类型**: string  
**可选值**: `DoNotSchedule`, `ScheduleAnyway`  
**默认值**: `DoNotSchedule`  
**示例**:
```yaml
advanced:
  topologySpreadConstraints:
    whenUnsatisfiable: "DoNotSchedule"
```

## 🔐 密钥配置 (Secrets Configuration)

### `secrets.jwt.secretKey`
**说明**: JWT 密钥  
**类型**: string  
**必需**: 是  
**建议**: 使用强随机密钥  
**示例**:
```yaml
secrets:
  jwt:
    secretKey: "your-secret-key-here"
```

### `secrets.jwt.audience`
**说明**: JWT 受众  
**类型**: string  
**默认值**: 与 `global.domain` 相同  
**示例**:
```yaml
secrets:
  jwt:
    audience: "https://workfx.ka-company.com"
```

### `secrets.jwt.issuer`
**说明**: JWT 签发者  
**类型**: string  
**默认值**: 与 `global.domain` 相同  
**示例**:
```yaml
secrets:
  jwt:
    issuer: "https://workfx.ka-company.com"
```

### `secrets.external.openaiApiKey`
**说明**: OpenAI API 密钥  
**类型**: string  
**必需**: 如果使用 OpenAI 模型  
**示例**:
```yaml
secrets:
  external:
    openaiApiKey: "your-openai-key-here"
```

### `secrets.external.azureOpenaiApiKey`
**说明**: Azure OpenAI API 密钥  
**类型**: string  
**必需**: 如果使用 Azure OpenAI 模型  
**示例**:
```yaml
secrets:
  external:
    azureOpenaiApiKey: "your-azure-openai-key-here"
```

## 💾 备份配置 (Backup Configuration)

### `backup.enabled`
**说明**: 是否启用备份  
**类型**: boolean  
**默认值**: `false`  
**建议**: 生产环境启用  
**示例**:
```yaml
backup:
  enabled: true
```

### `backup.schedule`
**说明**: 备份计划 (Cron 表达式)  
**类型**: string  
**默认值**: `"0 1 * * *"` (每天凌晨 1 点)  
**示例**:
```yaml
backup:
  schedule: "0 1 * * *"
```

### `backup.retention`
**说明**: 备份保留天数  
**类型**: integer  
**默认值**: `30`  
**示例**:
```yaml
backup:
  retention: 30
```

## 💾 资源管理 (Resource Management)

### `resources.storageClasses.default`
**说明**: 默认存储类  
**类型**: string  
**默认值**: `managed-premium` (Azure)  
**示例**:
```yaml
resources:
  storageClasses:
    default: "managed-premium"
```

### `resources.storageClasses.fast`
**说明**: 快速存储类  
**类型**: string  
**默认值**: `managed-premium` (Azure)  
**示例**:
```yaml
resources:
  storageClasses:
    fast: "managed-premium"
```

### `resources.storageClasses.slow`
**说明**: 慢速存储类  
**类型**: string  
**默认值**: `managed-standard` (Azure)  
**示例**:
```yaml
resources:
  storageClasses:
    slow: "managed-standard"
```

## 📝 配置最佳实践

### 1. 环境配置
- 开发环境：使用最小资源配置
- 测试环境：使用中等资源配置
- 生产环境：使用高可用配置

### 2. 资源规划
- CPU 请求：通常设置为限制的 50%
- 内存请求：通常设置为限制的 50%
- 副本数量：生产环境至少 3 个

### 3. 安全配置
- 启用 Pod 安全上下文
- 启用网络策略
- 启用 RBAC
- 使用只读根文件系统

### 4. 监控配置
- 启用 Prometheus 指标收集
- 启用 Grafana 可视化
- 启用 Jaeger 分布式追踪

### 5. 备份策略
- 定期备份数据和配置
- 测试备份恢复流程
- 跨区域存储备份

---

**注意**: 此文档涵盖了主要的配置选项。对于高级配置和特定用例，请参考 Helm Chart 的完整 `values.yaml` 文件。
