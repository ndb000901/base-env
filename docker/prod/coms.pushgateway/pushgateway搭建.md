# pushgateway 搭建

## 1.compose.yml

```yml

version: '3.9'
services:
  coms-pushgateway:
    image: prom/pushgateway:v1.11.1
    container_name: coms.pushgateway
    restart: always
    volumes:
      - ./data:/data
    networks:
      - net.coms
    command:
      - "--web.listen-address=0.0.0.0:9091"
      - "--web.enable-admin-api"
      - "--web.enable-lifecycle"
      - "--persistence.file=/data/pushgateway.data"
      - "--persistence.interval=1m"
      - "--log.level=info"
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms

```

## 2.配置 prometheus.yml

```yml
scrape_configs:
  - job_name: "pushgateway"
    static_configs:
      - targets: ["coms.pushgateway:9091"]
```

## 3.Nginx配置

`pushgateway.hello.work.conf`

```conf
server {

    listen 443 ssl;
    server_name pushgateway.hello.work;

    ssl_certificate     certs/server-pushgateway.hello.work.fullchain.pem;
    ssl_certificate_key certs/pushgateway.hello.work.key.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://coms.pushgateway:9091;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```