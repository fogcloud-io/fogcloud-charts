# fogcloud-charts
[![standard-readme compliant](https://img.shields.io/badge/licence-Apache%202.0-blue)](https://www.apache.org/licenses/LICENSE-2.0) [![standard-readme compliant](https://img.shields.io/static/v1?label=official&message=demo&color=<COLOR>)](https://app.fogcloud.io)

[FogCloud](https://fogcloud.io) is a cloud native IoT PaaS.

## Prerequisites

- [install kubernetes](https://docs.k3s.io/installation) 1.19+ 
- [install and set up kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) 1.19+
- [install helm](https://helm.sh/docs/intro/install/) 3+
- [install fission with helm](https://fission.io/docs/installation/#with-helm)

## Get repo

```console
helm repo add fogcloud-charts https://fogcloud-io.github.io/fogcloud-charts
helm repo update
helm pull fogcloud-charts/fogcloud-charts --untar
```

## Install Chart

1. cp fogcloud-charts/values.yaml ./myvalues.yaml
2. edit myvalues.yaml
3. install fogcloud-charts
```console
helm install -f myvalues.yaml ${RELEASE_NAME} -n ${NAMESPACE_NAME} ./fogcloud-charts
```
4. upgrade fogcloud-charts
```console
helm upgrade -f myvalues.yaml ${RELEASE_NAME} -n ${NAMESPACE_NAME} ./fogcloud-charts 
```

## Uninstall Chart

```console
helm uninstall ${RELEASE_NAME} -n ${NAMESPACE_NAME}
```

## Configuration

| Parameter | Description | Default |
| --- | --- | --- |
| `environment` | 配置文件的环境 | `production` |
| `imagePullPolicy` | 镜像拉取策略 | `Always` | 
| `k8sApiServer` | k8s server api地址，用来创建k8s StatefulSet资源；可以通过`kubectl config view`获取 | `https://localhost:6443` |
| `fissionEnabled` | 是否启用了云函数功能 | `false` |
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
| **fogcloud** | api服务相关配置 | |
| `fogcloud.restartPolicy` | pod重启策略：`Always` | `Always` |
| `fogcloud.image` | 镜像地址 | `ghcr.io/fogcloud-io/fogcloud` | 
| `fogcloud.imageTag` | 镜像版本 | `v4.13.0` |
| `fogcloud.replicas` | deployment复制节点数量 | `3` |
| `fogcloud.strategy.type` | 应用更新策略：`RollingUpdate`，`Recreate`；1）`RollingUpdate`滚动更新；2）`Recreate`重启更新 | `RollingUpdate` |
| `fogcloud.strategy.rollingUpdate.maxSurge` | 应用更新时最大新版本pod新增数量比例| `50%` |
| `fogcloud.strategy.rollingUpdate.maxUnavailable` | 应用更新时的最大不可用pod数量 | `0` |
| **faasbuilder** | | |
| `faasbuilder.createDockerconfigWithFile` | 使用文件创建dockerconfig对象 | `false` |
| **mqttBroker** | | |
| `mqttBroker.internal.enabled` | 是否使用k8s创建mqtt broker | `true` |
| `mqttBroker.internal.nodeSelector.enabled` | 是否启用pod节点选择 | `false` |
| `mqttBroker.internal.nodeSelector.key` | k8s节点名 | |   
| `mqttBroker.internal.tls.enabled` | mqtt应用是否启用tls  | |
| `mqttBroker.internal.tls.createWithCertFile` | 是否使用证书文件创建mqtt应用的sercret对象，启用mqttBroker.internal.tls时有效；若为true，可将*.crt（证书）, *.key（密钥）文件放到fogcloud-charts/configs/cert/mqtt目录下 |  | 
| **rabbitmq** | | |
| `rabbitmq.enabled `| 是否使用k8s创建rabbitmq |  |
| `rabbitmq.tls.enabled` | rabbitmq是否启用tls |  |
| `rabbitmq.tls.createWithCertFile` | 是否使用证书文件创建rabbitmq的sercret对象，启用rabbitmq.tls时有效；若为true，可将*.crt（证书）, *.key（密钥）文件放到fogcloud-charts/configs/cert/amqp目录下 |  | 
| **postgres** | | |
| `postgres.enabled` | 是否使用k8s创建postgresql应用（生产环境不建议使用容器部署） |`true` | 
| **mongodb** | | |
| `mongodb.enabled` | 是否使用k8s创建mongodb应用 （生产环境不建议使用容器部署）| `true`| 
| **redis** | | |
| `redis.enabled` | 是否使用k8s创建redis应用（生产环境不建议使用容器部署）|`true` | 
| **etcd** | | |
| `etcd.enabled` | 是否使用k8s创建etcd（生产环境不建议使用容器部署） |`true` | 
| **minio** | | |
| `minio.enabled` | 是否使用k8s创建minio（生产环境不建议使用容器部署） | `true` |

## Licence

[Apache 2.0 License](https://github.com/fission/.github/blob/main/LICENSE).
