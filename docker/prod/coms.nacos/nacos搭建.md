# nacos 搭建

https://github.com/nacos-group/nacos-docker

## 1.compose.yml

```yml

version: '3.9'
services:
  coms-nacos:
    image: nacos/nacos-server:v3.0.0
    container_name: coms.nacos
    env_file:
      - ./nacos-standalone-mysql.env
    # ports:
    #   - "8080:8080"
    #   - "8848:8848"
    #   - "9848:9848"
    networks:
      - net.coms
    volumes:
      - ./logs:/home/nacos/logs
    restart: always
networks:
  net.coms:
    driver: bridge
    external:
      name: net.coms
```

## 2.nacos-standalone-mysql.env

```ini
PREFER_HOST_MODE=hostname
MODE=standalone
SPRING_DATASOURCE_PLATFORM=mysql
MYSQL_SERVICE_HOST=coms.mysql
MYSQL_SERVICE_DB_NAME=nacos_db
MYSQL_SERVICE_PORT=3306
MYSQL_SERVICE_USER=root
MYSQL_SERVICE_PASSWORD=
MYSQL_SERVICE_DB_PARAM=characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true&useUnicode=true&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
NACOS_AUTH_IDENTITY_KEY=xxxxx
NACOS_AUTH_IDENTITY_VALUE=xxxxxx
NACOS_AUTH_TOKEN=base64xxx

```

## 3.初始化数据库

https://raw.githubusercontent.com/alibaba/nacos/develop/distribution/conf/mysql-schema.sql

```sql

/*
 * Copyright 1999-2018 Alibaba Group Holding Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/******************************************/
/*   表名称 = config_info                  */
/******************************************/
CREATE TABLE `config_info` (
                               `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
                               `data_id` varchar(255) NOT NULL COMMENT 'data_id',
                               `group_id` varchar(128) DEFAULT NULL COMMENT 'group_id',
                               `content` longtext NOT NULL COMMENT 'content',
                               `md5` varchar(32) DEFAULT NULL COMMENT 'md5',
                               `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                               `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
                               `src_user` text COMMENT 'source user',
                               `src_ip` varchar(50) DEFAULT NULL COMMENT 'source ip',
                               `app_name` varchar(128) DEFAULT NULL COMMENT 'app_name',
                               `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
                               `c_desc` varchar(256) DEFAULT NULL COMMENT 'configuration description',
                               `c_use` varchar(64) DEFAULT NULL COMMENT 'configuration usage',
                               `effect` varchar(64) DEFAULT NULL COMMENT '配置生效的描述',
                               `type` varchar(64) DEFAULT NULL COMMENT '配置的类型',
                               `c_schema` text COMMENT '配置的模式',
                               `encrypted_data_key` varchar(1024) NOT NULL DEFAULT '' COMMENT '密钥',
                               PRIMARY KEY (`id`),
                               UNIQUE KEY `uk_configinfo_datagrouptenant` (`data_id`,`group_id`,`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_info';

