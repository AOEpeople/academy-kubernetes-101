# Container

Baue dir deinen eigenen Container und experimentiere etwas damit.

Nutze dafür den folgenden Text als Inhalt für das [`Dockerfile`](Dockerfile):

```dockerfile
FROM nginx:alpine
RUN curl https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/container/index.html > /usr/share/nginx/html/index.html
```

Bauen des Containers

```shell
docker build -t kubernetes-101 .
```

Starten des Containers

```shell
docker run -d -p 8080:80 --name kubernetes-101 kubernetes-101
docker logs kubernetes-101
```

Aufrufen von nginx

```shell
curl localhost:8080
```

Ausführen einer Executable

```shell
docker exec kubernetes-101 nginx -v
```

Stoppen & Entfernen des Containers

```shell
docker stop kubernetes-101
docker rm kubernetes-101
```

oder

```shell
docker rm -f kubernetes-101
```

## Multi-stage builds

Beispiel aus der [Docker Dokumentation](https://docs.docker.com/build/building/multi-stage/):

```
FROM golang:1.21
WORKDIR /src
COPY <<EOF ./main.go
package main

import "fmt"

func main() {
  fmt.Println("hello, world")
}
EOF
RUN go build -o /bin/hello ./main.go

FROM scratch
COPY --from=0 /bin/hello /bin/hello
CMD ["/bin/hello"]
```
