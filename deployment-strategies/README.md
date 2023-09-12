# Lab: Deployment Strategien

## Vorbereitung

Erstelle einen Namespace und installiere den `ingress-nginx` Ingress Controller.

```shell
kubectl create namespace deployment-strategies

# Falls nicht mehr installiert:
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

Aktualisiere das Deployment durch den Austausch des genutzten Images und prüfe dabei die Ausgabe des vorherigen Befehls:

```shell
kubectl -n deployment-strategies set image deployment/deployment-strategies-rolling deployment-strategies-rolling=gcr.io/kuar-demo/kuard-amd64:green
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

**Aufgabe**: Nutze die Canary-Annotations von `ingress-nginx` um ein Canary Deployment von `blue` auf `green` zu simulieren (siehe [ingress-nginx Canary Deployment Dokumentation](https://kubernetes.github.io/ingress-nginx/examples/canary/#create-ingress-pointing-to-your-canary-deployment))

Lösche die erstellten Ressourcen:

```shell
kubectl -n deployment-strategies delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/canary.yml
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

**Aufgabe**: Switche den Ingress von `blue` auf `green` und simuliere damit ein Blue-Green Deployment.

Lösche die erstellten Ressourcen:

```shell
kubectl -n deployment-strategies delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/blue-green.yml
```

## Cleanup

Lösche den für das Lab angelegten Namespace:

```shell
kubectl delete namespace deployment-strategies
```
