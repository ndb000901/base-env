# sentinel 搭建

## 1.compose.yml

```yml
version: '3.9'
services:
  coms-sentinel:
    image: bladex/sentinel-dashboard:1.8.8
    container_name: coms.sentinel
    # ports:
    #   - "8080:8080"
    #   - "8848:8848"
    #   - "9848:9848"
    networks:
      - net.coms
    restart: always
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms
```