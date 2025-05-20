# Gitlab 安装

## 文档

```shell
https://docs.gitlab.com/ee/install/docker/installation.html
```

## 安装

### 1.创建目录

```shell
mkdir -p config logs data
```

### 2.docker-compose.yml

```yml
version: '3.6'
services:
  coms-gitlab:
    image: gitlab/gitlab-ee:18.0.0-ee.0
    container_name: coms.gitlab
    restart: always
    hostname: 'gitlab.hello.work'
    networks:
      - net.coms
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        # Add any other gitlab.rb configuration here, each on its own line
        external_url 'https://gitlab.hello.work'
    # ports:
    #   - '80:80'
    #   - '443:443'
    #   - '2222:22'
    volumes:
      - './config:/etc/gitlab'
      - './logs:/var/log/gitlab'
      - './data:/var/opt/gitlab'
      - './backup:/data/backup'
    shm_size: '256m'
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms
```

### 3.降低内存

[config/gitlab.rb](gitlab.rb)


### 4.配置邮件

```shell
###! Docs: https://docs.gitlab.com/omnibus/settings/smtp.html
###! **Use smtp instead of sendmail/postfix.**
gitlab_rails['smtp_enable'] = true
# 可直接容器名coms.iredmail
gitlab_rails['smtp_address'] = "coms.iredmail"
gitlab_rails['smtp_port'] = 11465
gitlab_rails['smtp_user_name'] = "gitlab.no.reply@hello.work"
gitlab_rails['smtp_password'] = "xxxxxxxxxxxx"
gitlab_rails['smtp_domain'] = "hello.work"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = false
gitlab_rails['smtp_tls'] = true
gitlab_rails['smtp_pool'] = false
gitlab_rails['smtp_openssl_verify_mode'] = 'none'
gitlab_rails['smtp_ca_path'] = "/etc/gitlab/ssl" # iredmail 配置 data/ssl
# gitlab_rails['smtp_ca_file'] = "/etc/ssl/certs/ca-certificates.crt"
gitlab_rails['gitlab_email_from'] = 'gitlab.no.reply@hello.work'
# gitlab_rails['gitlab_email_display_name'] = 'Example'
gitlab_rails['gitlab_email_reply_to'] = 'gitlab.no.reply@hello.work'
```

#### 测试邮件

```
docker exec -it coms.gitlab gitlab-rails console

Notify.test_email('xxxx@hello.work', 'Test Subject', 'This is a test message').deliver_now

```

#### 留存`gitlab.no.reply@hello.work` 发送的记录

在iredmail 编辑，然后重启
```bash
# vim iredmail/data/custom/postfix/sender_bcc
gitlab.no.reply@hello.work gitlab.archive@hello.work
```

### 5.登录

- user: root
- password: xxxx

查看密码
```bash
docker exec -it coms.gitlab cat /etc/gitlab/initial_root_password
```

### 6.备份

```shell
# https://docs.gitlab.com/ee/install/docker/backup_restore.html
docker exec -t <container name> gitlab-backup create

```

### 7.nginx配置

`gitlab.hello.work.conf`

```ini
server {
    listen 443 ssl;
    server_name gitlab.hello.work;

    ssl_certificate     certs/server-gitlab.hello.work.fullchain.pem;
    ssl_certificate_key certs/gitlab.hello.work.key.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://coms.gitlab:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}

```


