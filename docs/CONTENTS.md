# WorkFX AI Helm Chart 内容概览

## 概述

本文档详细介绍了 WorkFX AI Helm Chart 当前包含的所有组件、配置选项和功能特性。

## Chart 结构

```
workfx-ai-helm/
├── charts/
│   └── workfx-ai/                 # 主 Chart
│       ├── Chart.yaml             # Chart 元数据
│       ├── values.yaml            # 默认配置
│       ├── values-dev.yaml        # 开发环境配置
│       ├── values-prod.yaml       # 生产环境配置
│       └── templates/             # Kubernetes 资源模板
│           ├── configmap.yaml     # 应用配置
│           ├── secrets.yaml       # 密钥配置
│           ├── deployments.yaml   # 部署配置
│           ├── services.yaml      # 服务配置
│           └── ...
├── docs/                          # 文档目录
│   ├── ARCHITECTURE.md            # 架构介绍
│   ├── KA_DEPLOYMENT_GUIDE.md    # KA 用户部署指南
│   └── CONTENTS.md                # 本文档
├── README.md                      # 主要说明文档
├── DEPLOYMENT_GUIDE.md            # 部署指南
└── CHANGELOG.md                   # 变更日志
```

## 核心服务组件

### 1. WorkFX AI 应用服务

#### API 服务
- **镜像**: `workfx/workfx-ai-api`
- **端口**: 8000
- **功能**: 
  - RESTful API 服务器
  - 业务逻辑处理
  - 用户认证和授权
  - 文件上传和管理
  - AI 模型集成
  - RAG 检索服务

#### CDC 服务
- **镜像**: `workfx/workfx-ai-cdc`
- **端口**: 8001
- **功能**:
  - 变更数据捕获
  - 数据同步
  - 实时数据处理
  - 消息队列消费

### 2. 基础设施服务

#### PostgreSQL 数据库
- **Chart**: Bitnami PostgreSQL
- **版本**: 15.x
- **端口**: 5432
- **功能**:
  - 主数据库存储
  - 向量搜索支持 (pgvector)
  - 高可用性配置
  - 读写分离支持
- **外部化**: ✅ 支持外部 PostgreSQL 连接

#### Redis 缓存
- **Chart**: Bitnami Redis
- **版本**: 7.x
- **端口**: 6379
- **功能**:
  - 会话存储
  - 缓存服务
  - 速率限制
  - 任务队列
- **外部化**: ✅ 支持外部 Redis 连接

#### Kafka 消息队列
- **Chart**: Bitnami Kafka
- **版本**: 3.x
- **端口**: 9092
- **功能**:
  - 消息队列
  - 流处理
  - 事件驱动架构
  - CDC 数据流
- **外部化**: ✅ 支持外部 Kafka 连接

#### Elasticsearch 搜索引擎
- **Chart**: Bitnami Elasticsearch
- **版本**: 8.x
- **端口**: 9200
- **功能**:
  - 全文搜索
  - 日志聚合
  - 指标存储
  - 数据分析
- **外部化**: ✅ 支持外部 Elasticsearch 连接

#### Kibana 管理界面
- **Chart**: Bitnami Kibana
- **版本**: 8.x
- **端口**: 80
- **功能**:
  - Elasticsearch 管理
  - 日志查询和分析
  - 数据可视化
  - 监控仪表板

#### AKHQ Kafka 管理界面
- **Chart**: AKHQ
- **版本**: 最新
- **端口**: 80
- **功能**:
  - Kafka 主题管理
  - 消息查看和发送
  - 消费者组管理
  - 集群监控

## 配置选项

### 1. 全局配置

```yaml
global:
  environment: "dev|staging|prod"     # 环境类型
  cloudProvider: "azure|aws|gcp|local" # 云提供商
  imageRegistry: "docker.io"          # 镜像仓库
  domain: "workfx-ai.local"           # 域名
  storageClass: ""                    # 存储类
```

### 2. 应用配置

#### 资源配置
```yaml
workfx:
  api:
    replicas: 1                       # 副本数
    resources:                        # 资源限制
      limits:
        cpu: "1000m"
        memory: "2Gi"
      requests:
        cpu: "500m"
        memory: "1Gi"
```

