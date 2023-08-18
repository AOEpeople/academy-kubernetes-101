# kubectl

Der Umgang mit kubectl, die Basics.

## Welche Ressourcen gibt es?

Auflisten aller API Ressourcen

```shell
kubectl api-resources
```

Erklärung einer Ressource

```shell
kubectl explain pod
kubectl explain pod --recursive --api-version v1
```

## Auflisten von Objekten

Auflisten aller Namespaces

```shell
kubectl get namespace
```

Auflisten aller Pods in allen Namespaces

```shell
kubectl get pods --all-namespaces
```

Auflisten eines Pods in einem Namespace

```shell
kubectl get pod etcd-controlplane -n kube-system
```

Ausgabeformat definieren

```shell
kubectl get namespaces default -o wide
kubectl get namespaces default -o yaml
kubectl get namespaces default -o jsonpath='{.metadata.name}'
```

## Beschreiben von Objekten

Detaillierte Informationen über einen Pod abrufen

```shell
kubectl -n kube-system describe pod etcd-controlplane
```

## Starten eines Containers

Starten eines Containers via `kubectl`

```shell
kubectl run curl --image=curlimages/curl --command "curl" --command "google.de"
```

Beobachten des Containers

```shell
watch kubectl get pod curl
```

Anzeigen der Ausgabe des Containers

```shell
kubectl logs curl
```

Löschen des Containers

```shell
kubectl delete pod curl
```

## Imperatives Erstellen von Objekten

Imperatives Erstellen von Objekten via kubectl

```shell
kubectl create deployment nginx --image nginx
```

## Editieren von Objekten

Interaktives Anpassen eines Deployments

```shell
kubectl edit deployment nginx
```

## Löschen von dedizierten Objekten

Löschen eines Deployments

```shell
kubectl delete deployment nginx
```

## Deklaratives Erstellen von Objekten

Hinzufügen und Löschen von Objekten über deklarative YAML Manifeste

```shell
kubectl apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/kubectl/pod.yml
```

```shell
kubectl get pods
```

```shell
kubectl delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/kubectl/pod.yml
```

```shell
kubectl get pods
```

## Cleanup

Löscht alle Objekte in einem Namespace

```shell
kubectl delete all --all
```
