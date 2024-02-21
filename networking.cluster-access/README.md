# Lab: Networking - Zugriff von außen ins Cluster

Bereite einige Objekte für dieses Lab vor:

```shell
kubectl create namespace cluster-access
kubectl -n cluster-access run nginx --image nginx
kubectl -n cluster-access run curl --image curlimages/curl --command "sleep" --command "infinity"
```

## port-forward

Starte in einem neuen Terminal das Port Forwarding:

```shell
kubectl -n cluster-access port-forward pod/nginx 8080:80
```

Alternativ könnte man das Port Forwarding auch im gleichen Terminal starten und in den Hintergrund schieben:

```shell
kubectl -n cluster-access port-forward pod/nginx 8080:80 &
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
kubectl -n cluster-access expose pod nginx --port 80 --name nginx
```

Eine Ingress Objekt anlegen, das auf den Service verweist:

```shell
kubectl -n cluster-access create ingress nginx --class=nginx --rule="www.example.com/=nginx:80"
```

Wie sieht das Objekt dazu aus?

```shell
kubectl -n cluster-access get ingress nginx -o yaml
```

Bestimme und exportiere den HTTP `NodePort` des Ingress Controller Services als Umgebungsvariable im Terminal:

```shell
export NODE_PORT_HTTP=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')
```

Ansprechen über NodePort des Ingress Controller Services:

```shell
curl -H "Host: www.example.com" http://nodea:${NODE_PORT_HTTP}/
curl -H "Host: www.example.com" http://nodeb:${NODE_PORT_HTTP}/
curl -H "Host: www.example.com" http://controlplane:${NODE_PORT_HTTP}/
```

Versuche mal einen anderen Host:
```shell
curl -H "Host: www.foo.com" http://nodea:${NODE_PORT_HTTP}/
```

Was sagt der Controller dazu:

```shell
kubectl -n ingress-nginx logs deployment/ingress-nginx-controller
```

*Tipp*: Auf dem Standard Log Level loggt der `ingress-nginx-controller` nur Aufrufe für Pfade für die es ein passendes Ingress Objekt gibt.

## Pfade

Editiere das Ingress Objekt und ändere den Pfad zu `/hello-nginx`

```shell
kubectl -n cluster-access edit ingress nginx
```

Ansprechen:

```shell
curl -H "Host: www.example.com" http://nodea:${NODE_PORT_HTTP}/hello-nginx
```

404? Wieso?

```shell
kubectl -n cluster-access annotate ingress nginx nginx.ingress.kubernetes.io/rewrite-target='/'
```

## Cleanup

Lösche die für das Lab angelegten Namespaces:

```shell
kubectl delete namespace cluster-access
kubectl delete namespace ingress-nginx
```
