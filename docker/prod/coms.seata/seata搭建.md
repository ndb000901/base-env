# seata搭建

## 1.compose.yml

```yml

version: '3.9'
services:
  coms-seata:
    image: seataio/seata-server:2.0.0
    container_name: coms.seata
    # environment:
    #   - SEATA_CONFIG_NAME=file:/seata-config/registry
    networks:
      - net.coms
    # ports:
    #   - 8091:8091
    #   - 7091:7091
    # volumes:
    #   - ./config:/seata-config
    #   - ./logs:/root/logs
    restart: always
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms
```

## 2.Nginx 配置

`seata.hello.work.conf`

```conf

server {

    listen 443 ssl;
    server_name seata.hello.work;

    ssl_certificate     certs/server-seata.hello.work.fullchain.pem;
    ssl_certificate_key certs/seata.hello.work.key.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://coms.seata:7091;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```


