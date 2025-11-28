{{- define "mongodb.name" -}}
{{- .Chart.Name -}}
{{- end }}

{{- define "mongodb.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}
