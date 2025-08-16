# KA 用户部署指南

## 概述

本指南专门为 KA（Key Account）用户提供，说明如何使用 WorkFX AI Helm Chart 进行部署。KA 用户通常有自己的基础设施服务，本指南将重点介绍如何集成外部服务。

## KA 用户特点

### 基础设施现状
- **已有数据库**: 通常使用自己的 PostgreSQL 实例
- **已有缓存**: 使用自己的 Redis 集群
- **已有消息队列**: 使用自己的 Kafka 或 RabbitMQ
- **已有存储**: 使用自己的对象存储服务
- **已有监控**: 使用自己的监控和日志系统

### 部署需求
- **最小化资源占用**: 只部署必要的应用服务
- **快速集成**: 快速与现有基础设施集成
- **灵活配置**: 支持复杂的配置需求
- **生产就绪**: 满足生产环境的要求

## 部署模式选择

### 推荐模式：最小部署模式

对于 KA 用户，我们推荐使用**最小部署模式**，即：
- ✅ 部署 WorkFX AI 应用服务（API、CDC）
- ❌ 不部署基础设施服务
- 🔗 连接用户自己的外部服务

### 优势
1. **资源效率**: 最小化 Kubernetes 资源占用
2. **管理简单**: 不需要管理额外的数据库和缓存
3. **集成快速**: 直接使用现有的基础设施
4. **成本控制**: 避免重复的基础设施成本

## 前置要求

### 1. 基础设施服务要求

#### PostgreSQL
- **版本**: 12+ 
- **扩展**: 需要 `pgvector` 扩展支持向量搜索
- **权限**: 需要创建数据库和表的权限
- **网络**: 从 Kubernetes 集群可访问

#### Redis
- **版本**: 6.0+
- **内存**: 建议至少 2GB 可用内存
- **持久化**: 建议启用 RDB 或 AOF 持久化
- **网络**: 从 Kubernetes 集群可访问

#### Kafka（可选）
- **版本**: 2.8+
- **主题**: 需要创建相关主题
- **权限**: 需要读写权限
- **网络**: 从 Kubernetes 集群可访问

#### Elasticsearch（可选）
- **版本**: 7.0+
- **索引**: 需要创建相关索引模板
- **权限**: 需要读写权限
- **网络**: 从 Kubernetes 集群可访问

### 2. Kubernetes 集群要求

- **版本**: 1.19+
- **存储**: 需要配置 StorageClass
- **网络**: 需要配置网络策略
- **资源**: 至少 4GB RAM 和 2 CPU 核心

### 3. Helm 要求

- **版本**: 3.0+
- **权限**: 需要集群管理员权限

## 部署步骤

### 步骤 1: 准备配置文件

创建 KA 用户的配置文件 `values-ka.yaml`：

