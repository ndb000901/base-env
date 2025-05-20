## portainer配置

## 1. docker-compose.yml

```yml
version: '3.9'
services:
  coms-portainer:
    image: portainer/portainer-ce:2.30.0
    container_name: coms.portainer
    restart: always
    # ports:
    #   - '9000:9000'
    #   - '8000:8000'
    volumes:
      - ./data:/data
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - net.coms
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms

```

## 2.Nginx 配置

`portainer.hello.work`

```conf
server {

    listen 443 ssl;
    server_name portainer.hello.work;

    ssl_certificate     certs/server-portainer.hello.work.fullchain.pem;
    ssl_certificate_key certs/portainer.hello.work.key.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;


    location / {
        proxy_pass http://coms.portainer:9000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```