# Lab: Resource Management

Bereite einige Objekte für dieses Lab vor:

```shell
kubectl create namespace resource-management
```

```shell
kubectl top nodes
```

## Limits

### Memory (OOM)

```shell
kubectl -n resource-management apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/oom.yml
```

```shell
kubectl -n resource-management get pods --watch
kubectl -n resource-management get events --sort-by=lastTimestamp
kubectl -n resource-management top pods --sum
kubectl -n resource-management describe pod [POD_NAME]
```

```shell
kubectl -n resource-management delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/oom.yml
```

### CPU

```shell
kubectl -n resource-management apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/cpu.yml
watch kubectl -n resource-management top pods --sum
```

```shell
kubectl -n resource-management delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/cpu.yml
```

## Requests (Insufficient Memory, Insufficient CPU)

```shell
kubectl -n resource-management apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/insufficient.yml
```

```shell
kubectl -n resource-management get pods
kubectl -n resource-management get deployments
kubectl -n resource-management describe deployment resource-management-insufficient
kubectl -n resource-management get events --sort-by=lastTimestamp
```

```shell
kubectl -n resource-management delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/insufficient.yml
```

## Quotas

```shell
kubectl -n resource-management apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/incremental.yml
kubectl -n resource-management describe quota resource-management-incremental
kubectl -n resource-management get pods 
```

Wie viele Replicas sind möglich?

```shell
kubectl -n resource-management scale deployment/resource-management-incremental --replicas ?
```

```shell
kubectl -n resource-management describe quota resource-management-incremental
kubectl -n resource-management get events --sort-by=lastTimestamp
```

```shell
kubectl -n resource-management delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/resource-management/incremental.yml
```

## Cleanup:

```shell
kubectl delete namespace resource-management
```