```yaml
# KA 用户配置文件
global:
  environment: "prod"
  cloudProvider: "azure"  # 根据实际情况调整
  imageRegistry: "your-registry.azurecr.io"
  domain: "workfx-ai.yourdomain.com"
  storageClass: "managed-premium"

# 禁用所有基础设施服务
infrastructure:
  postgresql:
    enabled: false
    external:
      enabled: true
      host: "your-postgres-host"
      port: 5432
      username: "your-username"
      password: "your-password"
      database: "your-database"
      sslMode: "require"
  
  redis:
    enabled: false
    external:
      enabled: true
      host: "your-redis-host"
      port: 6379
      password: "your-password"
      database: 0
  
  kafka:
    enabled: false
    external:
      enabled: true
      bootstrapServers: "your-kafka-host:9092"
      securityProtocol: "PLAINTEXT"
      username: "your-username"
      password: "your-password"
  
  elasticsearch:
    enabled: false
    external:
      enabled: true
      host: "your-elasticsearch-host"
      port: 9200
      username: "your-username"
      password: "your-password"
      useSsl: true
      clusterUrl: "https://your-elasticsearch-host:9200"
  
  akhq:
    enabled: false  # 通常不需要，使用自己的 Kafka 管理工具

# 应用配置
workfx:
  api:
    enabled: true
    replicas: 2
    resources:
      limits:
        cpu: "2000m"
        memory: "4Gi"
      requests:
        cpu: "1000m"
        memory: "2Gi"
  
  cdc:
    enabled: true
    replicas: 1
    resources:
      limits:
        cpu: "1000m"
        memory: "2Gi"
      requests:
        cpu: "500m"
        memory: "1Gi"
  
  storage:
    type: "azure"  # 根据实际情况调整
    bucketUriPath: "https://yourstorageaccount.blob.core.windows.net"
    adminBucketName: "workfx-ai-admin"
    userBucketName: "workfx-ai-user"
    publicBucketName: "workfx-ai-public"
    emailBucketName: "workfx-ai-email"
    toolsImageBucketName: "workfx-ai-tools-image"

# 应用配置
config:
  environment: "prod"
  cloudProvider: "azure"
  kaName: "your-ka-name"
  enableOtel: true
  logLevel: "INFO"
  
  # 模型配置
  models:
    embedding:
      provider: "azure_openai"
      name: "text-embedding-ada-002"
      apiKey: ""  # 通过外部密钥管理设置
      baseUrl: ""
    rerank:
      provider: "azure_openai"
      name: "text-embedding-ada-002"
      apiKey: ""  # 通过外部密钥管理设置
      baseUrl: ""
    llm:
      provider: "azure_openai"
      name: "gpt-4"
      apiKey: ""  # 通过外部密钥管理设置
      baseUrl: ""

# 密钥配置
secrets:
  create: true
  
  # 数据库配置
  database:
    secret_id: "pg-secret"
    host: "{{ .Values.infrastructure.postgresql.external.host }}"
    port: "{{ .Values.infrastructure.postgresql.external.port }}"
    username: "{{ .Values.infrastructure.postgresql.external.username }}"
    password: "{{ .Values.infrastructure.postgresql.external.password }}"
    database: "{{ .Values.infrastructure.postgresql.external.database }}"
  
  # Redis 配置
  redis:
    secret_id: "tp-redis-secret"
    redis_host: "{{ .Values.infrastructure.redis.external.host }}"
    redis_port: "{{ .Values.infrastructure.redis.external.port }}"
    redis_password: "{{ .Values.infrastructure.redis.external.password }}"
    redis_db: "{{ .Values.infrastructure.redis.external.database }}"
    redis_use_ssl: "false"
  
  # Elasticsearch 配置
  elasticsearch:
    secret_id: "es-secret"
    host: "{{ .Values.infrastructure.elasticsearch.external.host }}"
    port: "{{ .Values.infrastructure.elasticsearch.external.port }}"
    username: "{{ .Values.infrastructure.elasticsearch.external.username }}"
    password: "{{ .Values.infrastructure.elasticsearch.external.password }}"
    use_ssl: "{{ .Values.infrastructure.elasticsearch.external.useSsl }}"
    cluster_url: "{{ .Values.infrastructure.elasticsearch.external.clusterUrl }}"
  
  # Kafka 配置
  kafka:
    secret_id: "wfx-kafka-secret"
    bootstrap_servers: "{{ .Values.infrastructure.kafka.external.bootstrapServers }}"
    security_protocol: "{{ .Values.infrastructure.kafka.external.securityProtocol }}"
    document_chunks_topic: "postgres.public.document_chunks"
    agents_topic: "postgres.public.agents"
    consumer_group_prefix: "workfx-ai"
    username: "{{ .Values.infrastructure.kafka.external.username }}"
    password: "{{ .Values.infrastructure.kafka.external.password }}"
  
  # 其他密钥配置
  jwt:
    secret_id: "jwt-secret"
    admin_jwt_key: ""  # 通过外部密钥管理设置
    admin_jwt_issuer: "https://workfx.ai"
    admin_jwt_audience: "https://workfx.ai"
    ai_jwt_key: ""  # 通过外部密钥管理设置
    ai_jwt_issuer: "https://workfx.ai"
    ai_jwt_audience: "https://workfx.ai"
  
  security:
    secret_id: "secret-key"
    data_secret: ""  # 通过外部密钥管理设置
    jina_api_key: ""  # 通过外部密钥管理设置
```

### 步骤 2: 准备外部密钥

#### 方式 1: 使用 Azure Key Vault

```bash
# 创建 Key Vault
az keyvault create --name "your-keyvault" --resource-group "your-rg" --location "eastus"

# 存储密钥
az keyvault secret set --vault-name "your-keyvault" --name "postgres-password" --value "your-password"
az keyvault secret set --vault-name "your-keyvault" --name "redis-password" --value "your-password"
az keyvault secret set --vault-name "your-keyvault" --name "jwt-secret" --value "your-jwt-secret"
az keyvault secret set --vault-name "your-keyvault" --name "openai-api-key" --value "your-api-key"
```

