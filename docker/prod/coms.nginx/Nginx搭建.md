# Nginx Docker部署

## 1.拉取镜像

```bash

docker pull nginx:1.27.4
```

## 2.compose.yml

```bash

name: coms-nginx # 项目名称
services:
  coms-nginx:
    container_name: coms.nginx # 容器名称
    image: nginx:1.28.0 # 镜像
    restart: unless-stopped # 重启
    ports: # 端口
      - "443:443"
      - "80:80"
    volumes: # 挂载目录
      - ./log:/var/log/nginx:rw
      - ./conf:/etc/nginx:rw
      - ./html:/usr/share/nginx/html:rw
    networks:
      net.coms: {}
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms
```