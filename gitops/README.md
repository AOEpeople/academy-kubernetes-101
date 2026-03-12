# Lab: GitOps mit Argo CD

## Vorbereitung

Erstelle den Namespace und installiere Argo CD:

```shell
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Argo CD wird ohne externe IP installiert. Verwende daher Port-Forwarding, um das UI lokal zu erreichen:

```shell
ssh -L 8080:localhost:8080 user@server "kubectl port-forward svc/argocd-server -n argocd 8080:443"
```

Melde dich mit dem Benutzer `admin` an. Das Initial-Passwort liest du aus dem Secret:

```shell
kubectl get secret -n argocd argocd-initial-admin-secret -ojsonpath='{.data.password}' | base64 -d
```

## GitOps Application erstellen

Erstelle die deklarative Argo CD Application aus diesem Repository:

```shell
kubectl apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/gitops/application.yaml
```

Prüfe anschließend den Sync-Status:

```shell
kubectl -n argocd get applications.argoproj.io
```

Die Application referenziert das Helm Chart unter `helm/simple-chart` und deployt in den Namespace `lab-gitops`.

## Drift Detection und Self-Healing

Simuliere Drift, indem du das Deployment manuell änderst:

```shell
kubectl -n lab-gitops scale deployment customer-feedback-nginx-simple-chart --replicas=1
```

Beobachte dann den Status im Argo CD UI:

- Die App wird als `OutOfSync` markiert.
- Durch `selfHeal: true` stellt Argo CD den Git-Zustand automatisch wieder her.

## Weiterführender Hinweis

Argo CD kann gut mit Argo Rollouts kombiniert werden. So lassen sich z. B. Canary-Deployments umsetzen, bei denen neue Versionen schrittweise ausgerollt werden.
