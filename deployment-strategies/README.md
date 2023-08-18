# Lab: Deployment Strategien

Bereite einige Objekte für dieses Lab vor:

```shell
kubectl create namespace deployment-strategies

# Falls nicht mehr installiert:
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml
kubectl -n ingress-nginx get service ingress-nginx-controller # node port herausfinden
```

## Rolling

```shell
kubectl -n deployment-strategies apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/rolling.yml
```

```shell
kubectl -n deployment-strategies get pods --watch
# am besten in zweitem Terminal
```

neue version

```shell
kubectl -n deployment-strategies set image deployment/deployment-strategies-rolling deployment-strategies-rolling=gcr.io/kuar-demo/kuard-amd64:green
```

```shell
kubectl -n deployment-strategies delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/rolling.yml
```

## Canary

```shell
kubectl -n deployment-strategies apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/canary.yml
```

```shell
kubectl -n deployment-strategies get ingresses
kubectl -n deployment-strategies get services
kubectl -n deployment-strategies get deployments
```

```shell
curl -H "Host: deployment-strategies-canary.local" http://nodea:30616/
```

**Aufgabe: Nutze NGINX Ingress Controller´s Canary Routing Feature um ein Canary Deploymentvon `blue` auf `green` zu simulieren :)**

```shell
kubectl -n deployment-strategies delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/canary.yml
```

## Blue-Green

```shell
kubectl -n deployment-strategies apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/blue-green.yml
```

```shell
kubectl -n deployment-strategies get ingresses
kubectl -n deployment-strategies get services
kubectl -n deployment-strategies get deployments
```

```shell
curl -H "Host: deployment-strategies-bg.local" http://nodea:30616/
```

**Aufgabe: Switche den Ingress von  `blue` auf `green` und simuliere damit ein Blue-Green Deployment :)**

```shell
kubectl -n deployment-strategies delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/deployment-strategies/blue-green.yml
```

## Cleanup

```shell
kubectl delete namespace deployment-strategies
```