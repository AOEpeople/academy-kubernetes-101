# Generische Helferfunktionen, die in den templates verwendet werden können.
# 
# Funktionen werden als Go Template Blöcke definiert 
# Der Block Name kann dabei  frei gewählt werden - hier z.B. "self.common-labels",
# aber auch "generic-microservice.common-labels" oder nur "commonlabels" sind 
# möglich.
{{- define "self.common-labels" -}}
ctx.customer.de/service-name: {{ .Values.servicename }}
ctx.customer.de/version: {{ .Values.version }}
{{- end -}}
# ^- im self.commonLabels Block definieren wir zwei Labels:
# `ctx.customer.de/service-name` und `ctx.customer.de/version`
# diese Labels können wir dann an alle Ressourcen anhängen indem
# wir das Template inkludieren (siehe z.B. configMap.yaml)

# Name des (Micro-)Services
{{- define "self.name" -}}
{{ .Values.servicename }}
{{- end -}}

# match-selector labels zum selektieren der Pods die zum Deployment gehören usw.
{{- define "self.match-selector" -}}
app: {{ include "self.name" . }}
app.kubernetes.io/name: {{ include "self.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}