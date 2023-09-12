# Lab: Networking - DNS & Service Discovery

Bereite einige Objekte für dieses Lab vor:

```shell
kubectl create namespace networking
kubectl -n networking run nginx --image nginx
kubectl -n networking run curl --image curlimages/curl --command "sleep" --command "infinity"
```

# Pod IP

Finde die IP Adresse eines Pods heraus:

```shell
kubectl -n networking get pod nginx -o jsonpath='{.status.podIP}'
```

Ansprechen eines Pods aus einem anderen Pod heraus:

```shell
kubectl -n networking exec curl -- curl 192.168.x.x
```

oder

```shell
kubectl -n networking exec curl -- curl $(kubectl -n networking get pod nginx -o jsonpath='{.status.podIP}')
```

# Pod DNS

Pod via Cluster-interne Domain ansprechen:

```shell
kubectl -n networking exec curl -- curl 192-168-x-x.networking.pod.cluster.local
```

# Service / Pod exposen

Einen Pod via Service exposen:

```shell
kubectl -n networking expose pod nginx --port 80 --name nginx
```

Pod via Service Domain ansprechen:

```shell
kubectl -n networking exec curl -- curl nginx.networking.svc.cluster.local
```

Wie sieht der Service aus?

```shell
kubectl -n networking get service nginx -o yaml
```

## Cleanup

Lösche den für das Lab angelegten Namespace:

```shell
kubectl delete namespace networking
```
