# StatefulSets & DaemonSet
```sh
cd ~/kubernetes-101/statefulset
```
<!-- BEGIN mktoc -->

- [StatefulSets](#statefulsets)
  - [Vorbereitung](#vorbereitung)
  - [StatefulSet erstellen](#statefulset-erstellen)
  - [Ressourcen anschauen](#ressourcen-anschauen)
  - [Hochskalieren](#hochskalieren)
- [Lab Aufgaben](#lab-aufgaben)
- [Weitere Links](#weitere-links)
<!-- END mktoc -->

## StatefulSets

### Vorbereitung

Neuen Namespace erstellen

```sh
kubectl create namespace lab-sfs
```

### StatefulSet erstellen

```sh
kubectl -n lab-sfs apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/statefulset/nginx-statefulset.yml
```

Dies erstellt folgende Ressourcen:
- Headless Service mit nginx
- StatefulSet mit nginx replica
- Persistent Volume Claim

### Ressourcen anschauen

**Pods**
```sh
kubectl -n lab-sfs get pods
NAME    READY   STATUS    RESTARTS   AGE
web-0   1/1     Running   0          60s
web-1   1/1     Running   0          60s
web-2   1/1     Running   0          60s
```

**Service**
```sh
kubectl -n lab-sfs describe svc nginx
```

**StatefulSet**

```sh
kubectl -n lab-sfs get statefulsets
NAME   READY   AGE
web    3/3     69s
```

```sh
kubectl -n lab-sfs describe statefulset web
```


```sh
kubectl -n lab-sfs 
Name:               web
Namespace:          lab-sfs
Selector:           app=nginx
Replicas:           3 desired | 3 total
Update Strategy:    RollingUpdate
[...]
```

### Hochskalieren

```sh
kubectl -n lab-sfs scale statefulset web --replicas=5
```

```sh
kubectl -n lab-sfs get pods
NAME    READY   STATUS    RESTARTS   AGE
web-0   1/1     Running   0          15m
web-1   1/1     Running   0          15m
web-2   1/1     Running   0          15m
web-3   1/1     Running   0          47s
web-4   1/1     Running   0          27s
```

## Lab Aufgaben

**Skaliere die Pods von fünf auf zwei**

**Update das Pod image von bitnami/nginx:1.23 auf bitnami/nginx:1.25**

Um die Änderung zu validieren kann folgender Befehl benutzt werden

```sh
kubectl -n lab-sfs get pods -o jsonpath='{.items[*].spec.containers[0].image}'
```
Der Output sollte folgendes zeigen (hier mit 3 replicas):

```sh
bitnami/nginx:1.25 bitnami/nginx:1.25 bitnami/nginx:1.25
```

Periodisch kann der Output mit `watch` überprüft werden.
`watch` kann auf MacOS mit `brew` installiert werden: `brew install watch`, alternativ kann `while` benutzt werden um `watch` zu simulieren.

```sh
# mit watch
watch kubectl -n lab-sfs get pods -o jsonpath='{.items[*].spec.containers[0].image}'

# oder mit while
while true; do clear; date +"%H:%m:%S"; echo ""; kubectl -n lab-sfs get pods -o jsonpath='{.items[*].spec.containers[0].image}'; sleep 2; done
```

<details>
<summary>Tipp 1</summary>
Um das Image zu ändern muss Stateful Set (<code>nginx-stateful.yml</code>) angepasst werden.
</details>

<details>
<summary>Tipp 2</summary>
Es dauert eine Weile bis alle Pods aktualisiert wurden. Alternativ kann das StatefulSet auf 0 und anschließend auf 3 skaliert werden damit die Änderungen sofort greifen
</details>

## Weitere Links

- [StatefulSet Doku](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- [DaemonSet Doku](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)