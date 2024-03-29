# Lab: Konfiguration von Anwendungen

## Vorbereitung

Erstelle einen neuen Namespace und ein Deployment:

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
spec:
  ...
  template:
    ...
    spec:
      ...
      containers:
        - ...
          env:
            - name: FOO
              value: "bar"
```

Kommt sie im Container an?

```shell
kubectl -n appconfig exec deployment/app -- env
```

## ConfigMap

Erstelle eine `ConfigMap` Ressource:

```shell
kubectl -n appconfig create configmap appconfig --from-literal "foo=barfromconfig"
```

Wie sieht das Manifest aus?

```shell
kubectl -n appconfig get configmap appconfig -o yaml
```

Beziehe den Wert der Environment Variable aus der ConfigMap:

```shell
kubectl -n appconfig edit deployment app
```

```yaml
spec:
  ...
  template:
    ...
    spec:
      ...
      containers:
        - ...
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

Füge der ConfigMap eine mehrzeilige Konfiguration hinzu:

```shell
kubectl -n appconfig edit configmap appconfig
```

```yaml
data:
  ...
  app.properties: |
    foo=bar
    baz=qux
```

```shell
kubectl -n appconfig edit deployment app
```

```yaml
spec:
  ...
  template:
    ...
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

## Weiterführende Aufgaben

Erstelle ein Secret und experimentiere etwas damit:

```shell
kubectl -n appconfig create secret generic appsecret --from-literal=username=myfancyuser --from-literal=password=f8sD6S9s6
```

Du brauchst Ideen?

- Injiziere in einem Pod via Environment Variable einen Wert aus dem Secret
- Lass dir den Wert des Secret in der CLI ausgeben und dekodiere es mit `base64 -d`
- Mounte den Wert eines Secret als Datei in einem Pod

## Cleanup

Lösche den für das Lab angelegten Namespace:

```shell
kubectl delete namespace appconfig
```
