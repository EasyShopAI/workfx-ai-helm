# 变更日志

本项目遵循 [语义化版本控制](https://semver.org/lang/zh-CN/) 规范。

## [未发布]

### 新增
- 初始 Helm chart 发布
- 支持 GCP、Azure、AWS 多云部署
- 内置 PostgreSQL、Redis、Elasticsearch、RabbitMQ 服务
- 自动密钥生成和配置管理
- 生产就绪的监控和备份功能

### 变更
- 无

### 修复
- 无

## [0.1.0] - 2024-12-20

### 新增
- 🎉 首次发布 WorkFX AI Helm Chart
- 🚀 一键部署功能
- 🔧 智能默认配置
- 🌍 多云支持（GCP、Azure、AWS）
- 📊 内置数据库和缓存服务
- 🔐 自动密钥管理
- 📈 自动扩缩容支持
- 🎨 高度可定制配置

### 特性
- **核心服务**: WorkFX AI API 和数据同步服务
- **存储服务**: PostgreSQL、Redis、Elasticsearch、RabbitMQ
- **监控**: Prometheus、Grafana、Jaeger
- **安全**: RBAC、网络策略、Pod 安全上下文
- **备份**: 自动备份和灾难恢复
- **扩展**: 水平 Pod 自动扩缩容

### 支持的环境
- **开发环境**: 最小资源配置，开发工具支持
- **测试环境**: 中等资源配置，监控支持
- **生产环境**: 完整资源配置，安全加固

### 支持的云平台
- **Google Cloud Platform (GCP)**: 完整支持
- **Microsoft Azure**: 完整支持
- **Amazon Web Services (AWS)**: 完整支持
- **本地部署**: 支持本地 Kubernetes 集群

---

## 版本说明

- **主版本号**: 不兼容的 API 修改
- **次版本号**: 向下兼容的功能性新增
- **修订号**: 向下兼容的问题修正

## 升级指南

### 从 0.1.0 升级

当前版本为初始发布版本，无需升级步骤。

---

**注意**: 本变更日志记录了 Helm Chart 的变更历史。应用本身的变更请参考应用代码仓库的变更日志。
