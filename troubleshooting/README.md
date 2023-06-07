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

Für dieses Lab ist es sinnvoll die Dateien local (= auf dem Server auf den du dich via SSH verbunden hast) zu haben. Dafür kann das Git Repo als ZIP runtergeladen werden.

```sh
wget https://github.com/AOEpeople/academy-kubernetes-101/archive/refs/heads/main.zip
unzip main.zip
cd academy-kubernetes-101-main/troubleshooting
```

In diesem Lab deployen wir Ressourcen mit verschiedenen Problemen. Das Ziel ist es, herauszunfinden warum die Ressourcen nicht richtig funktionieren und anschließend die Fehler zu beheben.

```sh 
kubectl create namespace lab-troubleshooting
```

## Lab

### Aufgabe

In den Ordnern `overlays/lab-1` bis `overlays/lab-3` befinden sich Fehlerhafte Kustomize Dateien. Deploye die Labs **nacheinander**. `overlays/lab-1` sollte deployed und destroyed werden bevor `overlays/lab-2` deployed wird, usw. 

Finde heraus, warum die Pods in den Labs nicht startet und nutze anschließend die Kustomize Dateien um die Fehler zu beheben.

### Deployment
```sh
kubectl apply -k overlays/lab-1
```

### Clean-up
```sh
kubectl delete -k overlays/lab-1
```