#### 方式 2: 使用 Kubernetes Secret

```bash
# 创建数据库密钥
kubectl create secret generic pg-secret \
  --from-literal=host="your-postgres-host" \
  --from-literal=port="5432" \
  --from-literal=username="your-username" \
  --from-literal=password="your-password" \
  --from-literal=database="your-database" \
  -n workfx-ai

# 创建 Redis 密钥
kubectl create secret generic tp-redis-secret \
  --from-literal=redis_host="your-redis-host" \
  --from-literal=redis_port="6379" \
  --from-literal=redis_password="your-password" \
  --from-literal=redis_db="0" \
  --from-literal=redis_use_ssl="false" \
  -n workfx-ai

# 创建 JWT 密钥
kubectl create secret generic jwt-secret \
  --from-literal=admin_jwt_key="your-jwt-secret" \
  --from-literal=ai_jwt_key="your-ai-jwt-secret" \
  -n workfx-ai
```

### 步骤 3: 部署应用

```bash
# 创建命名空间
kubectl create namespace workfx-ai

# 部署应用
helm install workfx-ai workfx-ai/workfx-ai \
  --namespace workfx-ai \
  --create-namespace \
  -f values-ka.yaml
```

### 步骤 4: 验证部署

```bash
# 检查 Pod 状态
kubectl get pods -n workfx-ai

# 检查服务状态
kubectl get services -n workfx-ai

# 检查配置
kubectl get configmap -n workfx-ai workfx-ai-config -o yaml

# 检查密钥
kubectl get secrets -n workfx-ai
```

## 外部服务集成配置

### PostgreSQL 集成

#### 1. 数据库准备

```sql
-- 创建数据库
CREATE DATABASE workfx_ai;

-- 创建用户
CREATE USER workfx WITH PASSWORD 'your-password';

-- 授权
GRANT ALL PRIVILEGES ON DATABASE workfx_ai TO workfx;

-- 安装 pgvector 扩展
CREATE EXTENSION IF NOT EXISTS vector;
```

#### 2. 连接测试

```bash
# 从 Kubernetes 集群测试连接
kubectl run test-postgres --image=postgres:13 --rm -it --restart=Never -- \
  psql -h your-postgres-host -U workfx -d workfx_ai
```

### Redis 集成

#### 1. Redis 配置

```bash
# 检查 Redis 配置
redis-cli -h your-redis-host -p 6379 -a your-password

# 测试连接
redis-cli -h your-redis-host -p 6379 -a your-password ping
```

#### 2. 从 Kubernetes 测试

```bash
# 测试 Redis 连接
kubectl run test-redis --image=redis:6 --rm -it --restart=Never -- \
  redis-cli -h your-redis-host -p 6379 -a your-password ping
```

### Kafka 集成

#### 1. 主题创建

```bash
# 创建必要的主题
kafka-topics.sh --create --topic postgres.public.document_chunks \
  --bootstrap-server your-kafka-host:9092 \
  --partitions 3 --replication-factor 1

kafka-topics.sh --create --topic postgres.public.agents \
  --bootstrap-server your-kafka-host:9092 \
  --partitions 3 --replication-factor 1
```

#### 2. 权限配置

```bash
# 创建用户
kafka-acls.sh --bootstrap-server your-kafka-host:9092 \
  --add --allow-principal User:workfx \
  --operation Read --topic postgres.public.document_chunks

kafka-acls.sh --bootstrap-server your-kafka-host:9092 \
  --add --allow-principal User:workfx \
  --operation Write --topic postgres.public.document_chunks
```

### Elasticsearch 集成

#### 1. 索引模板

```bash
# 创建索引模板
curl -X PUT "https://your-elasticsearch-host:9200/_template/workfx_ai" \
  -H "Content-Type: application/json" \
  -u your-username:your-password \
  -k \
  -d '{
    "index_patterns": ["workfx_ai_*"],
    "settings": {
      "number_of_shards": 1,
      "number_of_replicas": 1
    }
  }'
```

#### 2. 权限配置

```bash
# 创建角色
curl -X POST "https://your-elasticsearch-host:9200/_security/role/workfx_ai_role" \
  -H "Content-Type: application/json" \
  -u your-username:your-password \
  -k \
  -d '{
    "cluster": ["monitor"],
    "indices": [{
      "names": ["workfx_ai_*"],
      "privileges": ["read", "write", "create_index"]
    }]
  }'

# 创建用户
curl -X POST "https://your-elasticsearch-host:9200/_security/user/workfx_ai" \
  -H "Content-Type: application/json" \
  -u your-username:your-password \
  -k \
  -d '{
    "password": "your-password",
    "roles": ["workfx_ai_role"],
    "full_name": "WorkFX AI User"
  }'
```

