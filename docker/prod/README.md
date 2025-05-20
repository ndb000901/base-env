# 生产环境

## 1. 基础组件及域名配置

| 服务名            | ip             | 端口 | 域名                   |
| ----------------- | -------------- | ---- | ---------------------- |
| coms.gitlab       | 192.168.43.241 |      | gitlab.hello.work      |
| coms.nginx        | 192.168.43.241 | 443  |                        |
| coms.iredmail     | 192.168.43.241 |      | mail.hello.work        |
| coms.pushgateway  | 192.168.43.241 |      | pushgateway.hello.work |
| coms.prometheus   | 192.168.43.241 |      | prometheus.hello.work  |
| coms.grafana      | 192.168.43.241 |      | grafana.hello.work     |
| coms.nexus        | 192.168.43.241 |      | nexus.hello.work       |
| coms.jenkins      | 192.168.43.241 |      | jenkins.hello.work     |
| coms.sentinel     | 192.168.43.241 |      | sentinel.hello.work    |
| coms.nacos        | 192.168.43.241 |      | nacos.hello.work       |
| coms.seata        | 192.168.43.241 |      | seata.hello.work       |
| coms.elasticsearch| 192.168.43.241 |      |                        |
| coms.kibana       | 192.168.43.241 |      | kibana.hello.work      |
| coms.mysql        | 192.168.43.241 |      |                        |
| coms.redis        | 192.168.43.241 |      |                        |
| coms.phpmyadmin   | 192.168.43.241 |      | phpmyadmin.hello.work  |
| coms.portainer    | 192.168.43.241 |      | portainer.hello.work   |
| coms.rabbitmq.i1  | 192.168.43.241 |      | rabbitmq.hello.work    |
| coms.rabbitmq.i2  | 192.168.43.241 |      |                        |
| coms.rabbitmq.i3  | 192.168.43.241 |      |                        |
| coms.zookeeper.i1 | 192.168.43.241 |      |                        |
| coms.zookeeper.i2 | 192.168.43.241 |      |                        |
| coms.zookeeper.i3 | 192.168.43.241 |      |                        |
| svc-gateway-i1    | 192.168.43.241 |      | apis.hello.work        |


## 2. 生成证书

按需修改脚本生成目录

[gen-cert.sh](../../ca/gen-cert.sh)


```bash

./gen-cert.sh gitlab.hello.work 3650
./gen-cert.sh mail.hello.work 3650
./gen-cert.sh pushgateway.hello.work 3650
./gen-cert.sh prometheus.hello.work 3650
./gen-cert.sh grafana.hello.work 3650
./gen-cert.sh nexus.hello.work 3650
./gen-cert.sh jenkins.hello.work 3650
./gen-cert.sh sentinel.hello.work 3650
./gen-cert.sh nacos.hello.work 3650
./gen-cert.sh seata.hello.work 3650
./gen-cert.sh logs.hello.work 3650
./gen-cert.sh phpmyadmin.hello.work 3650
./gen-cert.sh portainer.hello.work 3650
./gen-cert.sh rabbitmq.hello.work 3650
./gen-cert.sh apis.hello.work 3650

```

## 3. 组件搭建教程


- [gitlab](./coms.gitlab/gitlab搭建.md)
- [iredmail](./coms.iredmail/iredmail搭建.md)
- [jenkins](./coms.jenkins/jenkins搭建.md)
- [nexus](./coms.nexus/nexus搭建.md)
- [prometheus](./coms.prometheus/prometheus搭建.md)
- [pushgateway](./coms.pushgateway/pushgateway搭建.md)
- [grafana](./coms.grafana/grafana搭建.md)
- [seata](./coms.seata/seata搭建.md)
- [sentinel](./coms.sentinel/sentinel搭建.md)
- [zookeeper](./coms.zookeeper/zookeeper搭建.md)
- [nacos](./coms.nacos/nacos搭建.md)
- [elasticsearch](./coms.elasticsearch/elasticsearch搭建.md)
- [kibana](./coms.kibana/kibana搭建.md)
- [rabbitmq](./coms.rabbitmq/rabbitmq搭建.md)
- [redis](./coms.redis/Redis搭建.md)
- [mysql](./coms.mysql/mysql搭建.md)
- [phpmyadmin](./coms.phpmyadmin/phpmyadmin搭建.md)
- [nginx](./coms.nginx/Nginx搭建.md)
- [portainer](./coms.portainer/portainer搭建.md)



