# Lab: Networking - DNS & Service Discovery

Bereite einige Objekte für dieses Lab vor:

```shell
kubectl create namespace dns-service
kubectl -n dns-service run nginx --image nginx
kubectl -n dns-service run curl --image curlimages/curl --command "sleep" --command "infinity"
```

# Pod IP

Finde die IP Adresse eines Pods heraus:

```shell
kubectl -n dns-service get pod nginx -o jsonpath='{.status.podIP}'
```

Ansprechen eines Pods aus einem anderen Pod heraus:

```shell
kubectl -n dns-service exec curl -- curl 192.168.x.x
```

oder

```shell
kubectl -n dns-service exec curl -- curl $(kubectl -n dns-service get pod nginx -o jsonpath='{.status.podIP}')
```

# Pod DNS

Pod via Cluster-interne Domain ansprechen:

```shell
kubectl -n dns-service exec curl -- curl 192-168-x-x.dns-service.pod.cluster.local
```

# Service / Pod exposen

Einen Pod via Service exposen:

```shell
kubectl -n dns-service expose pod nginx --port 80 --name nginx
```

Pod via Service Domain ansprechen:

```shell
kubectl -n dns-service exec curl -- curl nginx.dns-service.svc.cluster.local
```

Wie sieht der Service aus?

```shell
kubectl -n dns-service get service nginx -o yaml
```

## Weiterführende Aufgaben

- Nutze einen Pod im Cluster um die Kubernetes API über den `kubernetes` Service im `default` Namespace aufzurufen
    - *Info*: Kubernetes nutzt ein self-signed Zertifikat
    - *Tipp*: Zertifikatsfehler können bei `curl` (für diesen Test) mit dem Flag `--insecure` ignoriert werden
- Starte einen Pod mit dem `alpine` Image, installiere das `bind-tools` Package nach und setze via `host` eine DNS-Abfrage an den cluster-internen DNS-Service `kube-dns` im `kube-system` Namespace ab.

## Cleanup

Lösche den für das Lab angelegten Namespace:

```shell
kubectl delete namespace dns-service
```
