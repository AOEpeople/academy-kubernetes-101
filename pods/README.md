# Lab: Pods

## Vorbereitung

Erstelle einen Namespace:

```shell
kubectl create namespace pods
```

## Pod erstellen

```shell
kubectl -n pods run nginx --image nginx
kubectl -n pods get pod nginx
kubectl -n pods get pod nginx -o yaml
kubectl -n pods describe pod nginx
# kubectl -n pods delete pod nginx
```

## Pod mit invalidem Image
Welche Pod Phase, Pod Condition und Container State erwartest du? 

```shell
kubectl -n pods run noimage --image diesesimagegibtesnicht
kubectl -n pods describe pod noimage
kubectl -n pods logs noimage
# kubectl -n pods delete pod noimage
```

## Pod restart mit completed container
Welches Ergebnis erwartest du? 

```shell
kubectl -n pods run ubuntu --image ubuntu
# kubectl -n pods delete pod ubuntu
```

## Pod restart mit fehlerhaftem container

```shell
kubectl -n pods run restart --image ubuntu -- bash -c 'sleep 60 && echo "this is an error" && exit 1'
watch kubectl -n pods get pods restart
# kubectl -n pods delete pod restart
```

## Pod am Leben erhalten

```shell
kubectl -n pods run keepalive --image ubuntu -- sleep infinity
# besser jedoch mit tail -f /var/log/myapp.log
# kubectl -n pods delete pod keepalive
```

## Exec

```shell
kubectl -n pods run execpod --image ubuntu -- sleep infinity
kubectl -n pods exec execpod -- ls /
kubectl -n pods exec -ti execpod -- bash
# kubectl -n pods delete pod execpod
```

## Cleanup

Lösche den für das Lab angelegten Namespace:

```shell
kubectl delete namespace pods
```
