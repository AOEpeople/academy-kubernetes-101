# Container
Baue dir deinen eigenen Container und experimentiere etwas.

`Dockerfile`:
```dockerfile
FROM nginx:alpine
RUN curl https://raw.githubusercontent.com/AOEpeople/academy-kubernetes-101/main/container/index.html > /usr/share/nginx/html/index.html \
```

bauen des containers
```shell
docker build -t kubernetes-101 .
```

starten des containers
```shell
docker run -d -p 8080:80 --name kubernetes-101 kubernetes-101
docker logs kubernetes-101
```

nginx aufrufen
```shell
 curl localhost:8080
```

ausführen einer executable
```shell
docker exec kubernetes-101 nginx -v
```

stoppen & entfernen
```shell
docker stop kubernetes-101
docker rm kubernetes-101
```
oder
```shell
docker rm -f kubernetes-101
```