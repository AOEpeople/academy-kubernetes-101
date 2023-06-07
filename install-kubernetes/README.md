# Installiere Kubernetes

Installiere Kubernetes

Auf control-plane verbinden: `ssh controlplane`
```shell
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.24.0
```

Auf nodes verbinden: `ssh nodea` bzw. `ssh nodeb` und join Befehl ausführen
```shell
sudo kubeadm join ...
```

Zugriff vom Playground einrichten: `ssh playground`
```shell
mkdir ~/.kube/ && touch ~/.kube/config && chmod 0600 ~/.kube/config
ssh controlplane sudo cat /etc/kubernetes/admin.conf > ~/.kube/config
```

kann ich meine nodes schon sehen? Was fällt auf?
```shell
kubectl get nodes
kubectl get pods -A
```

CNI Plugin installieren
```shell
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml
```

Beobachten
```shell
watch kubectl get pods -A
```