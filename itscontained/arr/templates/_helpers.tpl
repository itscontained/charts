{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "arr.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "arr.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "arr.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "arr.labels" -}}
helm.sh/chart: {{ include "arr.chart" . }}
{{ include "arr.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "arr.selectorLabels" -}}
app.kubernetes.io/name: {{ include "arr.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Port Selector
*/}}
{{- define "arr.portSelector" -}}
  {{- if .Values.service.port -}}
    {{- .Values.service.port -}}
  {{- else if eq .Values.image.repository "radarr" -}}
7878
  {{- else if eq .Values.image.repository "sonarr" -}}
8989
  {{- else if eq .Values.image.repository "lidarr" -}}
8686
  {{- else -}}
    {{- fail "Could not establish the service port from the repository and no service port was set" -}}
  {{- end -}}
{{- end -}}

{{/*
Config Path Selector
*/}}
{{- define "arr.configPathSelector" -}}
  {{- if eq .Values.image.organization "itscontained" -}}
    {{- if eq .Values.image.repository "radarr" -}}
/var/lib/radarr
    {{- else if eq .Values.image.repository "sonarr" -}}
/var/lib/sonarr
    {{- else if eq .Values.image.repository "lidarr" -}}
      {{- fail "lidarr not yet implemented" -}}
    {{- else -}}
      {{- fail "Could not establish the service port from the repository and no service port was set" -}}
    {{- end -}}
  {{- else -}}
/config
  {{- end -}}
{{- end -}}