/******************************************/
/*   表名称 = config_info  since 2.5.0                */
/******************************************/
CREATE TABLE `config_info_gray` (
                                    `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT 'id',
                                    `data_id` varchar(255) NOT NULL COMMENT 'data_id',
                                    `group_id` varchar(128) NOT NULL COMMENT 'group_id',
                                    `content` longtext NOT NULL COMMENT 'content',
                                    `md5` varchar(32) DEFAULT NULL COMMENT 'md5',
                                    `src_user` text COMMENT 'src_user',
                                    `src_ip` varchar(100) DEFAULT NULL COMMENT 'src_ip',
                                    `gmt_create` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT 'gmt_create',
                                    `gmt_modified` datetime(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT 'gmt_modified',
                                    `app_name` varchar(128) DEFAULT NULL COMMENT 'app_name',
                                    `tenant_id` varchar(128) DEFAULT '' COMMENT 'tenant_id',
                                    `gray_name` varchar(128) NOT NULL COMMENT 'gray_name',
                                    `gray_rule` text NOT NULL COMMENT 'gray_rule',
                                    `encrypted_data_key` varchar(256) NOT NULL DEFAULT '' COMMENT 'encrypted_data_key',
                                    PRIMARY KEY (`id`),
                                    UNIQUE KEY `uk_configinfogray_datagrouptenantgray` (`data_id`,`group_id`,`tenant_id`,`gray_name`),
                                    KEY `idx_dataid_gmt_modified` (`data_id`,`gmt_modified`),
                                    KEY `idx_gmt_modified` (`gmt_modified`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='config_info_gray';

/******************************************/
/*   表名称 = config_tags_relation         */
/******************************************/
CREATE TABLE `config_tags_relation` (
                                        `id` bigint(20) NOT NULL COMMENT 'id',
                                        `tag_name` varchar(128) NOT NULL COMMENT 'tag_name',
                                        `tag_type` varchar(64) DEFAULT NULL COMMENT 'tag_type',
                                        `data_id` varchar(255) NOT NULL COMMENT 'data_id',
                                        `group_id` varchar(128) NOT NULL COMMENT 'group_id',
                                        `tenant_id` varchar(128) DEFAULT '' COMMENT 'tenant_id',
                                        `nid` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'nid, 自增长标识',
                                        PRIMARY KEY (`nid`),
                                        UNIQUE KEY `uk_configtagrelation_configidtag` (`id`,`tag_name`,`tag_type`),
                                        KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='config_tag_relation';

/******************************************/
/*   表名称 = group_capacity               */
/******************************************/
CREATE TABLE `group_capacity` (
                                  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                  `group_id` varchar(128) NOT NULL DEFAULT '' COMMENT 'Group ID，空字符表示整个集群',
                                  `quota` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
                                  `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
                                  `max_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
                                  `max_aggr_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数，，0表示使用默认值',
                                  `max_aggr_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
                                  `max_history_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
                                  `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                  `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
                                  PRIMARY KEY (`id`),
                                  UNIQUE KEY `uk_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='集群、各Group容量信息表';

/******************************************/
/*   表名称 = his_config_info              */
/******************************************/
CREATE TABLE `his_config_info` (
                                   `id` bigint(20) unsigned NOT NULL COMMENT 'id',
                                   `nid` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'nid, 自增标识',
                                   `data_id` varchar(255) NOT NULL COMMENT 'data_id',
                                   `group_id` varchar(128) NOT NULL COMMENT 'group_id',
                                   `app_name` varchar(128) DEFAULT NULL COMMENT 'app_name',
                                   `content` longtext NOT NULL COMMENT 'content',
                                   `md5` varchar(32) DEFAULT NULL COMMENT 'md5',
                                   `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                   `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
                                   `src_user` text COMMENT 'source user',
                                   `src_ip` varchar(50) DEFAULT NULL COMMENT 'source ip',
                                   `op_type` char(10) DEFAULT NULL COMMENT 'operation type',
                                   `tenant_id` varchar(128) DEFAULT '' COMMENT '租户字段',
                                   `encrypted_data_key` varchar(1024) NOT NULL DEFAULT '' COMMENT '密钥',
                                   `publish_type` varchar(50)  DEFAULT 'formal' COMMENT 'publish type gray or formal',
                                   `gray_name` varchar(50)  DEFAULT NULL COMMENT 'gray name',
                                   `ext_info`  longtext DEFAULT NULL COMMENT 'ext info',
                                   PRIMARY KEY (`nid`),
                                   KEY `idx_gmt_create` (`gmt_create`),
                                   KEY `idx_gmt_modified` (`gmt_modified`),
                                   KEY `idx_did` (`data_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='多租户改造';


/******************************************/
/*   表名称 = tenant_capacity              */
/******************************************/
CREATE TABLE `tenant_capacity` (
                                   `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键ID',
                                   `tenant_id` varchar(128) NOT NULL DEFAULT '' COMMENT 'Tenant ID',
                                   `quota` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '配额，0表示使用默认值',
                                   `usage` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '使用量',
                                   `max_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个配置大小上限，单位为字节，0表示使用默认值',
                                   `max_aggr_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '聚合子配置最大个数',
                                   `max_aggr_size` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '单个聚合数据的子配置大小上限，单位为字节，0表示使用默认值',
                                   `max_history_count` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '最大变更历史数量',
                                   `gmt_create` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                   `gmt_modified` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '修改时间',
                                   PRIMARY KEY (`id`),
                                   UNIQUE KEY `uk_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='租户容量信息表';


CREATE TABLE `tenant_info` (
                               `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
                               `kp` varchar(128) NOT NULL COMMENT 'kp',
                               `tenant_id` varchar(128) default '' COMMENT 'tenant_id',
                               `tenant_name` varchar(128) default '' COMMENT 'tenant_name',
                               `tenant_desc` varchar(256) DEFAULT NULL COMMENT 'tenant_desc',
                               `create_source` varchar(32) DEFAULT NULL COMMENT 'create_source',
                               `gmt_create` bigint(20) NOT NULL COMMENT '创建时间',
                               `gmt_modified` bigint(20) NOT NULL COMMENT '修改时间',
                               PRIMARY KEY (`id`),
                               UNIQUE KEY `uk_tenant_info_kptenantid` (`kp`,`tenant_id`),
                               KEY `idx_tenant_id` (`tenant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin COMMENT='tenant_info';

CREATE TABLE `users` (
                         `username` varchar(50) NOT NULL PRIMARY KEY COMMENT 'username',
                         `password` varchar(500) NOT NULL COMMENT 'password',
                         `enabled` boolean NOT NULL COMMENT 'enabled'
);

CREATE TABLE `roles` (
                         `username` varchar(50) NOT NULL COMMENT 'username',
                         `role` varchar(50) NOT NULL COMMENT 'role',
                         UNIQUE INDEX `idx_user_role` (`username` ASC, `role` ASC) USING BTREE
);

CREATE TABLE `permissions` (
                               `role` varchar(50) NOT NULL COMMENT 'role',
                               `resource` varchar(128) NOT NULL COMMENT 'resource',
                               `action` varchar(8) NOT NULL COMMENT 'action',
                               UNIQUE INDEX `uk_role_permission` (`role`,`resource`,`action`) USING BTREE
);

```

## 4.Nginx 配置

`nacos.hello.work.conf`

```
server {

    listen 443 ssl;
    server_name nacos.hello.work;

    ssl_certificate     certs/server-nacos.hello.work.fullchain.pem;
    ssl_certificate_key certs/nacos.hello.work.key.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://coms.nacos:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
    }
}
```