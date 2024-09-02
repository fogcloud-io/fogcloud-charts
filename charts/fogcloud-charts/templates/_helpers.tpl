{{/* Helm required labels */}}
{{- define "fogcloud.labels" -}}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
chart: {{ .Chart.Name }}
{{- end -}}

{{- /*
fog.config.merge
input: map with 2 keys:
- name: configmap name
- defaultConfig: config value
- env: config env
- newConfig: new config to override
output: YAML list of reloader config files
*/}}
{{- define "fog.config.merge" -}}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ .name }}-config
data:
  config.yaml: |-
{{- $rawConfig := .defaultConfig }}
{{- $myConfig := dict "defaults" "" }}
{{- range tuple "defaults" "development" "beta" "test" "production" }}
  {{- if hasKey $rawConfig . }}
    {{- $myConfig = set $myConfig . (get $rawConfig .) }}
  {{- end }}
{{- end }}
{{ mergeOverwrite $myConfig (dict .env .newConfig) | toYaml | indent 4 }}
{{- end -}}
