# Lab: Pod Security Standards & Pod Security Admission

## Vorbereitung

Erstelle einen neuen Namespace für dieses Lab:

```shell
kubectl create namespace pod-security
```

## Baseline

- Aktiviere das Enforcement des Pod Security Standards Profils `baseline` für den `pod-security` Namespace:

```shell
kubectl label --overwrite namespace pod-security pod-security.kubernetes.io/enforce=baseline
```

- *Tipp*: In der [Kubernetes Dokumentation](https://kubernetes.io/docs/concepts/security/pod-security-standards/#baseline) werden die Policies des `baseline` Profils beschrieben.

- Erstelle ein Deployment, das einen `nginx` Container starten möchte:

```shell
kubectl apply -f https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/pod-security/nginx-deployment.yaml
```

- Prüfe warum kein Pod für das Deployment erstellt wird.

<details>
<summary>Tipp</summary>

Die Kubernetes Events können beim Debuggen helfen:

```shell
kubectl -n pod-security get events --sort-by=lastTimestamp
```
</details>

<details>
<summary>Lösung</summary>

Die Pods dürfen in dem Namespace nicht gestartet werden, da `privileged: true` im `securityContext` gesetzt ist.
</details>

- Behebe das Problem ohne das `pod-security.kubernetes.io/enforce` Label am `pod-security` Namespace zu verändern.

<details>
<summary>Lösung</summary>

Entferne `privileged: true` aus dem `securityContext` oder setze den Wert auf `false`.
</details>

## Weiterführende Aufgaben: Restricted

- Der Namespace soll nun stärker abgesichert werden, setze dafür das Pod Security Standards Profil auf `restricted`.

- *Tipp*: In der [Kubernetes Dokumentation](https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted) werden die Policies des `restricted` Profils beschrieben.

- Skaliere das `nginx` Deployment temporär auf 0 Replicas herunter und skaliere es danach wieder auf 1 Replica hoch.

- Prüfe warum kein Pod für das Deployment erstellt wird.

<details>
<summary>Lösung</summary>

Die Pods dürfen in dem Namespace nicht gestartet werden, da `allowPrivilegeEscalation: true` nicht im `securityContext` gesetzt ist, das Image mit dem `root` User läuft und verbotene `capabilities` gesetzt sind.
</details>

- Behebe das Problem ohne das `pod-security.kubernetes.io/enforce` Label am `pod-security` Namespace zu verändern.

<details>
<summary>Tipp 1: allowPrivilegeEscalation</summary>

Das `allowPrivilegeEscalation` Attribut muss explizit auf `false` gesetzt sein um zu verhindern, dass Prozesse in dem Container ihre Privilegien über Befehle wie `sudo` eskalieren.
</details>

<details>
<summary>Tipp 2: runAsNonRoot</summary>

Das `nginx` Image läuft immer mit dem `root` User und kann auch nicht via `runAsUser` sinnvoll umkonfiguriert werden.

Das `nginxinc/nginx-unprivileged` Image ist eine Alternative zum `nginx` Image und läuft mit einem User, der keine `root`-Rechte hat.

Zusätzlich muss `runAsNonRoot: true` im securityContext gesetzt werden.
</details>

<details>
<summary>Tipp 3: unrestricted capabilities</summary>

Das normale `nginx` Image benötigt bestimmte Linux Capabilities (`CHOWN`, `NET_BIND_SERVICE`, `SETGID`, `SETUID`).
Diese wurden explizit über `securityContext.capabilities.add` hinzugefügt, da über `securityContext.capabilities.drop=['ALL']` alle nicht explizit hinzugefügten Capabilities verboten werden.

Das `nginxinc/nginx-unprivileged` Image benötigt diese Capabilities nicht, der gesamte `add`-Block kann damit entfernt werden.
</details>

## Cleanup

Lösche den für das Lab angelegten Namespace:

```shell
kubectl delete namespace pod-security
```
