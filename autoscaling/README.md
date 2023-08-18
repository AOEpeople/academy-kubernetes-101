# Autoscaling
<!-- BEGIN mktoc -->

- [Vorbereitung](#vorbereitung)
- [Autoscaling](#autoscaling)
  - [HPA (Horizontal Pod Autoscaler)](#hpa-horizontal-pod-autoscaler)
  - [Load stoppen](#load-stoppen)
<!-- END mktoc -->

## Vorbereitung

Namespace erstellen

```sh
$ kubectl create namespace lab-autoscaling
```

Metrics Server in den `default` Namespace installieren

```sh
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

## Autoscaling

### HPA (Horizontal Pod Autoscaler)

1. Web App deployen

```sh
kubectl -n lab-autoscaling apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/autoscaling/web-app.yml
```

2. HPA anlegen

```sh
kubectl -n lab-autoscaling autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
```

3. HPA anzeigen lassen

```sh
kubectl -n lab-autoscaling get hpa
```

4. Load auf Web App generieren

In einem neuen Terminal (und neuer SSH Session!) führen wir folgenden Befehl aus um Load auf der Web App zu generieren.

```sh
kubectl run -n lab-autoscaling -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"
```

Dann schauen wir uns den HPA an

```sh
kubectl -n lab-autoscaling get hpa php-apache --watch
```

Mit Load auf dem Webserver zeigt der HPA hohe Auslastung an (~300% sind nicht untypisch), sodass die Pods hochskaliert werden. Nach und nach sollten weitere Pods gestartet werden bis sich die Auslastung normalisiert.

### Load stoppen

Im Terminal mit dem busybox load-generator `<Ctrl>+C` drücken um den Container zu stoppen.

Im Terminal mit kubectl kann nun mit `kubectl -n lab-autoscaling get hpa php-apache --watch` beobachtet werden wie der Service wieder zurückskaliert wird.
