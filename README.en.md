# fogcloud-charts
[![standard-readme compliant](https://img.shields.io/badge/licence-Apache%202.0-blue)](https://www.apache.org/licenses/LICENSE-2.0) [![standard-readme compliant](https://img.shields.io/static/v1?label=official&message=demo&color=<COLOR>)](https://app.fogcloud.io)

[中文](readme.md) | English

[FogCloud](https://fogcloud.io) is a cloud native IoT PaaS.

## Prerequisites

- [install kubernetes](https://docs.k3s.io/installation) 1.19+ 
- [install and set up kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) 1.19+
- [install helm](https://helm.sh/docs/intro/install/) 3+

## Get repo

```console
helm repo add fogcloud-charts https://fogcloud-io.github.io/fogcloud-charts
helm repo update
helm pull fogcloud-charts/fogcloud --untar
helm pull fogcloud-charts/fission-all --untar
```

## Install Chart

1. cp fogcloud-charts/values.yaml ./myvalues.yaml
2. edit myvalues.yaml
3. install fission
```console
helm install fission ./fission-all -n fission
```
4. install emqx-operator
```console
helm upgrade --install emqx-operator ./emqx-operator -n emqx-operator --create-namespace
```
5. install fogcloud-charts
```console
export NAMESPACE_NAME=fogcloud
export RELEASE_NAME=fogcloud
kubectl create namespace ${NAMESPACE_NAME}
kubectl apply -f ./fogcloud/operator/rabbitmq-cluster-operator.yaml
helm install -f myvalues.yaml ${RELEASE_NAME} -n ${NAMESPACE_NAME} ./fogcloud
```
6. upgrade fogcloud-charts
```console
helm upgrade -f myvalues.yaml ${RELEASE_NAME} -n ${NAMESPACE_NAME} ./fogcloud 
```

## Uninstall Chart

```console
helm uninstall ${RELEASE_NAME} -n ${NAMESPACE_NAME}
helm uninstall fission -n fission
kubectl delete -f ./fogcloud/operator/rabbitmq-cluster-operator.yaml
```

## Configuration

| Parameter | Description | Default |
| --- | --- | --- |
| `environment` | 配置文件的环境 | `production` |
| `imagePullPolicy` | 镜像拉取策略 | `Always` | 
| `k8sApiServer` | k8s server api地址，用来创建k8s StatefulSet资源；可以通过`kubectl config view`获取 | `https://localhost:6443` |
| `fissionEnabled` | 是否启用了云函数功能 | `false` |
| `cloudGatewayEnabled` | 是否启用云网关功能 | `true` |
| `tdengineEnabled` | 是否启用tdengine历史数据存储功能 | `true` |
| `telemetryEnabled` | 是否启用遥测功能 | `true` |
| **expose** | | | 
| `expose.type` | 如何暴露服务：`Ingress`、`ClusterIP`、`NodePort`或`LoadBalancer`，其他值将被忽略，服务的创建将被跳过。| `ClusterIP` |
| `expose.insecureOSS` | 不安全的oss下载 | `true` | 
| `expose.hosts.api` | api服务域名，用于前端服务访问后端api | `localhost` | 
| `expose.hosts.mqtt` | mqtt服务域名，用于前端服务访问mqtt-websocket服务 | `localhost` | 
| `expose.tls.enabled` | 是否启用ingress tls | `false` |
| `expose.tls.cert.api.certSource` | api服务证书的来源：`file`, `auto`或`none`；1）`file`：使用证书文件，直接将*.key和*.crt文件放入fogcloud-charts/config/cert/api目录下；2）`auto`：使用cert-manager生成免费证书，需要保证设置的域名可用；3）`none`：不为服务入口配置证书 | `none` |
| `expose.tls.cert.api.secretName` | api服务所用证书对应的k8s secret资源名 | `fogcloud-api` |
| `expose.tls.cert.api.dnsName` | 当`expose.tls.cert.api.certSource`=`auto`时，用于cert-manage生成x509证书 | `fogcloud-api` |
| `expose.tls.cert.webAdmin.certSource` | web服务证书的来源：`file`, `auto`或`none`；1）`file`：使用证书文件，直接将*.key和*.crt文件放入fogcloud-charts/config/cert/api目录下；2）`auto`：使用cert-manager生成免费证书，需要保证设置的域名可用；3）`none`：不为服务入口配置证书 | `none` |
| `expose.tls.cert.webAdmin.secretName` | web服务所用证书对应的k8s secret资源名 | `fogcloud-web` |
| `expose.tls.cert.webAdmin.dnsName` | 当`expose.tls.cert.webAdmin.certSource`=`auto`时，用于cert-manage生成x509证书 | `fogcloud-api` |
| `expose.Ingress` | `expose.type`设置为Ingress时才需要设置 | |
| `expose.Ingress.className` | ingress class资源名| `traefik` |
| `expose.Ingress.controller` | ingress controller类型 | `traefik.io/ingress-controller` |
| `expose.Ingress.annotations` | ingress注释，可以用来设置ingress部分参数 | `{}` |
| `expose.Ingress.hosts.webAdmin` | web服务域名，用于ingress路由 | `localhost` |
| `expose.Ingress.hosts.api` | api服务域名，用于ingress路由 | `localhost` |
| `expose.NodePort` |  |  |
| `expose.NodePort.externalTrafficPolicy` | 流量策略：`Cluster`或`Local`；1）`Cluster`：流量可以转发到其他k8s节点的pod，2）`Local`：流量只转发给本机的pod| `Local` | 
| `expose.NodePort.ports.webAdmin.httpPort` | web服务的NodePort端口，可用于外网暴露web服务 | `8888` |
| `expose.NodePort.ports.api.httpPort` | api服务的NodePort端口，可用于外网暴露api服务 | `8000` |
| `expose.LoadBalancer` | | |
| `expose.LoadBalancer.externalTrafficPolicy` | 流量策略：`Cluster`或`Local`；1）`Cluster`：流量可以转发到其他k8s节点的pod，2）`Local`：流量只转发给本机的pod | `Local` |
| `expose.LoadBalancer.ports.webAdmin.healthCheckNodePort` | 健康检查端口，用于外部slb检测web服务是否正常运行 | `8880` |
| `expose.LoadBalancer.ports.api.healthCheckNodePort` | 健康检查端口，用于外部slb检测api服务是否正常运行 | `8880` |
| **secret** | | |
| `secret.imageCredentials` | 配置私有镜像仓库源 | |
| `secret.imageCredentials[].registry` | 私有镜像仓库地址 | `""` | 
| `secret.imageCredentials[].name` | k8s dockerconfigjson secret名称 | `""` | 
| `secret.imageCredentials[].username` | 私有镜像仓库用户名 | `""` |
| `secret.imageCredentials[].password`| 私有镜像仓库密码 | `""` |
| `storageClassName` |  | `local-path` |
| **fogcloud** | fogcloud-core服务相关配置 | |
| `fogcloud.config` | fogcloud-core配置设置，参考`configs/fogcloud-core/fogcloud.example.yaml`配置文件 | `{}` |
| `fogcloud.restartPolicy` | pod重启策略：`Always` | `Always` |
| `fogcloud.image` | 镜像地址 | `ghcr.io/fogcloud-io/fogcloud` | 
| `fogcloud.imageTag` | 镜像版本 | `v4.13.0` |
| `fogcloud.replicas` | deployment复制节点数量 | `3` |
| `fogcloud.strategy.type` | 应用更新策略：`RollingUpdate`，`Recreate`；1）`RollingUpdate`滚动更新；2）`Recreate`重启更新 | `RollingUpdate` |
| `fogcloud.strategy.rollingUpdate.maxSurge` | 应用更新时最大新版本pod新增数量比例| `50%` |
| `fogcloud.strategy.rollingUpdate.maxUnavailable` | 应用更新时的最大不可用pod数量 | `0` |
| **fogcloudWeb** | fogcloud-web服务相关配置 | |
| `fogcloudWeb.restartPolicy` | pod重启策略：`Always` | `Always` |
| `fogcloudWeb.image` | 镜像地址 | `ghcr.io/fogcloud-io/fogcloud` | 
| `fogcloudWeb.imageTag` | 镜像版本 | `v4.13.0` |
| `fogcloudWeb.replicas` | deployment复制节点数量 | `3` |
| `fogcloudWeb.envVars` | fogcloud-web环境变量 | `[{"name":"MAP_CONFIG","value": "china"},{"name":"DEPLOYMENT_CONFIG", "value":"public"},{"name":"GATEWAY_CLOUD_STATUS","value":"true"},{"name":"GLOB_APPLIANCE_STATUS","value":"true"},{"name":"GLOB_TOPIC_PREFIX","value":"fogcloud"}]` |
| `fogcloudWeb.strategy.type` | 应用更新策略：`RollingUpdate`，`Recreate`；1）`RollingUpdate`滚动更新；2）`Recreate`重启更新 | `RollingUpdate` |
| `fogcloudWeb.strategy.rollingUpdate.maxSurge` | 应用更新时最大新版本pod新增数量比例| `50%` |
| `fogcloudWeb.strategy.rollingUpdate.maxUnavailable` | 应用更新时的最大不可用pod数量 | `0` |
| **faasbuilder** | | |
| `faasbuilder.config` | faasbuilder相关配置，参考`configs/faasbuilder/faasbuilder.yaml`配置文件 | `{}` |
| `faasbuilder.createKubeconfigWithFile` | 使用文件创建`kubeconfig`对象，用于创建云函数；若启用可将kubeconfig文件放到`fogcloud/configs/kubeconfig`目录下，并删除该目录的kubeconfig-demo文件 | `false` |
| **mqttBroker** | | |
| `mqttBroker.type` | mqtt-broker创建方式：`internal`，`external`；1）`internal`：使用helm自动创建；2）`external`：使用外部的mqtt-broker | `internal` |
| `mqttBroker.internal.type` | mqtt-broker类型选择，默认`emqx`，不建议修改 | `emqx` |
| `mqttBroker.internal.image` | mqtt-broker镜像 | `emqx/emqx` |
| `mqttBroker.internal.imageTag` | mqtt-broker镜像版本 | `4.2.8` |
| `mqttBroker.internal.persistence` | | |
| `mqttBroker.internal.persistence.pvcExisted` | 是否使用已存在的pvc | `false`|
| `mqttBroker.internal.persistence.pvc` | pvc名称 | `emqx-pvc` |
| `mqttBroker.internal.persistence.storageClassName` | pvc绑定的`stogrageClassName` | `local-path` |
| `mqttBroker.internal.nodeSelector.enabled` | 是否启用pod节点选择 | `false` |
| `mqttBroker.internal.nodeSelector.key` | k8s节点名 | |   
| `mqttBroker.internal.tls.enabled` | mqtt应用是否启用tls  | |
| `mqttBroker.internal.tls.createWithCertFile` | 是否使用证书文件创建mqtt应用的sercret对象，启用mqttBroker.internal.tls时有效；若为true，可将*.crt（证书）, *.key（密钥）文件放到fogcloud/configs/cert/mqtt目录下 |  | 
| **rabbitmq** | | |
| `rabbitmq.type `| rabbitmq创建方式：`internal`，`external`；1）`internal`：使用helm自动创建；2）`external`：使用外部的rabbitmq | `internal` |
| `rabbitmq.internal.tls.enabled` | rabbitmq是否启用tls |  |
| `rabbitmq.internal.tls.createWithCertFile` | 是否使用证书文件创建rabbitmq的sercret对象，启用rabbitmq.tls时有效；若为true，可将*.crt（证书）, *.key（密钥）文件放到fogcloud-charts/configs/cert/amqp目录下 |  | 
| **postgres** | | |
| `postgres.type` | 如果使用外部的`postgres`，设置为`external` |`internal` | 
| **mongodb** | | |
| `mongodb.type` | 如果使用外部的`mongodb`，设置为`external`| `internal`| 
| **redis** | | |
| `redis.type` | 如果使用外部的`redis`，设置为`external` |`internal` | 
| **etcd** | | |
| `etcd.type` | 如果使用外部的`etcd`，设置为`external` |`internal` | 
| **minio** | | |
| `minio.type` | 如果使用外部的`minio`，设置为`external` | `internal` |

## Licence

[Apache 2.0 License](https://github.com/fission/.github/blob/main/LICENSE).
