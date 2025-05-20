# iredmail 搭建

## 文档

 ```
 https://hub.docker.com/r/iredmail/mariadb
 https://www.jbritian.com/article/46
 https://docs.iredmail.org/install.iredmail.on.debian.ubuntu-zh_CN.html
 ```

# 安装教程

## 1、准备

```sh
mkdir /iredmail         # Create a new directory or use any directory
                        # you prefer. `/iredmail/` is just an example
cd /iredmail
touch iredmail-docker.conf

echo HOSTNAME=mail.mydomain.com >> iredmail-docker.conf
echo FIRST_MAIL_DOMAIN=mydomain.com >> iredmail-docker.conf
echo FIRST_MAIL_DOMAIN_ADMIN_PASSWORD=my-secret-password >> iredmail-docker.conf
echo MLMMJADMIN_API_TOKEN=$(openssl rand -base64 32) >> iredmail-docker.conf
echo ROUNDCUBE_DES_KEY=$(openssl rand -base64 24) >> iredmail-docker.conf


cd /iredmail
mkdir -p data/{backup-mysql,clamav,custom,imapsieve_copy,mailboxes,mlmmj,mlmmj-archive,mysql,sa_rules,ssl,postfix_queue}

```

## 2、docker 命令 

```shell
docker run \
    --rm \
    --name iredmail \
    --env-file iredmail-docker.conf \
    --hostname mail.mydomain.com \
    -p 80:80 \
    -p 443:443 \
    -p 110:110 \
    -p 995:995 \
    -p 143:143 \
    -p 993:993 \
    -p 25:25 \
    -p 465:465 \
    -p 587:587 \
    -v /iredmail/data/backup-mysql:/var/vmail/backup/mysql \
    -v /iredmail/data/mailboxes:/var/vmail/vmail1 \
    -v /iredmail/data/mlmmj:/var/vmail/mlmmj \
    -v /iredmail/data/mlmmj-archive:/var/vmail/mlmmj-archive \
    -v /iredmail/data/imapsieve_copy:/var/vmail/imapsieve_copy \
    -v /iredmail/data/custom:/opt/iredmail/custom \
    -v /iredmail/data/ssl:/opt/iredmail/ssl \
    -v /iredmail/data/mysql:/var/lib/mysql \
    -v /iredmail/data/clamav:/var/lib/clamav \
    -v /iredmail/data/sa_rules:/var/lib/spamassassin \
    -v /iredmail/data/postfix_queue:/var/spool/postfix \
    iredmail/mariadb:stable
```

## 3、docker-compose.yml

```yml
version: '3.6'
services:
  coms-iredmail:
    image: iredmail/mariadb:stable
    container_name: coms.iredmail
    hostname: mail.hello.work
    networks:
      - net.coms
    env_file:
      - ./iredmail-docker.conf
    # ports:
    #   - "11180:80"
    #   - "11443:443"
    #   - "11110:110"
    #   - "11995:995"
    #   - "11143:143"
    #   - "11993:993"
    #   - "11125:25"
    #   - "11465:465"
    #   - "11587:587"
    volumes:
      - ./data/backup-mysql:/var/vmail/backup/mysql
      - ./data/mailboxes:/var/vmail/vmail1
      - ./data/mlmmj:/var/vmail/mlmmj
      - ./data/mlmmj-archive:/var/vmail/mlmmj-archive
      - ./data/imapsieve_copy:/var/vmail/imapsieve_copy
      - ./data/custom:/opt/iredmail/custom
      - ./data/ssl:/opt/iredmail/ssl
      - ./data/mysql:/var/lib/mysql
      - ./data/clamav:/var/lib/clamav
      - ./data/sa_rules:/var/lib/spamassassin
      - ./data/postfix_queue:/var/spool/postfix
    restart: unless-stopped
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms
```

## 4、登录系统

```shell
# 登录系统，
https://mail.hello.work
# 用户名为：postmaster@hello.work
# 密码为：xxxxxxxx
# 登录后需要修改一下管理员密码

# 登录管理后台
https://mail.hello.work/iredadmin
# 用户名为：postmaster@hello.work
# 密码为：已修改
```

## 5.容器重启后会导致数据库密码重新刷新

先删除再创建

```bash
docker-compose down && docker-compose up -d
```

## 6.nginx配置

`mail.hello.work.conf`

```ini
server {

    listen 443 ssl;
    server_name mail.hello.work;

    ssl_certificate     certs/server-mail.hello.work.fullchain.pem;
    ssl_certificate_key certs/mail.hello.work.key.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass https://coms.iredmail:443; 
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```