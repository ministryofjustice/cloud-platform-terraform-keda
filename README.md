# cloud-platform-terraform-keda
This module is used to deploy KEDA on the cloud platform.


### Kubernetes Compatibility
|KEDA |	Kubernetes|
|---|---|
|v2.16 |	TBD|
|v2.15 | v1.28 - v1.30|

Link: [kubernetes compatibility](https://keda.sh/docs/2.13/operate/cluster/#kubernetes-compatibility)

### Cluster Capacity
|Deployment	| CPU	| Memory|
|---|---|---|
|Admission Webhooks	| Limit: 1, Request: 100m	| Limit: 1000Mi, Request: 100Mi|
|Metrics Server	| Limit: 1, Request: 100m	| Limit: 1000Mi, Request: 100Mi|
|Operator	| Limit: 1, Request: 100m	| Limit: 1000Mi, Request: 100Mi|

Link: [cluster capacity](https://keda.sh/docs/2.15/operate/cluster/#cluster-capacity)

### High Availability
|Deployment | Support | Replicas	Note |
|---|---|---|
|Metrics Server | 1 |	You can run multiple replicas of our metrics sever, and it is recommended to add the --enable-aggregator-routing=true CLI flag to the kube-apiserver so that requests sent to our metrics servers are load balanced. However, you can only run one active metric server in a Kubernetes cluster serving external.metrics.k8s.io which has to be the KEDA metric server.|
|Operator |	2 |	While you can run multiple replicas of our operator, only one operator instance will be active. The rest will be standing by, which may reduce downtime during a failure. Multiple replicas will not improve the performance of KEDA, it could only reduce a downtime during a failover.|

Link: [high availability](https://keda.sh/docs/2.15/operate/cluster/#high-availability)