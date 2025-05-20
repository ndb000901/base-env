# jenkins 搭建


## 1.compose.yml

```yml

version: '3.9'
services:
  coms-jenkins:
    image: jenkins/jenkins:2.510
    container_name: coms.jenkins
    restart: always
    volumes:
      - jenkins-storage:/var/jenkins_home
    environment:
      - http_proxy=http://your-proxy-server:port
      - https_proxy=http://your-proxy-server:port
    networks:
      - net.coms
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms
volumes:
  jenkins-storage:
```

## 2.Nginx配置

`jenkins.hello.work.conf`

```conf
server {

    listen 443 ssl;
    server_name jenkins.hello.work;

    ssl_certificate     certs/server-jenkins.hello.work.fullchain.pem;
    ssl_certificate_key certs/jenkins.hello.work.key.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://coms.jenkins:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```