#### 存储配置
```yaml
workfx:
  storage:
    type: "azure|s3|gcs|local"       # 存储类型
    bucketUriPath: "gs://bucket"     # 存储桶路径
    adminBucketName: "admin-bucket"  # 管理存储桶
    userBucketName: "user-bucket"    # 用户存储桶
    publicBucketName: "public-bucket" # 公共存储桶
```

### 3. 基础设施配置

#### 服务启用/禁用
```yaml
infrastructure:
  postgresql:
    enabled: true                     # 启用 PostgreSQL
  redis:
    enabled: true                     # 启用 Redis
  kafka:
    enabled: true                     # 启用 Kafka
  elasticsearch:
    enabled: true                     # 启用 Elasticsearch
  akhq:
    enabled: true                     # 启用 AKHQ
```

#### 外部服务配置
```yaml
infrastructure:
  postgresql:
    enabled: false                    # 禁用内置服务
    external:
      enabled: true                   # 启用外部服务
      host: "your-host"              # 外部主机
      port: 5432                     # 外部端口
      username: "user"               # 用户名
      password: "password"            # 密码
      database: "db"                 # 数据库名
```

### 4. 应用配置

#### 模型配置
```yaml
config:
  models:
    embedding:
      provider: "azure_openai|openai|google_ai" # 嵌入模型提供商
      name: "text-embedding-ada-002"           # 模型名称
      apiKey: ""                               # API 密钥
      baseUrl: ""                              # 基础 URL
```

#### RAG 配置
```yaml
config:
  rag:
    summaryBoost: "2.0"              # 摘要字段权重
    contentBoost: "1.0"              # 内容字段权重
    vectorSimilarityThreshold: "0.5" # 向量相似度阈值
    enableCaching: "true"            # 启用缓存
    cacheTtlSeconds: "300"           # 缓存 TTL
```

#### 速率限制配置
```yaml
config:
  rateLimit:
    enabled: true                    # 启用速率限制
    tenantCapacityMultiplier: "2000" # 租户容量倍数
    defaultTenantRequestsPerHour: "2000" # 默认每小时请求数
    kaTenantMultiplier: "10"        # KA 租户倍数
```

### 5. 密钥配置

#### 数据库密钥
```yaml
secrets:
  database:
    secret_id: "pg-secret"           # 密钥 ID
    host: "host"                     # 主机
    port: "5432"                     # 端口
    username: "user"                 # 用户名
    password: "password"             # 密码
    database: "db"                   # 数据库名
```

#### Redis 密钥
```yaml
secrets:
  redis:
    secret_id: "tp-redis-secret"     # 密钥 ID
    redis_host: "host"               # Redis 主机
    redis_port: "6379"               # Redis 端口
    redis_password: "password"       # Redis 密码
    redis_db: "0"                    # Redis 数据库
```

## 部署模式

### 1. 完整部署模式

部署所有基础设施服务和应用服务：

```yaml
infrastructure:
  postgresql: enabled: true
  redis: enabled: true
  kafka: enabled: true
  elasticsearch: enabled: true
  akhq: enabled: true
```

**适用场景**:
- 开发环境
- 测试环境
- 没有现有基础设施的环境

### 2. 混合部署模式

使用外部数据库和缓存，部署其他服务：

```yaml
infrastructure:
  postgresql: enabled: false, external: enabled: true
  redis: enabled: false, external: enabled: true
  kafka: enabled: true
  elasticsearch: enabled: true
```

**适用场景**:
- 有现有数据库和缓存
- 需要特定基础设施服务
- 混合云环境

### 3. 最小部署模式

只部署应用服务，所有基础设施使用外部服务：

```yaml
infrastructure:
  postgresql: enabled: false, external: enabled: true
  redis: enabled: false, external: enabled: true
  kafka: enabled: false, external: enabled: true
  elasticsearch: enabled: false, external: enabled: true
```

**适用场景**:
- KA 用户
- 有完整基础设施
- 生产环境

## 环境特定配置

### 开发环境 (values-dev.yaml)

