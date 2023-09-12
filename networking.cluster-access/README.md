# Lab: Networking - Zugriff von außen ins Cluster

Bereite einige Objekte für dieses Lab vor:

```shell
kubectl create namespace networking
kubectl -n networking run nginx --image nginx
kubectl -n networking run curl --image curlimages/curl --command "sleep" --command "infinity"
```

## port-forward

Starte das Port Forwarding:

```shell
kubectl -n networking port-forward pod/nginx 8080:80
```

Starte das Port Forwarding im Hintergrund:

```shell
kubectl -n networking port-forward pod/nginx 8080:80 &
```

Ansprechen des Pods von lokal über den weitergeleiteten Port:

```shell
curl localhost:8080
```

Port Forwarding wieder beenden:

```shell
ps aux | grep port-forward
kill PROCESS_ID
```

## Ingress Controller

Zuerst brauchen wir einen Ingress Controller (z.B. `ingress-nginx`):

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml
```

Läuft der Controller?

```shell
kubectl -n ingress-nginx get pods
kubectl -n ingress-nginx logs deployment/ingress-nginx-controller
```

## Der erste Ingress

Unseren Pod über einen neuen Service exposen:

```shell
kubectl -n networking expose pod nginx --port 80 --name nginx
```

Eine Ingress Objekt anlegen, das auf den Service verweist:

```shell
kubectl -n networking create ingress nginx --class=nginx --rule="/=nginx:80"
```

Wie sieht das Objekt dazu aus?

```shell
kubectl -n networking get ingress nginx -o yaml
```

HTTP `NodePort` des Ingress Controller Services bestimmen:

```shell
export NODE_PORT_HTTP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
```

Ansprechen über NodePort des Ingress Controller Services:

```shell
curl http://nodea:${NODE_PORT_HTTP}/
curl http://nodeb:${NODE_PORT_HTTP}/
curl http://controlplane:${NODE_PORT_HTTP}/
```

Was sagt der Controller dazu:

```shell
kubectl -n ingress-nginx logs deployment/ingress-nginx-controller
```

## Pfade

Editiere das Ingress Objekt und ändere den Pfad zu `/hello-nginx`

```shell
kubectl -n networking get ingress nginx -o yaml
```

Ansprechen:

```shell
curl http://nodea:${NODE_PORT_HTTP}/hello-nginx
```

404? Wieso?

```shell
kubectl -n networking annotate ingress nginx nginx.ingress.kubernetes.io/rewrite-target='/'
```

## Cleanup

Lösche die für das Lab angelegten Namespaces:

```shell
kubectl delete namespace networking
kubectl delete namespace ingress-nginx
```
