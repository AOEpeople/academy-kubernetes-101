# Troubleshooting
```
cd ~/kubernetes-101/troubleshooting
```

<!-- BEGIN mktoc -->

- [Vorbereitung](#vorbereitung)
- [Lab](#lab)
  - [Aufgabe](#aufgabe)
  - [Deployment](#deployment)
  - [Clean-up](#clean-up)
<!-- END mktoc -->

## Vorbereitung

Für dieses Lab ist es sinnvoll die Dateien lokal (= auf dem Server auf den du dich via SSH verbunden hast) zu haben. Dafür kann das Git Repo als ZIP-Datei heruntergeladen und entpackt werden.

```sh
wget https://github.com/AOEpeople/academy-kubernetes-101/archive/refs/heads/main.zip
unzip main.zip
cd academy-kubernetes-101-main/troubleshooting
```

In diesem Lab deployen wir Ressourcen mit verschiedenen Problemen. Das Ziel ist herauszufinden, warum die Ressourcen nicht richtig funktionieren und anschließend die Fehler zu beheben.

```sh 
kubectl create namespace lab-troubleshooting
```

## Lab

### Aufgabe

In den Ordnern `overlays/lab-1` bis `overlays/lab-3` befinden sich fehlerhafte Kustomize Dateien.
Die Labs sollen **nacheinander** deployed werden. Bevor das nächste Lab deployed wird, muss das vorherige aufgeräumt werden. Fange also mit `overlays/lab-1` an und mache mit `overlays/lab-2` weiter nachdem `overlays/lab-1` aufgeräumt wurde.

Finde heraus, warum die Pods in den Labs nicht starten und passe anschließend die Kustomize Dateien an um die Fehler zu beheben.

### Deployment
```sh
kubectl apply -k overlays/lab-1
```

### Clean-up
```sh
kubectl delete -k overlays/lab-1
```