# Lab: Namespaces

<!-- BEGIN mktoc -->

- [Auflisten von Namespaces](#auflisten-von-namespaces)
- [Anlegen von Namespaces](#anlegen-von-namespaces)
- [Namespaces nutzen](#namespaces-nutzen)
- [Namespaces löschen](#namespaces-löschen)
- [Namespaces via YAML anlegen](#namespaces-via-yaml-anlegen)
<!-- END mktoc -->

## Auflisten von Namespaces

```shell
kubectl get namespace
```

## Anlegen von Namespaces

Namespace `anton` anlegen

```shell
kubectl create namespace anton
```

## Namespaces nutzen

Nutze den Namespace `anton` für den `nginx` Pod

```shell
kubectl run nginx --image=nginx --namespace=anton
```

```shell
kubectl get pods -n anton
```

## Namespaces löschen

Namespace löschen (**inklusive aller enthaltenen Ressourcen!**)

```shell
kubectl delete namespace anton
```

## Namespaces via YAML anlegen

Namespaces können natürlich wie jede Ressource als YAML verwaltet werden

```shell
kubectl apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/namespaces/berta.yml
```

Analog dazu können sie auch wieder entfernt werden:

```shell
kubectl delete -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/namespaces/berta.yml
```
