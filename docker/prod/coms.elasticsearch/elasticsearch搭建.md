# elasticsearch 搭建

```yml
version: '3.9'
services:
  coms-es:
    image: elasticsearch:8.18.1
    container_name: coms.es
    # ports:
    #   - '9201:9200'
    #   - '9301:9300'
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=true
      - xpack.security.transport.ssl.enabled=true
      - xpack.security.http.ssl.enabled=false
      - ELASTIC_PASSWORD=changeme
    networks:
      - net.coms
    volumes:
      - es_data:/usr/share/elasticsearch/data
      - es_config:/usr/share/elasticsearch/config
      - es_logs:/usr/share/elasticsearch/logs
      - es_plugins:/usr/share/elasticsearch/plugins
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms
volumes:
  es_data:
  es_config:
  es_logs:
  es_plugins:
```