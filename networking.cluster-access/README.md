# Lab: Networking - Zugriff von außen ins Cluster

Bereite einige Objekte für dieses Lab vor:
```shell
kubectl create namespace networking
kubectl -n networking run nginx --image nginx
kubectl -n networking run curl --image curlimages/curl --command "sleep" --command "infinity"
```

## port-forward

Starte das forwarding:
```shell
kubectl -n networking port-forward pod/nginx 8080:80
```

Starte das forwarding im Hintergrund:
```shell
kubectl -n networking port-forward pod/nginx 8080:80 &
```

Ansprechen des Pods von lokal:
```shell
curl localhost:8080
```

Forwarding wieder beenden:
```shell
ps aux | grep port-forward
kill PROCESS_ID
```

## Ingress Controller

Zuerst brauchen wir einen Ingress Controller:
```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/baremetal/deploy.yaml
```
Läuft der Controller?
```shell
kubectl -n ingress-nginx get pods
kubectl -n ingress-nginx logs deployment/ingress-nginx-controller
```

## Der erste Ingress
Unseren Pod Exposen:
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
Ansprechen über NodePort vom Controller:
```shell
curl http://nodea:30426/
curl http://nodeb:30426/
curl http://controllplane:30426/
```
Was sagt der Controller dazu:
```shell
kubectl -n ingress-nginx logs deployment/ingress-nginx-controller
```

## Pfade
Editiere das Ingress Objekt und ändere den Pfad auf `/hello-nginx`
```shell
kubectl -n networking get ingress nginx -o yaml
```
Ansprechen:
```shell
curl http://nodea:30426/hello-nginx
```
404? Wieso?
```shell
kubectl -n networking annotate ingress nginx nginx.ingress.kubernetes.io/rewrite-target='/'
```

## Cleanup:
```shell
kubectl delete namespace networking
kubectl delete namespace ingress-nginx
```