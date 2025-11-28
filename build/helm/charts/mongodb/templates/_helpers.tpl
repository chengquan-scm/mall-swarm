{{/*
生成应用名称
*/}}
{{- define "mongodb-mall.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
生成 Chart 标签
*/}}
{{- define "mongodb-mall.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
生成选择器标签
*/}}
{{- define "mongodb-mall.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mongodb-mall.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
生成标准标签
*/}}
{{- define "mongodb-mall.labels" -}}
helm.sh/chart: {{ include "mongodb-mall.chart" . }}
{{ include "mongodb-mall.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}