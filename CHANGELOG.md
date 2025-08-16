# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2024-12-19

### Added
- **新增基础设施服务支持**
  - 添加 Kafka 支持，包括 Zookeeper 和持久化存储
  - 添加 Elasticsearch 支持，包括 Kibana 集成
  - 添加 AKHQ (Kafka 管理界面) 支持
  - 支持外部服务集成，允许用户使用自己的基础设施

- **新增配置管理功能**
  - 重构 ConfigMap 模板，支持所有 WorkFX AI 配置项
  - 添加 RAG 检索配置支持
  - 添加速率限制配置支持
  - 添加 URL 提取器配置支持
  - 支持从环境变量和云密钥管理获取配置

- **新增环境配置文件**
  - `values-dev.yaml`: 开发环境配置，包含减少的资源限制和开发友好设置
  - `values-prod.yaml`: 生产环境配置，包含高可用性、安全最佳实践和性能优化

- **新增部署指南**
  - 创建详细的部署指南文档 (`DEPLOYMENT_GUIDE.md`)
  - 包含快速部署、环境特定部署、外部服务集成等说明
  - 提供故障排除和性能调优指南

### Changed
- **重构 Chart 结构**
  - 更新 Chart.yaml，添加新的依赖服务
  - 重构 values.yaml，使其更加清晰和模块化
  - 优化基础设施配置，支持条件部署
  - 改进 secrets 配置，支持外部服务连接

- **重构配置管理**
  - 统一 ConfigMap 管理，所有服务共享一个配置
  - 优化 secrets 模板，支持条件渲染
  - 改进环境变量映射，与 WorkFX AI 配置系统保持一致

- **重构基础设施配置**
  - 支持 PostgreSQL 外部连接配置
  - 支持 Redis 外部连接配置
  - 支持 Kafka 外部连接配置
  - 支持 Elasticsearch 外部连接配置

### Improved
- **性能优化**
  - 生产环境支持多副本部署
  - 支持自动扩缩容配置
  - 优化存储配置，支持高性能存储类
  - 支持 Pod 中断预算和网络策略

- **安全增强**
  - 支持 Pod 安全标准
  - 支持网络策略配置
  - 支持 TLS 加密配置
  - 支持外部密钥管理

- **监控和可观测性**
  - 集成 Elasticsearch 和 Kibana 用于日志和搜索
  - 集成 AKHQ 用于 Kafka 管理
  - 支持健康检查和探针配置
  - 支持指标收集和监控

### Fixed
- 修复 ConfigMap 中缺失的配置项
- 修复 secrets 模板中的条件渲染问题
- 修复基础设施服务的外部连接配置
- 修复 Chart 依赖版本兼容性问题

### Breaking Changes
- 重构了 values.yaml 的结构，可能需要更新现有的部署配置
- 更改了基础设施服务的配置路径
- 更新了 secrets 的配置结构

### Migration Guide
从 0.1.0 升级到 0.2.0：

1. **备份现有配置**
   ```bash
   helm get values workfx-ai -n workfx-ai > current-values.yaml
   ```

2. **更新基础设施配置**
   - 将 `infrastructure.postgresql.host` 移动到 `infrastructure.postgresql.external.host`
   - 将 `infrastructure.redis.host` 移动到 `infrastructure.redis.external.host`
   - 添加新的基础设施服务配置

3. **更新应用配置**
   - 将应用配置移动到 `config` 部分
   - 更新 RAG 和速率限制配置

4. **升级 Helm Chart**
   ```bash
   helm upgrade workfx-ai workfx-ai/workfx-ai \
     --namespace workfx-ai \
     -f values-prod.yaml
   ```

## [0.1.0] - 2024-12-01

### Added
- 初始版本的 WorkFX AI Platform Helm Chart
- 支持 PostgreSQL 和 Redis 作为依赖服务
- 基本的 API 和 CDC 服务部署
- 支持多云部署（Azure、AWS、GCP、本地）
- 基本的配置管理和密钥管理

### Features
- 统一的配置管理
- 支持环境特定配置
- 基本的健康检查和监控
- 支持自动扩缩容
- 基本的 RBAC 和安全配置
