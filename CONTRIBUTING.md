# 贡献指南

感谢您对 WorkFX AI Helm Chart 的关注！我们欢迎社区贡献。

## 🤝 **如何贡献**

### 1. 报告问题

如果您发现了问题或有改进建议，请：

- 在 GitHub Issues 中创建新的 issue
- 提供详细的问题描述和复现步骤
- 包含您的环境信息（Kubernetes 版本、Helm 版本等）

### 2. 提交代码

如果您想贡献代码：

1. Fork 本仓库
2. 创建功能分支：`git checkout -b feature/your-feature`
3. 提交更改：`git commit -am 'Add some feature'`
4. 推送分支：`git push origin feature/your-feature`
5. 创建 Pull Request

### 3. 贡献类型

我们欢迎以下类型的贡献：

- 🐛 Bug 修复
- ✨ 新功能
- 📚 文档改进
- 🧪 测试用例
- 🔧 配置优化

## 📋 **贡献要求**

### 代码质量

- 遵循 Helm chart 最佳实践
- 添加适当的注释和文档
- 确保所有测试通过
- 遵循现有的代码风格

### 提交信息

使用清晰的提交信息格式：

```
type(scope): description

- feat: 新功能
- fix: Bug 修复
- docs: 文档更新
- style: 代码格式调整
- refactor: 代码重构
- test: 测试相关
- chore: 构建过程或辅助工具的变动
```

### 测试

- 确保 Helm chart 可以正常安装
- 验证所有配置选项正常工作
- 测试不同环境下的部署

## 🏗️ **开发环境**

### 前置要求

- Kubernetes 集群（本地或远程）
- Helm 3.8+
- kubectl
- Docker（用于测试镜像）

### 本地测试

```bash
# 克隆仓库
git clone https://github.com/your-username/workfx-ai-helm.git
cd workfx-ai-helm

# 测试 Helm chart
helm lint charts/workfx-ai
helm template charts/workfx-ai

# 本地安装测试
helm install workfx-ai-test charts/workfx-ai \
  --create-namespace \
  --namespace workfx-ai-test \
  --dry-run
```

### 验证配置

```bash
# 验证 values.yaml
helm lint charts/workfx-ai

# 渲染模板
helm template charts/workfx-ai

# 检查依赖
helm dependency list charts/workfx-ai
```

## 📚 **文档贡献**

### 文档类型

- README 文件
- 配置说明
- 部署指南
- 故障排除
- 最佳实践

### 文档要求

- 使用清晰的 Markdown 格式
- 包含实际的命令示例
- 提供截图或图表（如需要）
- 保持文档的时效性

## 🔍 **代码审查**

所有贡献都会经过代码审查：

1. 自动化检查（CI/CD）
2. 代码质量审查
3. 功能测试验证
4. 文档完整性检查

### 审查标准

- 代码符合项目规范
- 功能按预期工作
- 测试覆盖充分
- 文档更新完整

## 🚀 **发布流程**

### 版本管理

我们使用语义化版本控制：

- **主版本号**: 不兼容的 API 修改
- **次版本号**: 向下兼容的功能性新增
- **修订号**: 向下兼容的问题修正

### 发布步骤

1. 更新 `Chart.yaml` 中的版本号
2. 更新 `CHANGELOG.md`
3. 创建版本标签
4. 发布到 Helm 仓库

## 📞 **获取帮助**

如果您在贡献过程中遇到问题：

- 查看现有文档
- 搜索已关闭的 issues
- 在 Discussions 中提问
- 联系维护团队

## 🎯 **贡献重点**

我们特别关注以下方面：

- **易用性**: 让 KA 更容易部署和使用
- **稳定性**: 确保生产环境的可靠性
- **性能**: 优化资源使用和响应时间
- **安全性**: 遵循安全最佳实践
- **兼容性**: 支持多种环境和配置

## 📄 **许可证**

通过贡献代码，您同意您的贡献将在 MIT 许可证下发布。

---

感谢您的贡献！让我们一起让 WorkFX AI 变得更好！🎉
