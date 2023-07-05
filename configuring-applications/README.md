# Lab: Konfiguration von Anwendungen

Bereite einige Objekte für dieses Lab vor:

```shell
kubectl create namespace appconfig
kubectl -n appconfig create deployment app --image alpine:latest -- sleep infinity
```

## Environment Variablen

Füge eine Environment Variable via `kubectl edit` hinzu:

```shell
kubectl -n appconfig edit deployment app
```

```yaml
    env:
    - name: FOO
      value: "bar"
```

Kommt sie im Container an?

```shell
kubectl -n appconfig exec deployment/app -- env
```

## ConfigMap

Erstelle ein ConfigMap Objekt

```shell
kubectl -n appconfig create configmap appconfig --from-literal "foo=barfromconfig"
```

Wie sieht das Manifest aus?

```shell
kubectl -n appconfig get configmap appconfig -o yaml
```

Beziehe den Wert der Environment Variable aus der ConfigMap

```shell
kubectl -n appconfig edit deployment app
```

```yaml
    env:
    - name: FOO
      valueFrom:
        configMapKeyRef:
          name: appconfig
          key: foo
```

Kommt sie im Container an?

```shell
kubectl -n appconfig exec deployment/app -- env
```

## ConfigMap Mount

Füge eine multiline Konfiguration der ConfigMap hinzu.

```shell
kubectl -n appconfig edit configmap appconfig
```

```yaml
data:
  app.properties: |
    foo=bar
    baz=qux
```

```shell
kubectl -n appconfig edit deployment app
```

```yaml
  spec:
    containers:
       ...
       volumeMounts:
        - name: config
          mountPath: "/config"
          readOnly: true
    ...
    volumes:
    - name: config
      configMap:
        name: appconfig
        items:
        - key: "app.properties"
          path: "app.properties"
```

Kommt die Konfiguration im Container an?

```shell
kubectl -n appconfig exec deployment/app -- cat /config/app.properties
```

## Secrets

Erstelle ein Secret und experimentiere etwas damit.

```shell
kubectl -n appconfig create secret generic appsecret --from-literal=username=myfancyuser --from-literal=password=f8sD6S9s6
```

Du brauchst Ideen?

- Injiziere einen Wert via Environment Variable
- Lass dir den Wert eines Secrets in der CLI ausgeben
- Mounte den Wert eines Secrets als Datei

## Cleanup

```shell
kubectl delete namespace appconfig
```
