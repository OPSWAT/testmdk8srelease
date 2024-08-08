
MetaDefender Software Supply Chain
===========

This is a Helm chart for deploying MetaDefender Software Supply Chain (https://docs.opswat.com/mdssc/installation/kubernetes-deployment) in a Kubernetes cluster

This chart can deploy the following depending on the provided values:
- All MDSSC services in separate pods 
- A MongoDB database instance pre-configured to be used by MDSSC

In addition to the chart, we also provide a number of values files for specific scenarios:
- mdssc-aws-eks-values.yml - for deploying in an AWS environment using Amazon EKS
- mdssc-azure-aks-values.yml - for deploying in an Azure environment using AKS

## Installation

### From source
MDSSC can be installed directly from the source code, here's an example using the generic values:
```console
git clone https://github.com/OPSWAT/metadefender-k8s.git metadefender
cd metadefender/helm_carts
helm install my_mdssc ./mdssc
```

### From the GitHub helm repo
The installation can also be done using the helm repo which is updated on each release:
 ```console
helm repo add mdk8s https://opswat.github.io/metadefender-k8s/
helm repo update mdk8s
helm install my_mdssc mdk8s/metadefender_software_supply_chain
```

### Flexible deployment
By default, the helm chart deploys MDSSC with support for multiple vendors.

## Operational Notes
The entire deployment can be customized by overwriting the chart's default configuration values. Here are a few point to look out for when changing these values:
- By default, a MongoDB database is deployed alongside the MDSSC deployment
- In a production environment it's recommended to use an external service for the database  and set `deploy_with_mdssc_db` to false in order to not deploy an in-cluster database
- By default, when accessing the MDSSC web interface for the first time, the user onboarding process is presented and the initial credentials must be set. To skip this and have a preconfigured user and an initial setup, the following values can be set:
```yaml
# Auto onboarding settings
auto_onboarding: true                  # If set to true, it will deploy a container that will do the initial setup automatically if correct values are provided
mdssc_import_config: null                # Content of config file to be imported by the onboarding container
ONBOARDING_USER_NAME: null              # User name of user that will be created by onboarding container (defaults to admin if left unset)
ONBOARDING_PASSWORD: null               # Password of user that will be created by onboarding container (randomly generated if left unset, can be retrieved from the "onboarding-env" secret)
ONBOARDING_EMAIL: null                  # Email of user that will be created by onboarding container
ONBOARDING_FULL_NAME: null              # Full name of user that will be created by onboarding container
```

## Configuration

The following table lists the configurable parameters of the Metadefender for secure storage chart and their default values.

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `MONGO_URL` | MongoDB connection string, this should be set only when using a remote database service | `"mongodb://mongodb:27017/MDCS"` |
| `MONGO_MIGRATIONS_HOST` |  | `"mongomigrations"` |
| `MONGO_MIGRATIONS_PORT` |  | `27777` |
| `RABBITMQ_HOST` |  | `"rabbitmq"` |
| `RABBITMQ_PORT` |  | `5672` |
| `APIGATEWAY_PORT` |  | `8005` |
| `APIGATEWAY_PORT_SSL` |  | `8006` |
| `WEB_PORT` | HTTP port for the MDSSC service | `80` |
| `WEB_PORT_SSL` | HTTPS port for the MDSSC service | `443` |
| `NGINX_TIMEOUT` | Sets a custom timeout | `300` |
| `BACKUPS_TO_KEEP` |  | `3` |
| `LICENSINGSERVICE_HOST` |  | `"licensingservice"` |
| `LICENSINGSERVICE_URL` |  | `"http://licensingservice"` |
| `LICENSINGSERVICE_PORT` |  | `5000` |
| `SMBSERVICE_URL` |  | `"http://smbservice"` |
| `SMBSERVICE_PORT` |  | `5002` |
| `RABBITMQ_SCANNING_PREFETCH_COUNT` |  | `20` |
| `CORE_INCLUDED` |  | `"no"` |
| `CORE_VERSION` |  | `"v4.17.1-1"` |
| `CORE_PORT` |  | `35000` |
| `HTTPS_ACTIVE` |  | `"no"` |
| `MAC_ADDRESS` |  | `"02:42:ac:11:ff:ff"` |
| `HOSTNAME` |  | `"mds_host"` |
| `BRANCH` | Sets a custom MDSSC branch for testing/preview versions, this value should be set to stable for production use | `"stable"` |
| `LOG_LEVEL` |  | `4` |
| `APP_LOG_LEVEL` |  | `"INFORMATION"` |
| `SMB_SHORT_DEADLINE` |  | `5` |
| `SMB_LONG_DEADLINE` |  | `30` |
| `POLLY_RETRY_COUNT` |  | `3` |
| `POLLY_LONG_RETRY` |  | `5` |
| `POLLY_SHORT_RETRY` |  | `1` |
| `SMB_UPLOAD_CHUNK` |  | `2` |
| `SMBSERVICE_FOLLOW_SYMLINKS` |  | `0` |
| `DISCOVERY_SERVICE_PERFORMANCE_OPTIMIZATION` |  | `0` |
| `DISCOVERY_SERVICE_DEGREE_OF_PARALLELISM` |  | `10` |
| `DISCOVERY_SERVICE_SMB_RTP_PROCESS_HANDLING` |  | `0` |
| `MD_CORE_CERTIFICATE_VALIDATION` |  | `0` |
| `POLLY_LONG_RETRY_BOX` |  | `2` |
| `POLLY_SHORT_RETRY_BOX` |  | `1` |
| `POLLY_POST_ACTION_RETRY_TIME` |  | `30` |
| `LOAD_BALANCER_MD_CORE_UNAVAILABLE_TIME` |  | `5` |
| `WEBCLIENT_HOST` |  | `"webclient"` |
| `deploy_with_mdssc_db` | Enable or disable the local in-cluster database, set to false when deploying with an external database service | `true` |
| `persistance_enabled` |  | `true` |
| `storage_provisioner` |  | `"hostPath"` |
| `storage_name` |  | `"hostPath"` |
| `storage_node` |  | `"minikube"` |
| `hostPathPrefix` | If `deploy_with_mdssc_db` is set to true, this is the absolute path on the node where to keep the database filesystem for persistance | `"mdssc-storage"` |
| `environment` | Deployment environment type, the default `generic` value will not configure or provision any additional resources in the cloud provider (like load balancers), other values: `aws_eks_fargate` | `"generic"` |
| `install_alb` | If set to true and `environment` is set to `aws_eks_fargate`, an ALB ingress controller will be installed | `true` |
| `eks_cluster_name` | Name of the EKS cluster, mandatory only if `environment` is set to `aws_eks_fargate` | `null` |
| `vpc_id` | ID of the AWS VPC, mandatory only if `environment` is set to `aws_eks_fargate` | `null` |
| `aws_region` | AWS region code, mandatory only if `environment` is set to `aws_eks_fargate` | `null` |
| `AWS_ACCESS_KEY_ID` | AWS access key id, mandatory only if `environment` is set to `aws_eks_fargate` | `null` |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key, mandatory only if `environment` is set to `aws_eks_fargate` | `null` |
| `app_name` | Application name, it also sets the namespace on all created resources and replaces `<APP_NAME>` in the ingress host (if the ingress is enabled) | `"default"` |
| `mdssc_ingress.host` | Hostname for the publicly accessible ingress, the `<APP_NAME>` string will be replaced with the `app_name` value | `"<APP_NAME>-mdssc.k8s"` |
| `mdssc_ingress.service` | Service name where the ingress should route to, this should be left unchanged | `"webclient"` |
| `mdssc_ingress.port` | Port where the ingress should route to | `80` |
| `mdssc_ingress.enabled` | Enable or disable the ingress creation | `false` |
| `mdssc_ingress.class` | Sets the ingress class | `"nginx"` |
| `mdssc_docker_repo` |  | `"opswat"` |
| `mdssc_config_map_env_name` |  | `"mdssc-env"` |
| `mdsscHostAliases` | Custom hosts entries | `[{"ip": "10.0.1.16", "hostnames": ["s3-us-west-1.cloudian-sf", "test.s3-us-west-1.cloudian-sf", "small.s3-us-west-1.cloudian-sf"]}]` |
| `mdssc_components.mongodb.name` |  | `"mongodb"` |
| `mdssc_components.mongodb.image` |  | `"mongo:3.6"` |
| `mdssc_components.mongodb.ports` |  | `[{"port": 27017}]` |
| `mdssc_components.mongodb.persistentDir` |  | `"/data/db"` |
| `mdssc_components.mongodb.is_db` |  | `true` |
| `mdssc_components.mongomigrations.name` |  | `"mongomigrations"` |
| `mdssc_components.mongomigrations.custom_repo` |  | `true` |
| `mdssc_components.mongomigrations.image` |  | `"mdcloudservices_mongo-migrations"` |
| `mdssc_components.mongomigrations.ports` |  | `[{"port": 27777}]` |
| `mdssc_components.mongomigrations.persistentDir` |  | `"/backup"` |
| `mdssc_components.rabbitmq.name` |  | `"rabbitmq"` |
| `mdssc_components.rabbitmq.image` |  | `"rabbitmq:3.8"` |
| `mdssc_components.rabbitmq.ports` |  | `[{"port": 5672}]` |
| `mdssc_components.rabbitmq.extra_labels.aws-type` |  | `"fargate"` |
| `mdssc_components.licensingservice.name` |  | `"licensingservice"` |
| `mdssc_components.licensingservice.custom_repo` |  | `true` |
| `mdssc_components.licensingservice.image` |  | `"mdcloudservices_licensing"` |
| `mdssc_components.licensingservice.ports` |  | `[{"port": 5000}]` |
| `mdssc_components.licensingservice.extra_labels.aws-type` |  | `"fargate"` |
| `mdssc_components.smbservice.name` |  | `"smbservice"` |
| `mdssc_components.smbservice.custom_repo` |  | `true` |
| `mdssc_components.smbservice.image` |  | `"mdcloudservices_smbservice"` |
| `mdssc_components.smbservice.ports` |  | `[{"port": 5002}]` |
| `mdssc_components.smbservice.extra_labels.aws-type` |  | `"fargate"` |
| `mdssc_components.discoveryservice.name` |  | `"discoveryservice"` |
| `mdssc_components.discoveryservice.custom_repo` |  | `true` |
| `mdssc_components.discoveryservice.image` |  | `"mdcloudservices_s3-discovery"` |
| `mdssc_components.discoveryservice.extra_labels.aws-type` |  | `"fargate"` |
| `mdssc_components.discoveryservice.resources.requests.memory` |  | `"2Gi"` |
| `mdssc_components.discoveryservice.resources.requests.cpu` |  | `"1"` |
| `mdssc_components.discoveryservice.resources.limits.memory` |  | `"4Gi"` |
| `mdssc_components.discoveryservice.resources.limits.cpu` |  | `"1"` |
| `mdssc_components.scanningservice.name` |  | `"scanningservice"` |
| `mdssc_components.scanningservice.custom_repo` |  | `true` |
| `mdssc_components.scanningservice.image` |  | `"mdcloudservices_scanning"` |
| `mdssc_components.scanningservice.extra_labels.aws-type` |  | `"fargate"` |
| `mdssc_components.scanningservice.resources.requests.memory` |  | `"2Gi"` |
| `mdssc_components.scanningservice.resources.requests.cpu` |  | `"1"` |
| `mdssc_components.scanningservice.resources.limits.memory` |  | `"4Gi"` |
| `mdssc_components.scanningservice.resources.limits.cpu` |  | `"1"` |
| `mdssc_components.notificationservice.name` |  | `"notificationservice"` |
| `mdssc_components.notificationservice.custom_repo` |  | `true` |
| `mdssc_components.notificationservice.image` |  | `"mdcloudservices_notification"` |
| `mdssc_components.notificationservice.extra_labels.aws-type` |  | `"fargate"` |
| `mdssc_components.notificationservice.resources.requests.memory` |  | `"2Gi"` |
| `mdssc_components.notificationservice.resources.requests.cpu` |  | `"1"` |
| `mdssc_components.notificationservice.resources.limits.memory` |  | `"4Gi"` |
| `mdssc_components.notificationservice.resources.limits.cpu` |  | `"1"` |
| `mdssc_components.jobdispatcher.name` |  | `"jobdispatcher"` |
| `mdssc_components.jobdispatcher.custom_repo` |  | `true` |
| `mdssc_components.jobdispatcher.image` |  | `"mdcloudservices_job-dispatcher"` |
| `mdssc_components.jobdispatcher.extra_labels.aws-type` |  | `"fargate"` |
| `mdssc_components.jobdispatcher.resources.requests.memory` |  | `"2Gi"` |
| `mdssc_components.jobdispatcher.resources.requests.cpu` |  | `"1"` |
| `mdssc_components.jobdispatcher.resources.limits.memory` |  | `"4Gi"` |
| `mdssc_components.jobdispatcher.resources.limits.cpu` |  | `"1"` |
| `mdssc_components.postactionsservice.name` |  | `"postactionsservice"` |
| `mdssc_components.postactionsservice.custom_repo` |  | `true` |
| `mdssc_components.postactionsservice.image` |  | `"mdcloudservices_post-actions"` |
| `mdssc_components.postactionsservice.extra_labels.aws-type` |  | `"fargate"` |
| `mdssc_components.postactionsservice.resources.requests.memory` |  | `"2Gi"` |
| `mdssc_components.postactionsservice.resources.requests.cpu` |  | `"1"` |
| `mdssc_components.postactionsservice.resources.limits.memory` |  | `"4Gi"` |
| `mdssc_components.postactionsservice.resources.limits.cpu` |  | `"1"` |
| `mdssc_components.apigateway.name` |  | `"apigateway"` |
| `mdssc_components.apigateway.custom_repo` |  | `true` |
| `mdssc_components.apigateway.image` |  | `"mdcloudservices_api"` |
| `mdssc_components.apigateway.env` |  | `[{"name": "ASPNETCORE_URLS", "value": "http://+"}]` |
| `mdssc_components.apigateway.ports` |  | `[{"port": 443}, {"port": 80}]` |
| `mdssc_components.apigateway.extra_labels.aws-type` |  | `"fargate"` |
| `mdssc_components.webclient.name` |  | `"webclient"` |
| `mdssc_components.webclient.custom_repo` |  | `true` |
| `mdssc_components.webclient.image` |  | `"mdcloudservices_web"` |
| `mdssc_components.webclient.ports` |  | `[{"port": 443}, {"port": 80}]` |
| `mdssc_components.webclient.service_type` |  | `"ClusterIP"` |
| `mdssc_components.webclient.mountConfig.configName` |  | `"webclient-nginx-config"` |
| `mdssc_components.webclient.mountConfig.mountPath` |  | `"/etc/nginx/conf.d/default.conf"` |
| `mdssc_components.webclient.mountConfig.subPath` |  | `"default.conf"` |
| `mdssc_components.webclient.extra_labels.aws-type` |  | `"fargate"` |
| `mdssc_components.systemchecks.name` |  | `"systemchecks"` |
| `mdssc_components.systemchecks.image` |  | `"mdcloudservices_systemchecks"` |
| `mdssc_components.systemchecks.custom_repo` |  | `true` |
| `mdssc_components.systemchecks.ports` |  | `[{"port": 443}, {"port": 80}]` |
| `mdssc_components.systemchecks.mountConfig.configName` |  | `"systemchecks-nginx-config"` |
| `mdssc_components.systemchecks.mountConfig.mountPath` |  | `"/etc/nginx/conf.d/default.conf"` |
| `mdssc_components.systemchecks.mountConfig.subPath` |  | `"default.conf"` |
| `mdssc_components.systemchecks.extra_labels.aws-type` |  | `"fargate"` |
| `mdssc_components.securitychecklistservice.name` |  | `"securitychecklistservice"` |
| `mdssc_components.securitychecklistservice.custom_repo` |  | `true` |
| `mdssc_components.securitychecklistservice.image` |  | `"mdcloudservices_security-checklist"` |
| `mdssc_components.securitychecklistservice.extra_labels.aws-type` |  | `"fargate"` |
| `mdssc_components.loadbalancerservice.name` |  | `"loadbalancerservice"` |
| `mdssc_components.loadbalancerservice.custom_repo` |  | `true` |
| `mdssc_components.loadbalancerservice.image` |  | `"mdcloudservices_load-balancer"` |
| `mdssc_components.loadbalancerservice.extra_labels.aws-type` |  | `"fargate"` |
| `mdssc_components.loadbalancerservice.resources.requests.memory` |  | `"2Gi"` |
| `mdssc_components.loadbalancerservice.resources.requests.cpu` |  | `"1"` |
| `mdssc_components.loadbalancerservice.resources.limits.memory` |  | `"4Gi"` |
| `mdssc_components.loadbalancerservice.resources.limits.cpu` |  | `"1"` |
| `mdssc_components.loggingservice.name` |  | `"loggingservice"` |
| `mdssc_components.loggingservice.custom_repo` |  | `true` |
| `mdssc_components.loggingservice.image` |  | `"mdcloudservices_logging"` |
| `mdssc_components.loggingservice.extra_labels.aws-type` |  | `"fargate"` |
| `mdssc_components.loggingservice.resources.requests.memory` |  | `"2Gi"` |
| `mdssc_components.loggingservice.resources.requests.cpu` |  | `"1"` |
| `mdssc_components.loggingservice.resources.limits.memory` |  | `"4Gi"` |
| `mdssc_components.loggingservice.resources.limits.cpu` |  | `"1"` |



---
_Documentation generated by [Frigate](https://frigate.readthedocs.io)._

