# Storage

<!-- BEGIN mktoc -->

- [Vorbereitungen](#vorbereitungen)
- [Storage](#storage)
  - [Persistent Volume anlegen](#persistent-volume-anlegen)
  - [Persistent Volume Claim anlegen](#persistent-volume-claim-anlegen)
  - [Pods starten](#pods-starten)
- [Lab Aufgaben](#lab-aufgaben)
  - [Datei auf geteiltem Volume erstellen](#datei-auf-geteiltem-volume-erstellen)
- [Weiterführende Links](#weiterführende-links)
<!-- END mktoc -->

## Vorbereitungen

Namespace erstellen

```sh
kubectl create namespace lab-storage
```

## Storage

### Persistent Volume anlegen

```sh
kubectl -n lab-storage apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/storage/pv.yml
```

### Persistent Volume Claim anlegen

```sh
kubectl -n lab-storage apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/storage/pvc.yml
```

### Pods starten

Anschließend die Pods aus [pods.yml](https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/storage/pods.yml) deployen:

```sh
kubectl -n lab-storage apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/storage/pods.yml
```

## Lab Aufgaben

### Datei auf geteiltem Volume erstellen

Verbinde dich in den Pod `busybox`, dann erstelle eine Datei unter `/my-pvc/`. 

```sh
kubectl -n lab-storage exec -it nginx --container busybox -- /bin/sh
kubectl -n <namespace> exec -it <pod> --container <container-name> -- /bin/sh
```

Anschließend verbinde dich auf den `nginx` Container. Hier sollte im selben Verzeichnis `/my-pvc/` die eben im `busybox` Container erstellte Datei liegen.

## Weiterführende Links

- [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
