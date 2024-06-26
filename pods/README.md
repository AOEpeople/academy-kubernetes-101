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
kubectl -n pods run restarting-pod --image ubuntu -- bash -c 'sleep 60 && echo "this is an error" && exit 1'
watch kubectl -n pods get pods restarting-pod
# kubectl -n pods delete pod restarting-pod
```

## Pod am Leben erhalten

```shell
kubectl -n pods run keepalive-pod --image ubuntu -- sleep infinity
# besser jedoch mit tail -f /var/log/myapp.log
# kubectl -n pods delete pod keepalive-pod
```

## Exec

```shell
kubectl -n pods run exec-pod --image ubuntu -- sleep infinity
kubectl -n pods exec exec-pod -- ls /
kubectl -n pods exec -ti exec-pod -- bash
# kubectl -n pods delete pod exec-pod
```

## Weiterführende Aufgaben

1. Erstelle im `pods` Namespace einen Pod zum Debugging mit dem Namen `debug-pod` und dem Image `alpine` sodass direkt eine interaktive Shell (z.B. `/bin/sh`) geöffnet wird
    - *Tipp*: Prüfe was die Flags `-i` und `-t` von `kubectl run` machen
2. Installiere im `debug-pod` Pod das `curl` Package und teste die Verbindung zu `https://www.aoe.com/de/academy/cloud-devops/kubernetes-101.html`

## Cleanup

Lösche den für das Lab angelegten Namespace:

```shell
kubectl delete namespace pods
```
