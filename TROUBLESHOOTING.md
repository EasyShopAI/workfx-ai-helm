# WorkFX AI - 故障排除指南

## 🚨 **常见问题**

### 1. 镜像拉取失败

**症状**: Pod 状态为 `ImagePullBackOff` 或 `ErrImagePull`

**解决方案**:
```bash
# 检查镜像仓库配置
kubectl describe pod <pod-name> -n workfx-ai

# 确认镜像标签正确
kubectl get deployment workfx-ai-api -n workfx-ai -o yaml | grep image:

# 检查镜像仓库权限
kubectl get secrets -n workfx-ai
```

**常见原因**:
- 镜像标签错误
- 镜像仓库权限不足
- 网络连接问题

### 2. 服务无法访问

**症状**: 无法访问 WorkFX AI API

**解决方案**:
```bash
# 检查服务状态
kubectl get svc -n workfx-ai

# 检查 Pod 状态
kubectl get pods -n workfx-ai

# 检查 Ingress 状态
kubectl get ingress -n workfx-ai

# 检查服务端点
kubectl get endpoints -n workfx-ai
```

**常见原因**:
- Pod 未就绪
- 服务配置错误
- Ingress 配置问题

### 3. 存储问题

**症状**: Pod 状态为 `Pending` 或 PVC 绑定失败

**解决方案**:
```bash
# 检查 PVC 状态
kubectl get pvc -n workfx-ai

# 检查存储类
kubectl get storageclass

# 检查 PV 状态
kubectl get pv
```

**常见原因**:
- 存储类不存在
- 存储空间不足
- 权限配置错误

### 4. 资源不足

**症状**: Pod 状态为 `Pending`，事件显示资源不足

**解决方案**:
```bash
# 检查节点资源
kubectl top nodes

# 检查 Pod 资源使用
kubectl top pods -n workfx-ai

# 调整资源限制
helm upgrade workfx-ai ./charts/workfx-ai \
  --namespace workfx-ai \
  --set workfx.api.resources.limits.cpu=1000m \
  --set workfx.api.resources.limits.memory=2Gi
```

**常见原因**:
- 集群资源不足
- 资源限制过高
- 节点选择器配置错误

## 🔍 **诊断命令**

### 基础检查

```bash
# 检查所有资源状态
kubectl get all -n workfx-ai

# 检查事件
kubectl get events -n workfx-ai --sort-by='.lastTimestamp'

# 检查命名空间状态
kubectl describe namespace workfx-ai
```

### 服务检查

```bash
# 检查服务配置
kubectl describe svc workfx-ai-api -n workfx-ai

# 检查端点
kubectl get endpoints workfx-ai-api -n workfx-ai

# 测试服务连接
kubectl run test-pod --image=busybox -it --rm --restart=Never -- nslookup workfx-ai-api
```

### 日志检查

```bash
# 查看 API 服务日志
kubectl logs -f deployment/workfx-ai-api -n workfx-ai

# 查看数据同步服务日志
kubectl logs -f deployment/workfx-ai-data-sync -n workfx-ai

# 查看特定 Pod 日志
kubectl logs <pod-name> -n workfx-ai
```

### 配置检查

```bash
# 检查 ConfigMap
kubectl describe configmap workfx-ai-config -n workfx-ai

# 检查 Secret
kubectl describe secret workfx-ai-secrets -n workfx-ai

# 检查环境变量
kubectl exec <pod-name> -n workfx-ai -- env | grep -E "(ENV|CLOUD|STORAGE)"
```

## 🛠️ **修复步骤**

### 1. 重新部署

```bash
# 删除现有部署
helm uninstall workfx-ai -n workfx-ai

# 重新安装
helm install workfx-ai ./charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai \
  --set global.domain=your-domain.com
```

### 2. 升级部署

```bash
# 升级到新版本
helm upgrade workfx-ai ./charts/workfx-ai \
  --namespace workfx-ai \
  --set image.api.tag=latest \
  --set image.dataSync.tag=latest
```

### 3. 回滚部署

```bash
# 查看发布历史
helm history workfx-ai -n workfx-ai

# 回滚到指定版本
helm rollback workfx-ai 1 -n workfx-ai
```

## 📊 **监控和告警**

### 启用监控

```bash
# 启用 Prometheus 监控
helm upgrade workfx-ai ./charts/workfx-ai \
  --namespace workfx-ai \
  --set monitoring.prometheus.enabled=true

# 启用 Grafana 仪表板
helm upgrade workfx-ai ./charts/workfx-ai \
  --namespace workfx-ai \
  --set monitoring.grafana.enabled=true
```

### 查看指标

```bash
# 如果启用了 Prometheus
kubectl port-forward svc/prometheus-server 9090:9090 -n workfx-ai

# 访问 http://localhost:9090 查看指标
```

## 🔧 **性能调优**

### 资源优化

```bash
# 调整副本数
helm upgrade workfx-ai ./charts/workfx-ai \
  --namespace workfx-ai \
  --set workfx.api.replicas=5

# 调整资源限制
helm upgrade workfx-ai ./charts/workfx-ai \
  --namespace workfx-ai \
  --set workfx.api.resources.limits.cpu=4000m \
  --set workfx.api.resources.limits.memory=8Gi
```

### 自动扩缩容

```bash
# 启用 HPA
helm upgrade workfx-ai ./charts/workfx-ai \
  --namespace workfx-ai \
  --set workfx.api.autoscaling.enabled=true \
  --set workfx.api.autoscaling.minReplicas=3 \
  --set workfx.api.autoscaling.maxReplicas=10
```

## 📞 **获取帮助**

如果以上步骤无法解决问题，请：

1. **检查日志**: 收集相关服务的日志
2. **检查配置**: 确认 Helm values 配置正确
3. **联系支持**: 通过 [支持渠道](https://workfx.ai/support) 获取帮助

### 提供信息

请提供以下信息以便我们更好地帮助您：

- Kubernetes 版本
- Helm 版本
- 错误日志
- 部署配置
- 问题描述

## 🎯 **预防措施**

### 1. 定期备份

```bash
# 启用自动备份
helm upgrade workfx-ai ./charts/workfx-ai \
  --namespace workfx-ai \
  --set backup.enabled=true
```

### 2. 监控告警

```bash
# 启用监控组件
helm upgrade workfx-ai ./charts/workfx-ai \
  --namespace workfx-ai \
  --set monitoring.prometheus.enabled=true \
  --set monitoring.grafana.enabled=true
```

### 3. 资源规划

- 预留足够的 CPU 和内存资源
- 使用适当的存储类
- 配置合理的资源限制

---

**注意**: 本指南仅包含基本的故障排除步骤。对于复杂问题，建议联系技术支持团队。
