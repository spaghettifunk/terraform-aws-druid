# FAQ

Here are some answers to the most frequent questions

## Cluster resources required

It vary from case to case. Currently this module does not allow to change the resources (there is a [PR](https://github.com/spaghettifunk/terraform-aws-druid/issues/14) open for that). We recommend to have the following setup

| Service  | EC2 type  | Quantity (1 per replica)  | Node label  | co-exist with  |
|---|---|:-:|---|:-:|
| Broker  | m5.xlarge  | 3 | --node-label=query  |  aAlone |
| Coordinator  | m5.xlarge  |  1 | --node-label=master  |  Overlord |
| Historical | r5.xlarge  |  3 | --node-label=data  | Middlemanager  |
| Middlemanager  |  r5.xlarge |  3 | --node-label=data  | Historical  |
| Overlord  | m5.xlarge  |  1 | --node-label=master  |  Coordinator |
| Router  | m5.xlarge  |  1 | --node-label=reserved  | N/A |
| Postgres  | m5.xlarge  |  1 | --node-label=reserved  | N/A  |
| Zookeeper  | m5.xlarge  |  3 | --node-label=reserved  |  N/A |

Certain services can be deployed on the same machine as mentioned in the column `co-exist with`. This means that you can reduce the amount of instances and still achieve your results. But it's up to you how you want to define your cluster. 

The `Node label` is just a suggestion that you can use in combination with the toleration for deploying the service to a specific instance type.

## Can I change the JVM

Yes you can but at the moment we don't have a `variable` for defining those arguments. We have a [PR](https://github.com/spaghettifunk/terraform-aws-druid/issues/13) for that though.

## Expose metrics

Apache Druid can expose several metrics to the user. Most frequently you can push those metrics to an HTTP service. We have develop [one](https://github.com/spaghettifunk/druid-prometheus-exporter) that can come useful to you. However, this requires to change the `common` configuration file of Apache Druid which is backed into the docker image. Currently some metrics are exposed by default but not all.

We have a [PR](https://github.com/spaghettifunk/terraform-aws-druid/issues/15) open to let the user deciding how to set certain Druid configurations.

## Loadbalancing

According to the official Apache Druid [documentation](https://druid.apache.org/docs/latest/operations/high-availability.html) you can put the Brokers behind a loadbalancer. There are many ways to do so. Thus, we decided to not impose any way and let you decide how to achieve this goal.

Some examples here:
- Create an `Ingress` object manually with the specific annotations for your `Ingress Controller`. The ingress object needs to connect to the `broker-cs` service.
- If you use Istio, you can use a `VirtualService` in combination with a `Gateway` to expose a DNS
- Manually `patch` the `broker-cs` service to change the type from `ClusterIP` to `LoadBalancer`