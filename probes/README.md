# Lab: Probes

## Vorbereitung

Erstelle einen neuen Namespace für dieses Lab:

```shell
kubectl create namespace probes
```

Erstelle das Deployment `curl` im `probes` Namespace um damit im Laufe des Labs die Erreichbarkeit von Services im Cluster zu prüfen:

```shell
kubectl -n probes create deployment --image curlimages/curl curl -- sleep infinity
```

*Tipp*: Mit dem folgenden Befehl kann die Erreichbarkeit eines Services im `probes` Namespace geprüft werden:

```shell
kubectl -n probes exec deployment/curl -- curl service-name.probes.svc.cluster.local
```

*Tipp*: Siehe die [Kubernetes Dokumentation](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/) zur Konfiguration von Probes.

## Readiness Probes

- Erstelle das `readiness` Deployment, den `readiness` Service und das `readiness-checker` Deployment, das jede Sekunde versucht den `readiness` Service aufzurufen:

```shell
kubectl apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/probes/readiness.yaml
```

- *Tipp*: in den Logs des `readiness-checker` Deployments werden die HTTP Status-Codes beim Zugriff auf den `readiness` Service geloggt.

- Prüfe manuell (via `exec` im `curl` Deployment) oder automatisiert (über die Logs des `readiness-checker` Deployments) die Erreichbarkeit des `readiness` Services im `probes` Namespace.

- Starte das `readiness` Deployment mit folgendem Befehl neu:

```sh
kubectl -n probes rollout restart deployment readiness
```

- Prüfe erneut die Erreichbarkeit des `readiness` Services. Was für ein Problem tritt auf?

<details>
<summary>Lösung</summary>

Der Service ist zwischenzeitlich nicht erreichbar, da der neue Pod des `readiness` Deployments direkt beim Start `ready` wird.
Dadurch wird der alte Pod terminiert wird, obwohl der `nginx` Server im neuen Pod noch nicht läuft.
</details>

- Passe das `readiness` Deployment an (ohne das `command` Attribut zu verändern) und stelle sicher, dass der Pod erst dann `ready` wird, wenn `nginx` im Pod bereit ist um Anfragen entgegenzunehmen.

<details>
<summary>Tipp</summary>

Es müssen Readiness Probes für das Deployment konfiguriert werden, die auf Port `80` den Root-Pfad `/` prüfen.
</details>

<details>
<summary>Lösung</summary>

Die folgende Konfiguration der Readiness Probes erzielt das gewünschte Ergebnis:

```yaml
spec:
  [...]
  template:
    [...]
    spec:
      [...]
      containers:
        - image: nginx
          [...]
          readinessProbe:
            httpGet:
              path: /
              port: 80
            periodSeconds: 10
            failureThreshold: 3
```
</details>

- Starte das `readiness` Deployment neu und prüfe, dass der Service während des Neustarts ohne Downtime erreichbar ist.

## Liveness Probes

- Erstelle das `liveness` Deployment und den `liveness` Service:

```shell
kubectl apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/probes/liveness.yaml
```

- Prüfe die Erreichbarkeit des `liveness` Services wenn der Pod mindestens 30 Sekunden gelaufen ist. Was fällt auf?

<details>
<summary>Lösung</summary>

Der Service ist nach 30 Sekunden nicht mehr erreichbar, da 25 Sekunden nach dem Start des Pods der `nginx` Server terminiert wird um eine Exception in der Applikation zu simulieren.
Der Pod läuft aber immer weiter und terminiert nicht automatisch.
</details>

- Passe das `liveness` Deployment an (ohne das `command` Attribut zu verändern) und stelle sicher, dass der Pod automatisch neu gestartet wird, falls der `nginx`-Server über 3 Intervalle von je 10 Sekunden nicht mehr auf Anfragen geantwortet hat.

<details>
<summary>Tipp</summary>

Es müssen Liveness Probes für das Deployment konfiguriert werden, die auf Port `80` den Root-Pfad `/` prüfen.
</details>

<details>
<summary>Lösung</summary>

Die folgende Konfiguration der Liveness Probes erzielt das gewünschte Ergebnis:

```yaml
spec:
  [...]
  template:
    [...]
    spec:
      [...]
      containers:
        - image: nginx
          [...]
          livenessProbe:
            httpGet:
              path: /
              port: 80
            periodSeconds: 10
            failureThreshold: 3
```
</details>

## Startup Probes

- Erstelle das `startup` Deployment und den `startup` Service:

```shell
kubectl apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/probes/startup.yaml
```

- Prüfe warum der `startup` Service nicht erreichbar ist.

<details>
<summary>Lösung</summary>

Die Pods des Deployments starten immer wieder neu, da der `nginx` Server zu langsam startet und die Liveness Probes deswegen zu oft scheitern:

```
Container startup failed liveness probe, will be restarted
```
</details>

- Passe das `startup` Deployment an (ohne das `command` Attribut oder die bestenden Probes zu verändern) und stelle sicher, dass der Pod erfolgreich `live` und `ready` wird und nicht mehr kontinuierlich neu startet.

<details>
<summary>Tipp 1</summary>

Es müssen Startup Probes für das Deployment konfiguriert werden, die auf Port `80` den Root-Pfad `/` prüfen.
</details>

<details>
<summary>Tipp 2</summary>

Der `failureThreshold` der Startup Probes muss ausreichend hoch gesetzt sein, dass auch langsamere Starts erfolgreich über die Startup Phase hinauskommen.
</details>

<details>
<summary>Lösung</summary>

Die folgende Konfiguration der Startup Probes erzielt das gewünschte Ergebnis:

```yaml
spec:
  [...]
  template:
    [...]
    spec:
      [...]
      containers:
        - image: nginx
          [...]
          startupProbe:
            httpGet:
              path: /
              port: 80
            periodSeconds: 10
            failureThreshold: 10
```
</details>

## Cleanup

Lösche den für das Lab angelegten Namespace:

```shell
kubectl delete namespace probes
```
