# Kustomize
<!-- BEGIN mktoc -->

- [Vorbereitung](#vorbereitung)
- [Using kustomize](#using-kustomize)
- [Lab](#lab)
- [Weiterführende Links](#weiterführende-links)
<!-- END mktoc -->

## Vorbereitung

Wir erstellen folgende Namespaces:

```sh
kubectl create namespace lab-kustomize-dev
kubectl create namespace lab-kustomize-prod
```

## Nutzung von kustomize

Deploye die Dev-Umgebung

```sh
$ kubectl apply -k https://github.com/AOEpeople/academy-kubernetes-101//kustomize/overlays/dev?ref=main
configmap/my-config-kmghh8bd92 created
service/envdump created
deployment.apps/envdump created
```

Da wir in unserem Overlay den Namespace setzen, müssen wir hier _keinen Namespace (`-n`)_ angeben.

## Lab

Schaue dir die Dateien in `overlays/dev` an. Nun erstelle in `overlays/prod` folgende Anpassungen:

- Der Service soll mit 2 Replicas laufen
- Alle Ressourcen in `prod` sollen außerdem die Annotation `kustomized.io/overlays: prod` erhalten

## Weiterführende Links

- [Kustomize Doku](https://kubectl.docs.kubernetes.io/references/kustomize/)