## 监控和日志

### 应用监控

```bash
# 查看应用日志
kubectl logs -n workfx-ai deployment/workfx-ai-api -f
kubectl logs -n workfx-ai deployment/workfx-ai-cdc -f

# 查看应用指标
kubectl port-forward -n workfx-ai svc/workfx-ai-api 8000:8000
# 访问 http://localhost:8000/health 和 http://localhost:8000/metrics
```

### 外部服务监控

由于使用外部服务，建议：

1. **使用自己的监控系统**监控外部服务
2. **配置告警**当外部服务不可用时
3. **设置健康检查**定期验证外部服务连接

## 故障排除

### 常见问题

#### 1. 外部服务连接失败

**症状**: Pod 启动失败，日志显示连接错误

**排查步骤**:
```bash
# 检查网络连通性
kubectl run test-connectivity --image=busybox --rm -it --restart=Never -- \
  nslookup your-postgres-host

# 测试端口连通性
kubectl run test-port --image=busybox --rm -it --restart=Never -- \
  nc -zv your-postgres-host 5432
```

**解决方案**:
- 检查网络策略配置
- 验证防火墙规则
- 确认服务地址和端口正确

#### 2. 认证失败

**症状**: 连接成功但认证失败

**排查步骤**:
```bash
# 检查密钥配置
kubectl get secret -n workfx-ai pg-secret -o yaml

# 验证密钥值
echo "your-base64-encoded-password" | base64 -d
```

**解决方案**:
- 重新创建密钥
- 验证用户名和密码
- 检查数据库权限

#### 3. 权限不足

**症状**: 连接成功但操作失败

**排查步骤**:
```bash
# 检查数据库权限
kubectl run test-permissions --image=postgres:13 --rm -it --restart=Never -- \
  psql -h your-postgres-host -U workfx -d workfx_ai -c "\du"
```

**解决方案**:
- 授予必要的数据库权限
- 创建必要的数据库对象
- 配置正确的用户角色

## 性能优化

### 1. 连接池配置

```yaml
# 在 values-ka.yaml 中添加
config:
  database:
    pool_size: 20
    max_overflow: 30
    pool_timeout: 30
    pool_recycle: 3600
```

### 2. 缓存配置

```yaml
config:
  redis:
    connection_pool_size: 10
    socket_timeout: 5
    socket_connect_timeout: 5
```

### 3. 资源限制

```yaml
workfx:
  api:
    resources:
      limits:
        cpu: "4000m"
        memory: "8Gi"
      requests:
        cpu: "2000m"
        memory: "4Gi"
```

## 升级和维护

### 1. 应用升级

```bash
# 升级应用版本
helm upgrade workfx-ai workfx-ai/workfx-ai \
  --namespace workfx-ai \
  -f values-ka.yaml \
  --set workfx.api.image.tag="new-version" \
  --set workfx.cdc.image.tag="new-version"
```

### 2. 配置更新

```bash
# 更新配置
helm upgrade workfx-ai workfx-ai/workfx-ai \
  --namespace workfx-ai \
  -f values-ka.yaml
```

### 3. 回滚

```bash
# 查看历史
helm history workfx-ai -n workfx-ai

# 回滚到指定版本
helm rollback workfx-ai <revision> -n workfx-ai
```

## 最佳实践

### 1. 安全性
- 使用强密码和密钥轮换
- 启用网络策略限制访问
- 使用 TLS 加密通信
- 定期审计权限配置

### 2. 可用性
- 配置外部服务的健康检查
- 设置适当的资源限制
- 监控关键指标
- 准备故障恢复计划

### 3. 性能
- 优化连接池配置
- 配置适当的缓存策略
- 监控资源使用情况
- 定期性能调优

### 4. 运维
- 建立监控和告警体系
- 制定备份和恢复策略
- 建立变更管理流程
- 定期进行安全审计

## 总结

对于 KA 用户，使用最小部署模式可以：
1. **快速集成**现有基础设施
2. **减少资源占用**和运维成本
3. **保持灵活性**和可扩展性
4. **满足生产环境**的要求

通过本指南，KA 用户可以快速、安全地部署 WorkFX AI 平台，同时充分利用现有的基础设施投资。
