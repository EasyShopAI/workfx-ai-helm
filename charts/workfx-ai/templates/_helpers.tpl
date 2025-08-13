{{/*
Expand the name of the chart.
*/}}
{{- define "workfx-ai.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "workfx-ai.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "workfx-ai.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "workfx-ai.labels" -}}
helm.sh/chart: {{ include "workfx-ai.chart" . }}
{{ include "workfx-ai.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "workfx-ai.selectorLabels" -}}
app.kubernetes.io/name: {{ include "workfx-ai.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "workfx-ai.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "workfx-ai.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the secret to use
*/}}
{{- define "workfx-ai.secretName" -}}
{{- if .Values.secrets.existingSecret }}
{{- .Values.secrets.existingSecret }}
{{- else }}
{{- include "workfx-ai.fullname" . }}-secret
{{- end }}
{{- end }}

{{/*
Generate database URL based on configuration
*/}}
{{- define "workfx-ai.databaseUrl" -}}
{{- if .Values.database.external }}
{{- .Values.database.url }}
{{- else }}
{{- printf "postgresql://%s:%s@%s:%d/%s" .Values.database.user .Values.secrets.values.dbPassword .Values.database.host (.Values.database.port | int) .Values.database.name }}
{{- end }}
{{- end }}

{{/*
Generate Redis URL based on configuration
*/}}
{{- define "workfx-ai.redisUrl" -}}
{{- if .Values.redis.external }}
{{- .Values.redis.url }}
{{- else }}
{{- printf "redis://:%s@%s:%d/0" .Values.secrets.values.redisPassword .Values.redis.host (.Values.redis.port | int) }}
{{- end }}
{{- end }}

{{/*
Get image registry
*/}}
{{- define "workfx-ai.imageRegistry" -}}
{{- .Values.global.imageRegistry | default "docker.io" }}
{{- end }}

{{/*
Generate full image name
*/}}
{{- define "workfx-ai.image" -}}
{{- printf "%s/%s:%s" (include "workfx-ai.imageRegistry" .) .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) }}
{{- end }}

{{/*
Generate environment-specific labels
*/}}
{{- define "workfx-ai.environmentLabels" -}}
environment: {{ .Values.config.environment }}
tier: application
component: workfx-ai
{{- end }}
