# prometheus搭建

## 1.compose.yml

```yml

version: '3.9'
services:
  coms-prometheus:
    image: prom/prometheus:v3.4.0
    container_name: coms.prometheus
    restart: always
    volumes:
      - ./conf/prometheus.yml:/etc/prometheus/prometheus.yml
      - storage:/prometheus
    networks:
      - net.coms
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms
volumes:
  prometheus-storage:
```

## 2.Nginx配置

`prometheus.hello.work.conf`

```conf
server {

    listen 443 ssl;
    server_name prometheus.hello.work;

    ssl_certificate     certs/server-prometheus.hello.work.fullchain.pem;
    ssl_certificate_key certs/prometheus.hello.work.key.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://coms.prometheus:9090;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}

```