# phpmyadmin 部署


## 1.docker-compose.yml

```yml
version: '3.9'
services:
  coms-phpmyadmin:
    image: phpmyadmin:5.2.2
    container_name: coms.phpmyadmin
    # ports:
    #   - '8080:80'
    volumes:
      - ./data:/var/lib/mysql
      - ./log:/var/log/mysql
      - ./conf:/etc/mysql/conf.d
    environment:
      - UPLOAD_LIMIT=500M
      - PMA_HOST=coms.mysql
      - PMA_PORT=3306
      - MYSQL_ROOT_PASSWORD=root
      - PMA_ARBITRARY=1
      - PMA_USER=admin
      - PMA_PASSWORD=123456
    networks:
      - coms.hello.com
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms
```

## 2.Nginx配置

`phpmyadmin.hello.work.conf`

```conf

server {

    listen 443 ssl;
    server_name phpmyadmin.hello.work;

    ssl_certificate     certs/server-phpmyadmin.hello.work.fullchain.pem;
    ssl_certificate_key certs/phpmyadmin.hello.work.key.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://coms.phpmyadmin;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```