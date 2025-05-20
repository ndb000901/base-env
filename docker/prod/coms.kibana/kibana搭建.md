# kibana 搭建

## 1. compose.yml

```yml

version: '3.9'
services:
  coms-kibana:
    image: kibana:8.18.1
    container_name: coms.kibana
    # ports:
    #   - '5601:5601'
    # environment:
    #   - ELASTICSEARCH_HOSTS=http://coms.es:9200
    networks:
      - net.coms
    volumes:
      - kibana_config:/usr/share/kibana/config
      - kibana_data:/usr/share/kibana/data
      - kibana_logs:/usr/share/kibana/logs
      - kibana_plugins:/usr/share/kibana/plugins
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms
volumes:
  kibana_config:
  kibana_data:
  kibana_logs:
  kibana_plugins:
```


## 2. 修改`kibana_system`密码

```bash
curl -u elastic:your_elastic_password -X POST "http://localhost:9200/_security/user/kibana_system/_password" -H "Content-Type: application/json" -d'
{
  "password": "your_kibana_system_password"
}'

```

## 3. 配置

```yml
#
# ** THIS IS AN AUTO-GENERATED FILE **
#

# Default Kibana configuration for docker target
server.host: "0.0.0.0"
server.shutdownTimeout: "5s"
elasticsearch.hosts: [ "http://coms.es:9200" ]
monitoring.ui.container.elasticsearch.enabled: true
elasticsearch.username: "kibana_system"
elasticsearch.password: "xxxxxxxxxxxxxx"
logging:
  root:
    level: info
```

## 4.添加kibana 账号

使用es账号密码登录
- user: elastic
- password: xxxx

登录http://127.0.0.1:5601 后，创建user，设置kibana_admin角色(按需)


## 5.Nginx配置

`kibana.hello.work.conf`

```conf
server {

    listen 443 ssl;
    server_name kibana.hello.work;

    ssl_certificate     certs/server-kibana.hello.work.fullchain.pem;
    ssl_certificate_key certs/kibana.hello.work.key.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://coms.kibana:5601;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```