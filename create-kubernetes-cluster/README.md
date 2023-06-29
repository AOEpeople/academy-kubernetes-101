# Erstelle ein Kubernetes Cluster

Erstelle ein Kubernetes Cluster mit einer Controlplane Node (controlplane) und zwei Worker Nodes (`nodea` und `nodeb`).
Die dafür benötigten Kubernetes-Binaries (`kubeadm`, `kubectl`, `kubelet`) sind bereits auf allen Nodes installiert.

Auf Controlplane Node verbinden (`ssh controlplane`) und Cluster initialisieren

```shell
sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.24.0
```

Auf Worker Nodes verbinden (`ssh nodea` bzw. `ssh nodeb`) und über den `join` Befehl zum Cluster hinzufügen

```shell
sudo kubeadm join ...
```

Zugriff vom Playground einrichten: `ssh playground`

```shell
mkdir ~/.kube/ && touch ~/.kube/config && chmod 0600 ~/.kube/config
ssh controlplane sudo cat /etc/kubernetes/admin.conf > ~/.kube/config
```

Kann ich meine Nodes schon sehen? Was fällt auf?

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