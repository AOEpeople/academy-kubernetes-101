# StatefulSets & DaemonSet

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
kubectl create namespace lab-sts
```

### StatefulSet erstellen

```sh
kubectl -n lab-sts apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/statefulset/nginx-statefulset.yml
```

Dies erstellt folgende Ressourcen:

- Headless Service mit nginx
- StatefulSet mit nginx Replica
- PersistentVolumeClaim

### Ressourcen anschauen

**Pods**

```sh
kubectl -n lab-sts get pods
NAME    READY   STATUS    RESTARTS   AGE
web-0   1/1     Running   0          60s
web-1   1/1     Running   0          60s
web-2   1/1     Running   0          60s
```

**Service**

```sh
kubectl -n lab-sts describe svc nginx
```

**StatefulSet**

```sh
kubectl -n lab-sts get statefulsets
NAME   READY   AGE
web    3/3     69s
```

```sh
kubectl -n lab-sts describe statefulset web
```

```sh
kubectl -n lab-sts
Name:               web
Namespace:          lab-sts
Selector:           app=nginx
Replicas:           3 desired | 3 total
Update Strategy:    RollingUpdate
[...]
```

### Hochskalieren

```sh
kubectl -n lab-sts scale statefulset web --replicas=5
```

```sh
kubectl -n lab-sts get pods
NAME    READY   STATUS    RESTARTS   AGE
web-0   1/1     Running   0          15m
web-1   1/1     Running   0          15m
web-2   1/1     Running   0          15m
web-3   1/1     Running   0          47s
web-4   1/1     Running   0          27s
```

## Lab Aufgaben

**Skaliere die Replicas von fünf auf zwei**

**Update das Pod Image von `bitnami/nginx:1.23` zu `bitnami/nginx:1.25`**

Folgender Befehl kann genutzt werden um die Änderung zu validieren

```sh
kubectl -n lab-sts get pods -o jsonpath='{.items[*].spec.containers[0].image}'
```

Der Output sollte folgendes zeigen (hier mit 3 Replicas):

```sh
bitnami/nginx:1.25 bitnami/nginx:1.25 bitnami/nginx:1.25
```

Mit `watch` kann der Output periodisch überprüft werden.
`watch` kann auf MacOS mit `brew` installiert werden: `brew install watch`, alternativ kann `while` benutzt werden um `watch` zu simulieren.

```sh
# mit watch
watch kubectl -n lab-sts get pods -o jsonpath='{.items[*].spec.containers[0].image}'

# oder mit while
while true; do clear; date +"%H:%m:%S"; echo ""; kubectl -n lab-sts get pods -o jsonpath='{.items[*].spec.containers[0].image}'; sleep 2; done
```

<details>
<summary>Tipp 1</summary>
Um das Image zu ändern, muss das StatefulSet (<code>nginx-stateful.yml</code>) angepasst werden.
</details>

<details>
<summary>Tipp 2</summary>
Es dauert eine Weile bis alle Pods aktualisiert wurden. Alternativ kann das StatefulSet auf 0 und anschließend auf 3 Replicas skaliert werden, damit die Änderungen sofort greifen.
</details>

## Weitere Links

- [StatefulSet Doku](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
- [DaemonSet Doku](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)

## Cleanup

Lösche die für das Lab angelegten Ressourcen:

```sh
kubectl delete namespace lab-sts
```
