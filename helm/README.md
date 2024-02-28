# Lab: Helm

<!-- BEGIN mktoc -->

- [Was ist Helm?](#was-ist-helm)
- [Vorbereitung](#vorbereitung)
  - [Helm installieren](#helm-installieren)
  - [Repository clonen](#repository-clonen)
  - [Ins richtige Verzeichnis gehen](#ins-richtige-verzeichnis-gehen)
- [Aufgaben](#aufgaben)
  - [Änderungen testen](#Änderungen-testen)
  - [Füge ein neues Standard Label hinzu](#füge-ein-neues-standard-label-hinzu)
  - [Komplexe Daten übergeben](#komplexe-daten-übergeben)
- [Weiterführende Aufgaben](#weiterführende-aufgaben)
<!-- END mktoc -->

## Was ist Helm?

Helm ist ein _Package Manager für Kubernetes_, der sich aus einer Library und einer CLI zusammensetzt und das komfortable bereitstellen und installieren von gekapselten Paketen in Kubernetes ermöglicht. Weitere Informationen sind auf [helm.sh/](https://helm.sh/) zu finden.

## Vorbereitung

Alle Vorbereitungen werden auf dem Server gemacht!

### Helm installieren

Helm ist noch nicht installiert, kann aber mit `snap` nachinstalliert werden.

Verbinde dich per SSH auf den Server und gib folgendes ein:

```sh
sudo snap install helm --classic
```

anschließend kann mit `helm version` verifiziert werden, dass Helm installiert wurde.

### Repository clonen

Für dieses Lab brauchen wir die Dateien aus dem Repo, diese können mit `git` einfach gecloned werden:

Gehe dazu ins Home Verzeichnis (`$HOME`) und clone das Repo.

```sh
cd $HOME
git clone https://github.com/AOEpeople/academy-kubernetes-101.git
```

### Ins richtige Verzeichnis gehen

Von nun an müssen alle Helm Befehle im Verzeichnis `$HOME/academy-kubernetes-101/helm` ausgeführt werden. Wechsel dazu mit dem Terminal in dieses Verzeichnis:

```sh
cd $HOME/academy-kubernetes-101/helm
```

Und fertig! Jetzt geht der Spaß los! :) 

## Aufgaben

### Änderungen testen

Zum testen können die Helm Charts mit dem Befehl `helm template ./simple-chart` gebaut werden.

Ein Third-Party Tool namens [helm-unittest](https://github.com/helm-unittest/helm-unittest) erlaubt auch ein Unit Test basiertes testen von Helm Charts, außerdem gibt es die Helm `test` hook welche allerdings benutzt wird um Ressourcen im Cluster zu testen (siehe [Helm Docs](https://helm.sh/docs/topics/chart_tests/)) - dies überschreitet den Scope des Labs.

Führe `helm template ./simple-chart` aus um die gerenderte YAML Datei zu sehen.

### Füge ein neues Standard Label hinzu

An jede Ressource soll ein neues zusätzliches Label angefügt werden: `k8s.aoe.com/cluster`, der Wert hierführ soll aus der values.yaml geladen werden.

<details>
<summary>Tipp 1</summary>
Um allen Ressourcen das Label zuzuweisen sollte es zu den <code>"self.common-labels"</code> in <code>_helpers.tpl</code> hinzugefügt werden.
</details>


<details>
<summary>Tipp 2</summary>
Werte aus der <code>values.yaml</code> Datei können in allen template Dateien mit <code>{{ .Values.keyword }}</code> geladen werden. <code>keyword</code> ist dabei der Wert wie er in der YAML Datei hinterlegt wurde. Beispiel:
<pre><code>
# in values.yaml
replicas: 3
# dann z.B. in templates/deployment.yaml
spec:
  replicas: {{ .Values.replicas }}
</code></pre>
</details>


<details>
<summary>Lösung</summary>
<pre><code>
# In values.yaml
cluster: "academy-101"
</code></pre>

<pre><code>
# In _helpers.tpl "self.common-labels"
k8s.aoe.com/cluster: {{ .Values.cluster }}
</code></pre>
</details>

### Komplexe Daten übergeben

Gerade mit ConfigMaps wollen wir manchmal komplexere Daten übergeben. YAML bietet hierfür einige Möglichkeiten: Multi-line Strings z.B.

Füge ein neuen Wert `appProperties` in die `values.yaml` hinzu sodass ein Nutzer die unten stehende `app.properties` übergeben kann.

app.properties:
```
server.port=8081
server.tls.enable=false
sprint.application.name=my-awesome-app
rewrite.in.rust="maybe? :-)"
```

<details>
<summary>Tipp 1</summary>
Der Wert kann z.B. als Multi-line Text in der <code>values.yaml</code> übergeben werden:
<pre><code>
appProperties: |
server.port=8081
server.tls.enable=false
sprint.application.name=my-awesome-app
rewrite.in.rust="maybe? :-)"
</code></pre>

anschließend kann in der <code>configMap.yaml</code> der Wert aus values.yaml inkludiert werden:

<pre><code>
# configMap.yaml
data:
  app.properties: |
{{ appProperties }}
</code></pre>
</details>

<details>
<summary>Tipp 2</summary>
Bei der Einrückung kommt es zu Problemen. Mit der <code>nindent</code> Funktion kann Text eingerückt werden. <code>{{ myVar | nindent 6 }}</code> rückt den Text um 6 Leerzeichen ein.
</details>


<details>
<summary>Tipp 3</summary>
Mit <code>{{ with .Values.appProperties }}</code> wird der YAML Block nur gerendet wenn <code>appProperties</code> gesetzt ist.
<pre><code>
# in configMap.yaml
data:
  {{- with .Values.appProperties }}
  app.properties: |
    {{- . | nindent 4 }}
  {{- end }}
</code></pre>
</details>


<details>
<summary>Lösung</summary>
values.yaml
<pre><code>
# ...
appProperties: |
  server.port=8081
  server.tls.enable=false
  sprint.application.name=my-awesome-app
  rewrite.in.rust="maybe? :-)"
</code></pre>

configMap.yaml:
<pre><code>
# ...
data:
  hello: "World"
  {{- with .Values.appProperties }}
  app.properties: |
    {{- . | nindent 4 }}
  {{ end }}
</code></pre>
<pre><code>
# In _helpers.tpl "self.common-labels"
k8s.aoe.com/cluster: {{ .Values.cluster }}
</code></pre>
</details>

## Weiterführende Aufgaben

Verändere die Templates, sodass...

1. ... ein anderes Docker image konfigurierbar ist. Der Default Wert sollte `nginx:1.14.2` bleiben
2. ... verschiedene Ports gesetzt werden können (im Moment wird nur Port 80 exposed)