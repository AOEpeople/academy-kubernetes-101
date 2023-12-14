# Lab: Resource Management

## Vorbereitung

Erstelle einen Namespace:

```shell
kubectl create namespace resource-management
```

Lasse dir die Auslastung der Nodes anzeigen:

```shell
kubectl top nodes
```

## Limits

### Memory

Erstelle eine Deployment, das mehr Memory nutzen möchte, als das Limit erlaubt:

```shell
kubectl -n resource-management apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/oom.yml
```

Prüfe die Pods und die letzten Events um das Verhalten bei zu hoher Memory-Nutzung zu analysieren:

```shell
kubectl -n resource-management get pods --watch
kubectl -n resource-management get events --sort-by=lastTimestamp
```

Prüfe den Status des `resource-management-cpu` Containers im Pod:

```shell
kubectl -n resource-management describe pod [POD_NAME]
```

Lösche das Deployment:

```shell
kubectl -n resource-management delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/oom.yml
```

### CPU

Erstelle eine Deployment, das die CPU auslastet:

```shell
kubectl -n resource-management apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/cpu.yml
```

Prüfe die Resource Requests und Limits des erstellen Deployments:

```shell
kubectl -n resource-management describe pod [POD_NAME]
```

Prüfe die Auslastung der Pods:

```shell
watch kubectl -n resource-management top pods --sum
```

Lösche das Deployment:

```shell
kubectl -n resource-management delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/cpu.yml
```

## Requests

Erstelle eine Deployment, das mehr CPU und Memory anfordert, als auf einer der vorhandenen Nodes zur Verfügung steht:

```shell
kubectl -n resource-management apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/insufficient.yml
```

Prüfe die Pods und die letzten Events um das Verhalten bei zu hohen Requests zu analysieren:

```shell
kubectl -n resource-management get pods
kubectl -n resource-management get deployments
kubectl -n resource-management describe deployment resource-management-insufficient
kubectl -n resource-management get events --sort-by=lastTimestamp
```

Lösche das Deployment:

```shell
kubectl -n resource-management delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/insufficient.yml
```

## Resource Quotas

Erstelle eine Resource Quota und ein Deployment zum Testen der Resource Quota:

```shell
kubectl -n resource-management apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/incremental.yml
```

Lasse dir die Details der Resource Quota anzeigen:

```shell
kubectl -n resource-management describe quota resource-management-incremental
```

Lasse dir die Pods im Namespace anzeigen:

```shell
kubectl -n resource-management get pods
```

Auf wie viele Replicas kannst du das Deployment hochskalieren bis neue Pods nicht mehr gescheduled werden?

```shell
kubectl -n resource-management scale deployment/resource-management-incremental --replicas ?
```

Lasse dir die Events der Resource Quota und die Events des Clusters anzeigen:

```shell
kubectl -n resource-management describe quota resource-management-incremental
kubectl -n resource-management get events --sort-by=lastTimestamp
```

Lösche die Resource Quota und das Deployment:

```shell
kubectl -n resource-management delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/incremental.yml
```

## Cleanup

Lösche den für das Lab angelegten Namespace:

```shell
kubectl delete namespace resource-management
```
