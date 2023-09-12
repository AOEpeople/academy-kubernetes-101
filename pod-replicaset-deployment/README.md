# Lab: Pod, ReplicaSet, Deployment

<!-- BEGIN mktoc -->

- [Pods](#pods)
- [ReplicaSet](#replicaset)
  - [Tipps](#tipps)
- [Deployments](#deployments)
  - [Deployment erstellen](#deployment-erstellen)
  - [Tipps](#tipps)
- [Weitere Ressourcen](#weitere-ressourcen)
<!-- END mktoc -->

## Pods

Zuerst erstellen wir einen Namespace und starten drei Pods mit den Namen `nginx-pod`, `nginx-pod-2` und `nginx-pod-3`.

```sh
kubectl create namespace lab-pods
```

```sh
kubectl -n lab-pods apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/pod-replicaset-deployment/nginx-pod.yml -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/pod-replicaset-deployment/nginx-pod-2.yml -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/pod-replicaset-deployment/nginx-pod-3.yml
```

Mit `kubectl get pods` sehen wir anschließend die drei Pods.

```sh
kubectl -n lab-pods get pods
NAME             READY   STATUS    RESTARTS   AGE
nginx-pod        1/1     Running   0          10s
nginx-pod-2      1/1     Running   0          10s
nginx-pod-3      1/1     Running   0          10s
```

## ReplicaSet

Als nächstes erstellen wir ein ReplicaSet um zwei weitere nginx Instanzen zu starten.

```sh
kubectl -n lab-pods apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/pod-replicaset-deployment/nginx-replicaset.yml
```

Wir sollten mit `kubectl get pods` nun also fünf Pods sehen:

```sh
kubectl -n lab-pods get pods
NAME          READY   STATUS    RESTARTS   AGE
nginx-pod-2   1/1     Running   0          101s
nginx-pod-3   1/1     Running   0          101s
```

Oh? Was ist passiert?

Das ReplicaSet übernimmt alle Pods mit dem Label `app=nginx`, auch die **Pods, die schon laufen**!
Da drei `nginx` Pods im Cluster liefen und das ReplicaSet so konfiguriert ist, dass nur zwei Pods zur selben Zeit laufen sollen, wird ein Pod gestoppt!
Die mit `$ kubectl apply -f nginx-pod.yml [...]` erstellten Pods wurden nun vom ReplicaSet übernommen.

Nun gut, starten wir unseren ersten `nginx` Pod erneut:

```sh
kubectl -n lab-pods apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/pod-replicaset-deployment/nginx-pod.yml
pod/nginx-pod created
```

Und siehe da: wir haben wieder... zwei Pods.

```sh
kubectl -n lab-pods get pods

NAME          READY   STATUS    RESTARTS   AGE
nginx-pod-2   1/1     Running   0          4m2s
nginx-pod-3   1/1     Running   0          4m2s
```

Das ReplicaSet erkennt, dass ein neuer Pod mit label `app=nginx` gestartet wird und beendet ihn sofort.
Solange das ReplicaSet mit dem generischen Label Selector `app=nginx` im Cluster besteht, können wir nur zwei Pods mit diesem Label gleichzeitig ausführen.

Mit `kubectl describe rs nginx-rs` sehen wir ebenfalls, dass das ReplicaSet unseren Pod wieder gelöscht hat.

```sh
kubectl -n lab-pods describe rs nginx-rs

Name:         nginx-rs
Namespace:    default
Selector:     app=nginx
Labels:       app=nginx
Replicas:     2 current / 2 desired
Pods Status:  2 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  app=nginx
  Containers:
   nginx:
    Image:        nginx:1.14.2
Events:
  Type    Reason            Age                   From                   Message
  ----    ------            ----                  ----                   -------
  Normal  SuccessfulDelete  2m9s (x3 over 4m49s)  replicaset-controller  Deleted pod: nginx-pod
```

### Tipps

- `spec.selector.matchLabels` nicht generisch definieren
- `spec.selector.matchLabels` unterstützt mehrere Labels - `app=nginx` und `team=frontend` z.B. würden die Selektion einschränken
- ReplicaSets nicht direkt nutzen, lieber von Deployments managen lassen

## Deployments

Bevor wir starten, löschen wir die alten Ressourcen:

```sh
kubectl -n lab-pods delete replicaset nginx-rs
kubectl -n lab-pods delete pod -l app=nginx
```

### Deployment erstellen

Nun erstellen wir das Deployment:

```sh
kubectl -n lab-pods apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/pod-replicaset-deployment/nginx-deployment.yml
deployment.apps/nginx-deployment created
```

Und anschließend werfen wir einen Blick auf die Pods:

```sh
kubectl -n lab-pods get pods

NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-85996f8dbd-lxs5p   1/1     Running   0          5s
nginx-deployment-85996f8dbd-pwg9z   1/1     Running   0          5s
nginx-deployment-85996f8dbd-r77ql   1/1     Running   0          5s
```

`85996f8dbd` ist ein Hash, den das Deployment automatisch für uns vergeben hat. Hiermit wird sichergestellt, dass selbst bei **ungenauem `selector` Label** ein vom Deployment erstelltes ReplicaSet die richtigen Ressourcen verwaltet.

Mit `kubectl get rs` sehen wir das Replicaset, welches von unserem Deployment angelegt wurde und mit `kubectl describe rs` können wir uns dessen genaue Konfiguration anzeigen lassen.

```sh
kubectl -n lab-pods get rs

NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-85996f8dbd   3         3         3       29s
```

```sh
kubectl -n lab-pods describe rs nginx-deployment-85996f8dbd

Name:           nginx-deployment-85996f8dbd
Namespace:      default
Selector:       app=nginx,pod-template-hash=85996f8dbd
Labels:         app=nginx
                pod-template-hash=85996f8dbd
Annotations:    deployment.kubernetes.io/desired-replicas: 3
                deployment.kubernetes.io/max-replicas: 4
                deployment.kubernetes.io/revision: 1
Controlled By:  Deployment/nginx-deployment
Replicas:       3 current / 3 desired
Pods Status:    3 Running / 0 Waiting / 0 Succeeded / 0 Failed
Pod Template:
  Labels:  app=nginx
           pod-template-hash=85996f8dbd
  Containers:
   nginx:
    Image:        nginx:1.14.2
    Port:         80/TCP
    Host Port:    0/TCP
Events:
  Type    Reason            Age   From                   Message
  ----    ------            ----  ----                   -------
  Normal  SuccessfulCreate  9m1s  replicaset-controller  Created pod: nginx-deployment-85996f8dbd-pwg9z
  Normal  SuccessfulCreate  9m1s  replicaset-controller  Created pod: nginx-deployment-85996f8dbd-r77ql
  Normal  SuccessfulCreate  9m1s  replicaset-controller  Created pod: nginx-deployment-85996f8dbd-lxs5p
```

Hier sehen wir eine Menge!

- `pod-template-hash=85996f8dbd` ist ein einzigartiges Label, mit diesem wird sichergestellt, dass das ReplicaSet nur Ressourcen verwaltet, die ihm zugewiesen sind
- `app=nginx`

Wenn wir nun wieder unsere drei Pods vom Anfang starten...

```sh
kubectl -n lab-pods apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/pod-replicaset-deployment/nginx-pod.yml -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/pod-replicaset-deployment/nginx-pod-2.yml -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/pod-replicaset-deployment/nginx-pod-3.yml
```
```sh
pod/nginx-pod created
pod/nginx-pod-2 created
pod/nginx-pod-3 created
```

... sehen wir, dass diese ohne Probleme laufen! Das ReplicaSet übernimmt sie nicht, da diese Pods nicht das Label `pod-template-hash=85996f8dbd` haben.

```sh
kubectl -n lab-pods get pods
````
```sh
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-85996f8dbd-lxs5p   1/1     Running   0          15m
nginx-deployment-85996f8dbd-pwg9z   1/1     Running   0          15m
nginx-deployment-85996f8dbd-r77ql   1/1     Running   0          15m
nginx-pod                           1/1     Running   0          13s
nginx-pod-2                         1/1     Running   0          13s
nginx-pod-3                         1/1     Running   0          2s
```

### Tipps

- Deployment statt ReplicaSet nutzen
- Labels können hier generischer sein
- _Alles_ mit labeln versehen: `env=production`, `team=backend`, `maintainer=team-XYZ`, ...

## Weitere Ressourcen

- [Pods](https://kubernetes.io/docs/concepts/workloads/pods/)
- [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)
- [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
