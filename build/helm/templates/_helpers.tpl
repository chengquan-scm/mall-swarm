{{/*
Expand the name of the chart.
*/}}
{{- define "mall.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "mall.fullname" -}}
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
{{- define "mall.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mall.labels" -}}
helm.sh/chart: {{ include "mall.chart" . }}
{{ include "mall.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mall.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mall.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Service labels for specific app
*/}}
{{- define "mall.serviceLabels" -}}
app: {{ .appName }}
version: {{ .version }}
{{- end }}

{{/*
Pod labels for specific app
*/}}
{{- define "mall.podLabels" -}}
app: {{ .appName }}
version: {{ .version }}
component: {{ .component }}
team: {{ .team }}
{{- end }}

{{/*
Pod annotations for monitoring
*/}}
{{- define "mall.podAnnotations" -}}
prometheus.io/scrape: "{{ .monitoring.prometheus.scrape }}"
prometheus.io/port: "{{ .port }}"
prometheus.io/path: "{{ .monitoring.prometheus.path }}"
prometheus.io/scheme: "{{ .monitoring.prometheus.scheme }}"
prometheus.io/interval: "{{ .monitoring.prometheus.interval }}"
business.domain: "{{ .businessDomain }}"
alert.severity: "{{ .alertSeverity }}"
{{- end }}

{{/*
Image name for specific service
*/}}
{{- define "mall.image" -}}
{{- $registry := .root.Values.image.registry -}}
{{- $project := .root.Values.image.project -}}
{{- $service := .service -}}
{{- $version := .version -}}
{{- printf "%s/%s/mall-%s:%s" $registry $project $service $version -}}
{{- end }}

{{/*
Security context for container
*/}}
{{- define "mall.containerSecurityContext" -}}
allowPrivilegeEscalation: false
readOnlyRootFilesystem: true
runAsNonRoot: true
runAsUser: {{ .securityContext.runAsUser }}
runAsGroup: {{ .securityContext.runAsGroup }}
capabilities:
  drop:
    - ALL
seccompProfile:
  type: RuntimeDefault
{{- end }}

{{/*
Pod security context
*/}}
{{- define "mall.podSecurityContext" -}}
runAsNonRoot: true
runAsUser: {{ .securityContext.runAsUser }}
runAsGroup: {{ .securityContext.runAsGroup }}
seccompProfile:
  type: RuntimeDefault
{{- end }}

{{/*
Volume mounts
*/}}
{{- define "mall.volumeMounts" -}}
- name: config-volume
  mountPath: /app/config/application.yaml
  subPath: application.yaml
{{- if .root.Values.volumes.tmpVolume }}
- name: tmp-volume
  mountPath: /tmp
{{- end }}
{{- end }}

{{/*
Volumes
*/}}
{{- define "mall.volumes" -}}
- name: config-volume
  configMap:
    name: {{ .appName }}-config
    items:
      - key: application.yaml
        path: application.yaml
{{- if .root.Values.volumes.tmpVolume }}
- name: tmp-volume
  emptyDir: {}
{{- end }}
{{- end }}

{{/*
Environment variables
*/}}
{{- define "mall.env" -}}
- name: TZ
  value: {{ .root.Values.global.timezone }}
{{- range $key, $value := .env }}
- name: {{ $key }}
  value: {{ $value | quote }}
{{- end }}
{{- end }}

{{/*
Probe configuration
*/}}
{{- define "mall.probe" -}}
httpGet:
  path: {{ .path }}
  port: {{ .port }}
initialDelaySeconds: {{ .initialDelaySeconds }}
periodSeconds: {{ .periodSeconds }}
timeoutSeconds: {{ .timeoutSeconds }}
failureThreshold: {{ .failureThreshold }}
{{- end }}

{{/*
Affinity configuration
*/}}
{{- define "mall.affinity" -}}
{{- if .root.Values.affinity.enabled }}
podAntiAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
  - weight: 100
    podAffinityTerm:
      labelSelector:
        matchExpressions:
        - key: app
          operator: In
          values:
          - {{ .appName }}
      topologyKey: {{ .root.Values.affinity.topologyKey }}
{{- end }}
{{- end }}