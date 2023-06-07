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
kubectl -n networking exec curl -- curl 192.x.x.x
```
oder 
```shell
kubectl -n networking exec curl -- curl $(kubectl -n networking get pod nginx -o jsonpath='{.status.podIP}')
```

# Pod DNS
Pod via DNS Namen ansprechen:
```shell
kubectl -n networking exec curl -- curl 192-168-248-130.networking.pod.cluster.local
```

# Service / Expose a Pod
Einen Pod via Service Exposen:
```shell
kubectl -n networking expose pod nginx --port 80 --name nginx
```
Pod via Service DNS Namen ansprechen:
```shell
kubectl -n networking exec curl -- curl nginx.networking.svc.cluster.local
```
Wie sieht der Service aus?
```shell
kubectl -n networking get service nginx -o yaml
```

## Cleanup:
```shell
kubectl delete namespace networking
```