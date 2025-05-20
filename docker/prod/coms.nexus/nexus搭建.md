# nexus搭建

## 1.compose.yml

```yml
version: '3.9'
services:
  coms-nexus:
    image: sonatype/nexus3:3.80.0
    container_name: coms.nexus
    # ports:
    #   - "8081:8081"
    networks:
      - net.coms
    volumes:
      - nexus_data:/nexus-data
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms
volumes:
  nexus_data:
```

## 2.Nginx配置

`nexus.hello.work.conf`

```conf
server {

    listen 443 ssl;
    server_name nexus.hello.work;

    ssl_certificate     certs/server-nexus.hello.work.fullchain.pem;
    ssl_certificate_key certs/nexus.hello.work.key.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://coms.nexus:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```
