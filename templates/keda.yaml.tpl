clusterName: ${cluster_name}

serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: ${keda_operator_role_arn}

operator:
  replicaCount: ${operator_replica_count}

metricsServer:
  replicaCount: ${metrics_server_replica_count}

webhooks:
  replicaCount: ${webhooks_replica_count}

upgradeStrategy:
  operator:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: ${maximum_unavailable}
      maxSurge: 1
  metricsApiServer:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: ${maximum_unavailable}
      maxSurge: 1
  webhooks:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: ${maximum_unavailable}
      maxSurge: 1

podDisruptionBudget:
  operator:
    minAvailable: ${minimum_available}
    maxUnavailable: ${maximum_unavailable}
  metricServer:
    minAvailable: ${minimum_available}
    maxUnavailable: ${maximum_unavailable}
  webhooks:
    minAvailable: ${minimum_available}
    maxUnavailable: ${maximum_unavailable}

resources:
  # -- Manage [resource request & limits] of KEDA operator pod
  operator:
    limits:
      cpu: 1
      memory: 1000Mi
    requests:
      cpu: 100m
      memory: 100Mi
  # -- Manage [resource request & limits] of KEDA metrics apiserver pod
  metricServer:
    limits:
      cpu: 1
      memory: 1000Mi
    requests:
      cpu: 100m
      memory: 100Mi
  # -- Manage [resource request & limits] of KEDA admission webhooks pod
  webhooks:
    limits:
      cpu: 1
      memory: 1000Mi
    requests:
      cpu: 100m
      memory: 100Mi

permissions:
  metricServer:
    restrict:
      # -- Restrict Secret Access for Metrics Server
      secret: true
  operator:
    restrict:
      # -- Restrict Secret Access for KEDA operator
      secret: true

podIdentity:
  aws:
    irsa:
      enabled: true
      role:
        arn: ""
        name: ""
        externalId: ""
        policy: ""
        policyDocument: ""

