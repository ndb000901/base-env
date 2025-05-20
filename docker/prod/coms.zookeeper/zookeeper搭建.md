# zookeeper 搭建

## 1.compose.yml

```yml
name: coms-zookeeper # 项目名称
services:
  coms.zookeeper.i1:
    container_name: coms.zookeeper.i1 # 容器名称
    image: zookeeper:3.9.3 # 镜像
    build: . # 本地构建
    restart: unless-stopped # 重启
    environment:
      - ZOO_MY_ID=1
      - JVMFLAGS=-Xmx4096m
    #   - JVMFLAGS=-Xmx10240m -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.rmi.port=11098 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=192.168.43.241
    # ports: # 端口
    #   - "12181:2181"
    #   - "11099:1099"
    #   - "11098:11098"
    #   - "28081:8080"
    volumes: # 挂载目录
      - ./zoo.cfg:/conf/zoo.cfg:ro
      - ./data1/data:/data:rw
      - ./data1/log:/logs:rw
    networks:
      - net.coms

  coms.zookeeper.i2:
    container_name: coms.zookeeper.i2 # 容器名称
    image: zookeeper:3.9.3 # 镜像
    build: . # 本地构建
    restart: unless-stopped # 重启
    environment:
      - ZOO_MY_ID=2
      - JVMFLAGS=-Xmx4096m
    #   - JVMFLAGS=-Xmx10240m -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.rmi.port=11198 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=192.168.43.241
    # ports: # 端口
    #   - "12182:2181"
    #   - "28082:8080"
    #   - "11199:1099"
    #   - "11198:11198"
    volumes: # 挂载目录
      - ./zoo.cfg:/conf/zoo.cfg:ro
      - ./data2/data:/data:rw
      - ./data2/log:/logs:rw
    networks:
      - net.coms
  coms.zookeeper.i3:
    container_name: coms.zookeeper.i3 # 容器名称
    image: zookeeper:3.9.3 # 镜像
    restart: unless-stopped # 重启
    environment:
      - ZOO_MY_ID=3
      - JVMFLAGS=-Xmx4096m
    #   - JVMFLAGS=-Xmx10240m -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.rmi.port=11298 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=192.168.43.241
    # ports: # 端口
    #   - "12183:2181"
    #   - "28083:8080"
    #   - "11299:1099"
    #   - "11298:11298"
    volumes: # 挂载目录
      - ./zoo.cfg:/conf/zoo.cfg:ro
      - ./data3/data:/data:rw
      - ./data3/log:/logs:rw
    networks:
      - net.coms
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms


```

## 2.zoo.conf

```conf
tickTime=2000
dataDir=/data
clientPort=2181
admin.serverPort=8080
initLimit=5
syncLimit=2
server.1=coms.zookeeper.i1:2888:3888
server.2=coms.zookeeper.i2:2888:3888
server.3=coms.zookeeper.i3:2888:3888
4lw.commands.whitelist=*

```