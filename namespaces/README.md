# Lab: Namespaces

```shell
cd ~/kubernetes-101/container
```

<!-- BEGIN mktoc -->

- [Anschauen von Namespaces](#anschauen-von-namespaces)
- [Anlegen von Namespaces](#anlegen-von-namespaces)
- [Namespaces nutzen](#namespaces-nutzen)
- [Namespaces löschen](#namespaces-löschen)
- [Namespaces via YAML anlegen](#namespaces-via-yaml-anlegen)
<!-- END mktoc -->

## Anschauen von Namespaces

```shell
kubectl get namespace
```

## Anlegen von Namespaces

Namespace anton anlegen

```shell
kubectl create namespace anton
```

## Namespaces nutzen

Nutze den Namespace `anton` für den nginx pod

```shell
kubectl run nginx --image=nginx --namespace=anton
```

```shell
kubectl get pods -n anton
```

## Namespaces löschen

Namespace löschen. Inklusiver aller enthaltenen Ressourcen!

```shell
kubectl delete namespace anton
```

## Namespaces via YAML anlegen

Namespace können natürlich wie jede Ressource via YAML verwaltet werden.

```shell
kubectl apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/namespace/berta.yml
```