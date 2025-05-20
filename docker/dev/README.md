# 开发环境

## 1. 基础组件及域名配置

| 服务名            | ip             | 端口 | 域名                   |
| ----------------- | -------------- | ---- | ---------------------- |
| coms.nginx        | 192.168.43.242 | 443  |                        |
| coms.pushgateway  | 192.168.43.242 |      | pushgateway.dev.hello.work |
| coms.prometheus   | 192.168.43.242 |      | prometheus.dev.hello.work  |
| coms.sentinel     | 192.168.43.242 |      | sentinel.dev.hello.work    |
| coms.nacos        | 192.168.43.242 |      | nacos.dev.hello.work       |
| coms.seata        | 192.168.43.242 |      | seata.dev.hello.work       |
| coms.elastic      | 192.168.43.242 |      |                        |
| coms.kibana       | 192.168.43.242 |      | kibana.dev.hello.work        |
| coms.mysql        | 192.168.43.242 |      |                        |
| coms.redis        | 192.168.43.242 |      |                        |
| coms.phpmyadmin   | 192.168.43.242 |      | phpmyadmin.dev.hello.work  |
| coms.portainer    | 192.168.43.242 |      | portainer.dev.hello.work   |
| coms.rabbitmq.i1  | 192.168.43.242 |      | rabbitmq.dev.hello.work    |
| coms.rabbitmq.i2  | 192.168.43.242 |      |                        |
| coms.rabbitmq.i3  | 192.168.43.242 |      |                        |
| coms.zookeeper.i1 | 192.168.43.242 |      |                        |
| coms.zookeeper.i2 | 192.168.43.242 |      |                        |
| coms.zookeeper.i3 | 192.168.43.242 |      |                        |
| svc-gateway-i1    | 192.168.43.242 |      | apis.dev.hello.work        |


## 2. 生成证书

按需修改脚本生成目录

[gen-cert.sh](../../ca/gen-cert.sh)


```bash

./gen-cert.sh pushgateway.dev.hello.work 3650
./gen-cert.sh prometheus.dev.hello.work 3650
./gen-cert.sh sentinel.dev.hello.work 3650
./gen-cert.sh nacos.dev.hello.work 3650
./gen-cert.sh seata.dev.hello.work 3650
./gen-cert.sh kibana.dev.hello.work 3650
./gen-cert.sh phpmyadmin.dev.hello.wor 3650
./gen-cert.sh portainer.dev.hello.work 3650
./gen-cert.sh rabbitmq.dev.hello.work 3650
./gen-cert.sh apis.dev.hello.work 3650

```

