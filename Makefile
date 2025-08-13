# WorkFX-AI Helm Chart Makefile
# This Makefile provides convenient commands for deploying WorkFX-AI

.PHONY: help install upgrade uninstall status logs lint test clean

# Default values
CHART_PATH := ./charts/workfx-ai
RELEASE_NAME := workfx-ai
NAMESPACE := workfx-ai
ENVIRONMENT := dev
CLOUD_PROVIDER := local

# Help target
help: ## Show this help message
	@echo "WorkFX-AI Helm Chart - Available Commands:"
	@echo ""
	@echo "Installation:"
	@echo "  make install          Install WorkFX-AI chart"
	@echo "  make upgrade          Upgrade existing WorkFX-AI release"
	@echo "  make uninstall        Uninstall WorkFX-AI release"
	@echo ""
	@echo "Environment Variables:"
	@echo "  ENVIRONMENT          Environment: dev, staging, prod (default: dev)"
	@echo "  CLOUD_PROVIDER       Cloud provider: gcp, azure, aws, local (default: local)"
	@echo "  NAMESPACE            Kubernetes namespace (default: workfx-ai)"
	@echo "  RELEASE_NAME         Helm release name (default: workfx-ai)"
	@echo "  CHART_PATH           Path to chart (default: ./charts/workfx-ai)"
	@echo ""
	@echo "Quick Deploy Examples:"
	@echo "  make install ENVIRONMENT=dev CLOUD_PROVIDER=gcp"
	@echo "  make install ENVIRONMENT=prod CLOUD_PROVIDER=azure"
	@echo "  make install ENVIRONMENT=staging CLOUD_PROVIDER=aws"
	@echo "  make install ENVIRONMENT=dev CLOUD_PROVIDER=local"
	@echo ""
	@echo "Configuration:"
	@echo "  values.yaml          Main configuration file"
	@echo "  examples/            Example configurations for different environments"
	@echo "  - dev-gcp.yaml       GCP development example"
	@echo "  - prod-azure.yaml    Azure production example"
	@echo "  - dev-local.yaml     Local development example"
	@echo ""
	@echo "For more information, see README.md and QUICKSTART.md"

# Use default values.yaml with environment overrides
VALUES_ARG := -f values.yaml

# Set environment-specific values via --set
ifdef ENVIRONMENT
	ENV_ARG := --set global.environment=$(ENVIRONMENT)
endif

ifdef CLOUD_PROVIDER
	CLOUD_ARG := --set global.cloudProvider=$(CLOUD_PROVIDER)
endif



# Install target
install: ## Install WorkFX-AI chart
	@echo "Installing WorkFX-AI..."
	@echo "  Release: $(RELEASE_NAME)"
	@echo "  Namespace: $(NAMESPACE)"
	@echo "  Environment: $(ENVIRONMENT)"
	@echo "  Cloud Provider: $(CLOUD_PROVIDER)"
	@echo ""
	helm install $(RELEASE_NAME) $(CHART_PATH) \
		--namespace $(NAMESPACE) \
		--create-namespace \
		$(VALUES_ARG) \
		$(ENV_ARG) \
		$(CLOUD_ARG)

# Upgrade target
upgrade: ## Upgrade existing WorkFX-AI release
	@echo "Upgrading WorkFX-AI..."
	@echo "  Release: $(RELEASE_NAME)"
	@echo "  Namespace: $(NAMESPACE)"
	@echo "  Environment: $(ENVIRONMENT)"
	@echo "  Cloud Provider: $(CLOUD_PROVIDER)"
	@echo ""
	helm upgrade $(RELEASE_NAME) $(CHART_PATH) \
		--namespace $(NAMESPACE) \
		$(VALUES_ARG) \
		$(ENV_ARG) \
		$(CLOUD_ARG)

