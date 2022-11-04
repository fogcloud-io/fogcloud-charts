# fogcloud-charts
[![standard-readme compliant](https://img.shields.io/badge/licence-Apache%202.0-blue)](https://www.apache.org/licenses/LICENSE-2.0) [![standard-readme compliant](https://img.shields.io/static/v1?label=official&message=demo&color=<COLOR>)](https://app.fogcloud.io)

[FogCloud](https://fogcloud.io) 是一个一站式云原生物联网平台。

## 安装前准备

- [安装 kubernetes](https://docs.k3s.io/installation) 1.19+ 
- [安装并设置 kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) 1.19+
- [安装 helm](https://helm.sh/docs/intro/install/) 3+
- [使用helm安装 fission](https://fission.io/docs/installation/#with-helm)

## 获取chart

```console
helm repo add fogcloud-charts https://fogcloud-io.github.io/fogcloud-charts
helm repo update
helm pull fogcloud-charts/fogcloud-charts --untar
```
运行后在当前目录会生成fogcloud-charts文件夹

## 安装chart
1. 拷贝fogcloud-charts目录的values.yaml文件，并命名为myvalues.yaml
2. 编辑myvalues.yaml文件，参考配置项说明：
3. 安装fogcloud-charts
```console
kubectl create namespace {NAMESPACE_NAME}
helm install -f myvalues.yaml {RELEASE_NAME} --set namespace={NAMESPACE_NAME} ./fogcloud-charts
```
4. 升级fogcloud-charts
```console
helm upgrade -f myvalues.yaml {RELEASE_NAME} ./fogcloud-charts
```

配置说明：
| 配置项 | 类型 | 说明 |
| --- | --- | --- |
| k8sApiServer | string | k8s server api地址，用来创建k8s StatefulSet资源；可以通过```kubectl config view```获取 |
| ingress.hosts.webAdmin | string | 使用ingress方式发布对外服务时，用于设置管理后台域名 |
| ingress.hosts.api | string | 使用ingress方式发布对外服务时，用于设置后端api服务域名 |
| ingress.tls.enabled | bool | 是否启用ingress tls |
| ingress.tls.webAdmin.createWithCertFile | bool | 是否使用证书文件创建管理后台web服务的sercret对象；若为true，可将*.crt（证书）, *.key（密钥）文件放到fogcloud-charts/configs/cert/webAdmin目录下 |
| mqttBroker.enabled | bool | 是否使用k8s创建mqtt broker |
| mqttBroker.tls.enabled | bool | mqtt应用是否启用tls |
| mqttBroker.tls.createWithCertFile | bool | 是否使用证书文件创建mqtt应用的sercret对象，启用mqttBroker.tls时有效；若为true，可将*.crt（证书）, *.key（密钥）文件放到fogcloud-charts/configs/cert/mqtt目录下 | 
| rabbitmq.enabled | bool | 是否使用k8s创建rabbitmq |
| rabbitmq.tls.enabled | bool | rabbitmq是否启用tls |
| rabbitmq.tls.createWithCertFile | bool | 是否使用证书文件创建rabbitmq的sercret对象，启用rabbitmq.tls时有效；若为true，可将*.crt（证书）, *.key（密钥）文件放到fogcloud-charts/configs/cert/amqp目录下 | 
| postgres.enabled | bool | 是否使用k8s创建postgresql应用（生产环境建议单独部署数据库应用） |
| mongodb.enabled | bool | 是否使用k8s创建mongodb应用 |
| redis.enabled | bool | 是否使用k8s创建redis应用 |
| etcd.enabled | bool | 是否使用k8s创建etcd |
| minio.enabled | bool | 是否使用k8s创建minio |


## 卸载chart

```console
helm uninstall {RELEASE_NAME}
```

## 使用许可

[Apache 2.0 License](https://github.com/fission/.github/blob/main/LICENSE).