# grafana 搭建

## 1.compose.yml

```yml

version: '3.9'
services:
  coms-grafana:
    image: grafana/grafana:12.0.0
    container_name: coms.grafana
    restart: always
    volumes:
      - grafana-storage/data:/var/lib/grafana:rw
      - ./log:/var/log/grafana:rw
      - ./conf/custom.ini:/etc/grafana/custom.ini
    networks:
      - net.coms
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms
volumes:
  grafana-storage:
```

## 2.Nginx配置

`grafana.hello.work.conf`

```conf

server {

    listen 443 ssl;
    server_name grafana.hello.work;

    ssl_certificate     certs/server-grafana.hello.work.fullchain.pem;
    ssl_certificate_key certs/grafana.hello.work.key.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://coms.grafana:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```