# Service Accounts
```sh
cd ~/kubernetes-101/service-accounts
```
<!-- BEGIN mktoc -->

- [Vorbereitungen](#vorbereitungen)
- [Service Account anlegen](#service-account-anlegen)
- [Lab Aufgaben](#lab-aufgaben)
- [Weiterführende Links](#weiterführende-links)
<!-- END mktoc -->

## Vorbereitungen

Namespace erstellen

```sh
kubectl create namespace lab-sc
```

## Service Account anlegen

Erstelle einen Nutzer mit deinem Namen.

```sh
kubectl -n lab-sc create serviceaccount your-name
# kubectl -n lab-sc create serviceaccount kevin
```

Zeige den neuen Nutzer an

```sh
kubectl -n lab-sc describe sa your-name
# kubectl -n lab-sc describe sa kevin
```

Überprüfe die Berechtigungen für den neuen User
```sh
kubectl auth can-i list secrets --namespace lab-sc --as your-name
# kubectl auth can-i list secrets --namespace lab-sc --as kevin
no
```

Erstelle eine ClusterRole, die Lese-Zugriff auf Secrets erlaubt.

```sh
kubectl -n lab-sc apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/service-accounts/clusterrole.yml
```

Erstelle ein `ClusterRole Binding` mit dem folgenden YAML Dokument.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-secrets
  namespace: lab-sc
subjects:
- kind: User
  name: your-name
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: secret-reader
  apiGroup: rbac.authorization.k8s.io
```

Prüfe anschließend, ob du Secrets einsehen kannst.

```sh
kubectl auth can-i list secrets --namespace lab-sc --as your-user
# kubectl auth can-i list secrets --namespace lab-sc --as kevin
yes
```

Prüfe, ob du Secrets erstellen kannst:

```sh
kubectl auth can-i create secrets --namespace lab-sc --as your-user
# kubectl auth can-i create secrets --namespace lab-sc --as kevin
no
```

## Lab Aufgaben

1. Erstelle eine neue ClusterRole namens `create-secret`, die das Erstellen von Secrets erlaubt
2. Weise deinem Nutzer die neu erstellte Rolle zu
3. Verifiziere, dass du nun Secrets im Namespace `lab-sc` anlegen kannst

```sh
kubectl auth can-i create secrets --namespace lab-sc --as your-name
yes
```

## Weiterführende Links

- [RBAC Doku](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Service Accounts](https://kubernetes.io/docs/reference/access-authn-authz/service-accounts-admin/)