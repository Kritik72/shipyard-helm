{{/* Chart name */}}
{{- define "shipyard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Full resource name, based on the release name */}}
{{- define "shipyard.fullname" -}}
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

{{/* Chart label value */}}
{{- define "shipyard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Labels used to select pods (must never change between releases) */}}
{{- define "shipyard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "shipyard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Common labels for all resources */}}
{{- define "shipyard.labels" -}}
helm.sh/chart: {{ include "shipyard.chart" . }}
{{ include "shipyard.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: shipyard
environment: {{ .Values.appEnv | quote }}
{{- end }}

{{/* Service account name */}}
{{- define "shipyard.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "shipyard.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Full image reference; fails the deploy if no tag is given */}}
{{- define "shipyard.image" -}}
{{- $tag := required "image.tag is required, e.g. --set image.tag=sha-abc1234" .Values.image.tag -}}
{{- printf "%s:%s" .Values.image.repository $tag }}
{{- end }}
