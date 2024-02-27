# Lab: Deployment Strategien

## Vorbereitung

Erstelle einen Namespace und installiere den `ingress-nginx` Ingress Controller.

```shell
kubectl create namespace deployment-strategies
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml
```

Bestimme und exportiere den HTTP `NodePort` des Ingress Controller Services als Umgebungsvariable im Terminal:

```shell
export NODE_PORT_HTTP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
```

## Rolling Updates

Erstelle ein Deployment mit `RollingUpdate` Strategie:

```shell
kubectl -n deployment-strategies apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/rolling.yml
```

Lasse dir (am besten in einem neuen Terminal) die Pods im neu angelegten Namespace kontinuierlich anzeigen:

```shell
kubectl -n deployment-strategies get pods --watch
```

Alternativ kann man sich auch die Pods via `watch` anzeigen lassen:

```shell
watch -n 1 kubectl -n deployment-strategies get pods
```

Aktualisiere das Deployment durch den Austausch des genutzten Images und prüfe dabei die Ausgabe des vorherigen Befehls:

```shell
kubectl -n deployment-strategies set image deployment/deployment-strategies-rolling deployment-strategies-rolling=gcr.io/kuar-demo/kuard-amd64:green
```

Starte manuell ein neues Rollout, bei dem für das Deployment erst neue Pods hochgefahren und danach die alten Pods terminiert werden: 

```shell
kubectl rollout restart -n deployment-strategies deployment deployment-strategies-rolling
```

Lösche das Deployment:

```shell
kubectl -n deployment-strategies delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/rolling.yml
```

## Canary Deployments

Erstelle Ressourcen, die für das Canary-Deployment benötigt werden:

```shell
kubectl -n deployment-strategies apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/canary.yml
```

Prüfe die angelegten Ressourcen:

```shell
kubectl -n deployment-strategies get ingresses
kubectl -n deployment-strategies get services
kubectl -n deployment-strategies get deployments
```

Greife über den Ingress auf den Service zu:

```shell
curl -H "Host: deployment-strategies-canary.local" http://nodea:${NODE_PORT_HTTP}/
```

Erstelle einen `ingress-nginx` Canary Ingress um ein Canary Deployment von `blue` auf `green` zu simulieren:

```shell
kubectl -n deployment-strategies apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/canary-canary-ingress.yml
```

Prüfe, dass 50% der Anfragen an den `green`-Service gehen (siehe `version` im ersten Script-Tag):

```shell
curl -H "Host: deployment-strategies-canary.local" http://nodea:${NODE_PORT_HTTP}/
```

Lösche die erstellten Ressourcen:

```shell
kubectl -n deployment-strategies delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/canary.yml
kubectl -n deployment-strategies delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/canary-canary-ingress.yml
```

## Blue-Green Deployments

Erstelle Ressourcen, die für das Blue-Green-Deployment benötigt werden:

```shell
kubectl -n deployment-strategies apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/blue-green.yml
```

Prüfe die angelegten Ressourcen:

```shell
kubectl -n deployment-strategies get ingresses
kubectl -n deployment-strategies get services
kubectl -n deployment-strategies get deployments
```

```shell
curl -H "Host: deployment-strategies-bg.local" http://nodea:${NODE_PORT_HTTP}/
```

**Aufgabe**: Switche den Ingress von `blue` auf `green`, simuliere damit ein Blue-Green Deployment und prüfe das Verhalten des Endpunkts:

```shell
kubectl -n deployment-strategies edit ingress deployment-strategies-bg
```

Lösche die erstellten Ressourcen:

```shell
kubectl -n deployment-strategies delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/blue-green.yml
```

## Weiterführende Aufgaben

### RollingUpdate

- Rollback
    - Erstelle ein Deployment mit der `RollingUpdate` Strategie, dem Image `docker.io/nginx` und zwei Replicas
    - Ändere das Image auf das nicht existierende Image `docker.io/enginex` und prüfe was passiert
    - Rolle das Deployment via `kubectl rollout` zurück auf die vorherige Version
- Fine-Tuning
    - Erstelle ein Deployment mit der `RollingUpdate` Strategie, dem Image `docker.io/nginx` und 5 Replicas
    - Teste welche Auswirkungen die Konfigurationsoptionen `maxSurge` und `maxUnavailable` auf das Rolling Update haben

## Cleanup

Lösche die für das Lab angelegten Namespaces:

```shell
kubectl delete namespace deployment-strategies
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml
```
