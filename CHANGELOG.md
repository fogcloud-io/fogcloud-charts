# Changelog

## v2.0.0

### New Features
- 增加`nats`集群charts，应用版本为`v2.10.4`
- 增加`etcd`集群charts，应用版本为`v3.5.10`
- 增加`minio`集群charts
- 增加`tdengine`部署脚本，集群部署有Bug，目前只能单机部署
- 增加`fognotifier`部署脚本和配置文件
- 增加`mqttwebhook`部署脚本和配置文件
- 增加`fogthinghistory`部署脚本和配置文件

###  Breaking Changes
- `etcd`和`minio`从原本的单体应用迁移至集群时，需要进行数据迁移
- `fogcloud`配置文件改动：增加nats配置项；调整`http listen port`配置项
- `emqx`的`webhook`插件配置文件改动：`webhook`地址指向`mqttwebhook`
- 原有的单节点`etcd1`应用的serviceName从`etcd1`改为`fogcloud-etcd`
- `fogcloud`的网络新增grpc 4001端口，原有的15000端口targetPort由4001改为15000
- `fogcloud-web`的API_BASE_URL环境变量删除`/api/v1`后缀

### Changes
- `nginx`配置文件改动：增加`fognotifier`和`fogthinghistory`API的反向代理


## v2.1.0

### New Features
- 增加fogcloud-core的topics配置
- fogcloud-web增加环境变量`GLOB_TOPIC_PREFIX`，用来设置前端订阅的topic前缀


## v2.2.0

### New Features
- 增加`emqx-operator`配置
- 增加`emqx`配置

### Breaking Changes
- fogcloud-core的`MQTT_BROKER_TCP_PORT`配置在`emqx5.6`中默认设置为1880，`emqx4.x`中默认设置为1883
- fogcloud-core的`MQTT_BROKER_API_PORT`配置在emqx5.6中默认设置为18083，`emqx4.x`中默认设置为8081
- fogcloud-core的`MQTT_BROKER_HOST`配置在`emqx5.6`中默认设置为`emqx-listeners`，`emqx4.x`中默认设置为`mqtt-broker`
- fogcloud-core的`MQTT_BROKER_TYPE`配置在`emqx5.6`中默认设置为`emqx_v5`，`emqx4.x`中默认设置为`emqx`
- `emqx5.6`的http api鉴权使用`emqx.appKey`和`emqx.appSecret`

## 2.2.1

### Bug Fixes
- 修复rabbitmq service配置错误

## 2.2.2

### New Features
- 支持affinity配置
- 支持tolerations配置

### Bug Fixes
- 修复config merge

## 2.2.3 

### Breaking Changes
- nats默认配置调整：仓库及镜像版本，消息映射