- **资源限制**: 减少的 CPU 和内存限制
- **副本数**: 单副本部署
- **存储**: 较小的持久化存储
- **监控**: 完整的监控服务
- **安全性**: 开发友好的配置

### 生产环境 (values-prod.yaml)

- **资源限制**: 生产级别的资源分配
- **副本数**: 多副本部署
- **存储**: 大容量持久化存储
- **监控**: 生产级监控和告警
- **安全性**: 生产级安全配置

## 云提供商支持

### Azure

- **存储**: Azure Blob Storage
- **密钥管理**: Azure Key Vault
- **身份认证**: Managed Identity
- **网络**: Azure VNet 集成

### AWS

- **存储**: Amazon S3
- **密钥管理**: AWS Secrets Manager
- **身份认证**: IAM 角色
- **网络**: VPC 集成

### GCP

- **存储**: Google Cloud Storage
- **密钥管理**: Google Secret Manager
- **身份认证**: Service Account
- **网络**: VPC 集成

### 本地部署

- **存储**: 本地 PVC
- **密钥管理**: Kubernetes Secret
- **身份认证**: 本地认证
- **网络**: 本地网络

## 监控和可观测性

### 日志管理

- **结构化日志**: JSON 格式输出
- **日志聚合**: Elasticsearch 收集
- **日志查询**: Kibana 界面
- **日志存储**: 持久化存储

### 指标监控

- **应用指标**: 业务性能指标
- **系统指标**: 资源使用指标
- **基础设施指标**: 服务健康指标
- **自定义指标**: 业务特定指标

### 健康检查

- **存活探针**: 服务运行状态
- **就绪探针**: 服务就绪状态
- **启动探针**: 服务启动状态
- **健康端点**: HTTP 健康检查

## 安全特性

### 认证和授权

- **JWT 认证**: 基于令牌的认证
- **RBAC 授权**: 基于角色的访问控制
- **API 密钥**: 服务间认证
- **多租户**: 租户隔离

### 网络安全

- **网络策略**: Pod 级别网络隔离
- **TLS 加密**: HTTPS 通信加密
- **防火墙规则**: 网络访问控制
- **VPN 支持**: 安全网络连接

### 数据安全

- **数据加密**: 传输和存储加密
- **密钥管理**: 云原生密钥管理
- **审计日志**: 操作审计记录
- **数据备份**: 定期数据备份

## 扩展性特性

### 水平扩展

- **自动扩缩容**: HPA 支持
- **多副本部署**: 负载均衡
- **集群部署**: 分布式架构
- **流量分发**: 智能路由

### 垂直扩展

- **资源调整**: 动态资源分配
- **存储扩展**: 动态存储扩容
- **网络扩展**: 网络带宽调整
- **性能调优**: 参数优化

### 插件化架构

- **基础设施插件**: 多种后端支持
- **监控插件**: 多种监控方案
- **安全插件**: 多种安全策略
- **存储插件**: 多种存储方案

## 维护和运维

### 升级策略

- **滚动更新**: 零停机升级
- **蓝绿部署**: 快速回滚
- **金丝雀部署**: 渐进式发布
- **版本管理**: 版本控制和回滚

### 备份和恢复

- **数据备份**: 定期数据备份
- **配置备份**: 配置版本管理
- **灾难恢复**: 快速恢复方案
- **测试恢复**: 恢复流程验证

### 监控和告警

- **性能监控**: 实时性能监控
- **异常告警**: 自动异常检测
- **容量规划**: 资源容量规划
- **趋势分析**: 长期趋势分析

## 总结

WorkFX AI Helm Chart 提供了完整的 Kubernetes 部署解决方案，包含：

1. **完整的应用服务**: API 和 CDC 服务
2. **灵活的基础设施**: 支持内置和外部服务
3. **丰富的配置选项**: 满足不同环境需求
4. **强大的监控能力**: 完整的可观测性
5. **企业级安全**: 生产级安全特性
6. **高度可扩展**: 支持各种扩展需求

通过模块化设计和灵活的配置，用户可以快速部署 WorkFX AI 平台，并根据自己的需求选择合适的部署模式。
