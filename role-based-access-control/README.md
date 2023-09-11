# Role Based Access Control

<!-- BEGIN mktoc -->

- [Vorbereitung](#vorbereitung)
- [Service Account anlegen](#service-account-anlegen)
- [Lab Aufgaben](#lab-aufgaben)
- [Cleanup](#cleanup)
- [Weiterführende Links](#weiterführende-links)
<!-- END mktoc -->

## Vorbereitung

Erstelle einen neuen Namespace:

```sh
kubectl create namespace lab-rbac
```

## Service Account anlegen

Erstelle einen ServiceAccount:

```sh
kubectl -n lab-rbac create serviceaccount fancy-service
```

Zeige den neuen ServiceAccount an:

```sh
kubectl -n lab-rbac describe sa fancy-service
```

Überprüfe die Berechtigungen für den neuen ServiceAccount:

```sh
kubectl auth can-i list secrets --namespace lab-rbac --as system:serviceaccount:lab-rbac:fancy-service
# no
```

Erstelle eine `ClusterRole`, die Lese-Zugriff auf Secrets erlaubt:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: secret-reader
rules:
  - apiGroups: [""]
    resources: ["secrets"]
    verbs: ["get", "watch", "list"]
```

Erstelle ein `RoleBinding` mit dem folgenden YAML-Dokument:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-secrets
  namespace: lab-rbac
subjects:
  - kind: ServiceAccount
    name: fancy-service
roleRef:
  kind: ClusterRole
  name: secret-reader
  apiGroup: rbac.authorization.k8s.io
```

Prüfe anschließend, ob du im `lab-rbac` Namespace Secrets einsehen kannst:

```sh
kubectl auth can-i list secrets --namespace lab-rbac --as system:serviceaccount:lab-rbac:fancy-service
# yes
```

Prüfe, ob du im `default` Namespace Secrets einsehen kannst:

```sh
kubectl auth can-i list secrets --namespace default --as system:serviceaccount:lab-rbac:fancy-service
# no
```

Erstelle ein `ClusterRoleBinding` mit dem folgenden YAML-Dokument um die Rolle clusterweit zuzuweisen:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: read-secrets
subjects:
  - kind: ServiceAccount
    name: fancy-service
    namespace: lab-rbac
roleRef:
  kind: ClusterRole
  name: secret-reader
  apiGroup: rbac.authorization.k8s.io
```

Prüfe anschließend erneut, ob du im `default` Namespace Secrets einsehen kannst:

```sh
kubectl auth can-i list secrets --namespace default --as system:serviceaccount:lab-rbac:fancy-service
# yes
```

Prüfe, ob du Secrets erstellen kannst:

```sh
kubectl auth can-i create secrets --namespace lab-rbac --as system:serviceaccount:lab-rbac:fancy-service
# no
```

## Lab Aufgaben

1. Erstelle eine neue ClusterRole namens `create-secret`, die das Erstellen von Secrets erlaubt
2. Weise dem ServiceAccount die neu erstellte Rolle zu
3. Verifiziere, dass der ServiceAccount nun Secrets im Namespace `lab-rbac` anlegen kannst

```sh
kubectl auth can-i create secrets --namespace lab-rbac --as system:serviceaccount:lab-rbac:fancy-service
# yes
```

## Cleanup

Lösche den für das Lab angelegten Namespace und die clusterweiten Ressourcen:

```shell
kubectl delete namespace lab-rbac
kubectl delete clusterrolebindings read-secrets
kubectl delete clusterrole secret-reader
```

## Weiterführende Links

- [Kubernetes RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Kubernetes Service Accounts](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/)