# Uninstall target
uninstall: ## Uninstall WorkFX-AI release
	@echo "Uninstalling WorkFX-AI..."
	@echo "  Release: $(RELEASE_NAME)"
	@echo "  Namespace: $(NAMESPACE)"
	@echo ""
	helm uninstall $(RELEASE_NAME) -n $(NAMESPACE)
	@echo "Release uninstalled. Namespace $(NAMESPACE) may still exist."

# Status target
status: ## Show release status
	@echo "WorkFX-AI Release Status:"
	@echo ""
	helm status $(RELEASE_NAME) -n $(NAMESPACE) || echo "Release not found"

# List target
list: ## List all releases
	@echo "All Helm Releases:"
	@echo ""
	helm list -A

# Pods target
pods: ## Show pods in namespace
	@echo "Pods in namespace $(NAMESPACE):"
	@echo ""
	kubectl get pods -n $(NAMESPACE)

# Services target
services: ## Show services in namespace
	@echo "Services in namespace $(NAMESPACE):"
	@echo ""
	kubectl get services -n $(NAMESPACE)

# Ingress target
ingress: ## Show ingress in namespace
	@echo "Ingress in namespace $(NAMESPACE):"
	@echo ""
	kubectl get ingress -n $(NAMESPACE)

# PVC target
pvc: ## Show persistent volume claims in namespace
	@echo "PVCs in namespace $(NAMESPACE):"
	@echo ""
	kubectl get pvc -n $(NAMESPACE)

# Events target
events: ## Show events in namespace
	@echo "Events in namespace $(NAMESPACE):"
	@echo ""
	kubectl get events -n $(NAMESPACE) --sort-by='.lastTimestamp'

# Logs target
logs: ## Show logs for API service
	@echo "Logs for $(RELEASE_NAME)-api:"
	@echo ""
	kubectl logs -f deployment/$(RELEASE_NAME)-api -n $(NAMESPACE) || \
	kubectl logs -f deployment/$(RELEASE_NAME)-workfx-api -n $(NAMESPACE) || \
	echo "API deployment not found"

# CDC logs target
logs-cdc: ## Show logs for CDC service
	@echo "Logs for $(RELEASE_NAME)-cdc:"
	@echo ""
	kubectl logs -f deployment/$(RELEASE_NAME)-cdc -n $(NAMESPACE) || \
	kubectl logs -f deployment/$(RELEASE_NAME)-workfx-cdc -n $(NAMESPACE) || \
	echo "CDC deployment not found"

# IDB logs target
logs-idb: ## Show logs for IDB service
	@echo "Logs for $(RELEASE_NAME)-idb:"
	@echo ""
	kubectl logs -f deployment/$(RELEASE_NAME)-idb -n $(NAMESPACE) || \
	kubectl logs -f deployment/$(RELEASE_NAME)-workfx-idb -n $(NAMESPACE) || \
	echo "IDB deployment not found"

# Lint target
lint: ## Lint the Helm chart
	@echo "Linting Helm chart..."
	helm lint $(CHART_PATH)

# Template target
template: ## Render chart templates
	@echo "Rendering chart templates..."
	helm template $(RELEASE_NAME) $(CHART_PATH) \
		--namespace $(NAMESPACE) \
		$(VALUES_ARG) \
		--set global.environment=$(ENVIRONMENT) \
		--set global.cloudProvider=$(CLOUD_PROVIDER)

# Dry-run target
dry-run: ## Perform dry-run installation
	@echo "Performing dry-run installation..."
	helm install $(RELEASE_NAME) $(CHART_PATH) \
		--dry-run \
		--debug \
		--namespace $(NAMESPACE) \
		--create-namespace \
		$(VALUES_ARG) \
		$(ENV_ARG) \
		$(CLOUD_ARG)

# Test target
test: ## Run chart tests
	@echo "Running chart tests..."
	helm test $(RELEASE_NAME) -n $(NAMESPACE) || echo "No tests found"

# Clean target
clean: ## Clean up namespace and resources
	@echo "Cleaning up namespace $(NAMESPACE)..."
	kubectl delete namespace $(NAMESPACE) --ignore-not-found=true
	@echo "Cleanup completed"

