# mysql单节点部署

## 详情

```
docker pull mysql:8.4.5
```

## docker-compose.yml

```yml
version: '3.9'
services:
  coms-mysql:
    image: mysql:8.4.5
    container_name: coms.mysql
    #ports:
    #  - '3306:3306'
    volumes:
      - ./data:/var/lib/mysql
      - ./log:/var/log/mysql
      - ./conf:/etc/mysql/conf.d
    environment:
      - MYSQL_ROOT_PASSWORD=root
    networks:
      - net.coms
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms

```