# Port-forward API target
port-forward-api: ## Port-forward API service to localhost:8000
	@echo "Port-forwarding API service to localhost:8000..."
	kubectl port-forward service/$(RELEASE_NAME)-api 8000:8000 -n $(NAMESPACE) || \
	kubectl port-forward service/$(RELEASE_NAME)-workfx-api 8000:8000 -n $(NAMESPACE) || \
	echo "API service not found"

# Port-forward CDC target
port-forward-cdc: ## Port-forward CDC service to localhost:8001
	@echo "Port-forwarding CDC service to localhost:8001..."
	kubectl port-forward service/$(RELEASE_NAME)-cdc 8001:8000 -n $(NAMESPACE) || \
	kubectl port-forward service/$(RELEASE_NAME)-workfx-cdc 8001:8000 -n $(NAMESPACE) || \
	echo "CDC service not found"

# Port-forward IDB target
port-forward-idb: ## Port-forward IDB service to localhost:8002
	@echo "Port-forwarding IDB service to localhost:8002..."
	kubectl port-forward service/$(RELEASE_NAME)-idb 8002:8000 -n $(NAMESPACE) || \
	kubectl port-forward service/$(RELEASE_NAME)-workfx-idb 8002:8000 -n $(NAMESPACE) || \
	echo "IDB service not found"

# Port-forward dev tools targets
port-forward-akhq: ## Port-forward AKHQ to localhost:8080
	@echo "Port-forwarding AKHQ to localhost:8080..."
	kubectl port-forward service/$(RELEASE_NAME)-akhq 8080:8080 -n $(NAMESPACE) || \
	echo "AKHQ service not found"

port-forward-kibana: ## Port-forward Kibana to localhost:5601
	@echo "Port-forwarding Kibana to localhost:5601..."
	kubectl port-forward service/$(RELEASE_NAME)-kibana 5601:5601 -n $(NAMESPACE) || \
	echo "Kibana service not found"

# Environment-specific targets
install-dev: ## Install development environment
	@$(MAKE) install ENVIRONMENT=dev CLOUD_PROVIDER=local

install-staging: ## Install staging environment
	@$(MAKE) install ENVIRONMENT=staging CLOUD_PROVIDER=gcp

install-prod: ## Install production environment
	@$(MAKE) install ENVIRONMENT=prod CLOUD_PROVIDER=gcp

# Cloud provider-specific targets
install-gcp: ## Install on GCP
	@$(MAKE) install CLOUD_PROVIDER=gcp

install-azure: ## Install on Azure
	@$(MAKE) install CLOUD_PROVIDER=azure

install-aws: ## Install on AWS
	@$(MAKE) install CLOUD_PROVIDER=aws

install-local: ## Install locally
	@$(MAKE) install CLOUD_PROVIDER=local

# Upgrade targets
upgrade-dev: ## Upgrade development environment
	@$(MAKE) upgrade ENVIRONMENT=dev CLOUD_PROVIDER=local

upgrade-staging: ## Upgrade staging environment
	@$(MAKE) upgrade ENVIRONMENT=staging CLOUD_PROVIDER=gcp

upgrade-prod: ## Upgrade production environment
	@$(MAKE) upgrade ENVIRONMENT=prod CLOUD_PROVIDER=gcp

# Info target
info: ## Show deployment information
	@echo "WorkFX-AI Deployment Information:"
	@echo "  Chart Path: $(CHART_PATH)"
	@echo "  Release Name: $(RELEASE_NAME)"
	@echo "  Namespace: $(NAMESPACE)"
	@echo "  Environment: $(ENVIRONMENT)"
	@echo "  Cloud Provider: $(CLOUD_PROVIDER)"
	@echo "  Values Arg: $(VALUES_ARG)"
	@echo ""

# Default target
.DEFAULT_GOAL := help
