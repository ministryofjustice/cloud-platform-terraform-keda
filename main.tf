resource "kubernetes_namespace" "keda" {
  count = var.enable_keda ? 1 : 0
  metadata {
    name = "keda"

    labels = {
      "component"                                      = "keda"
      "cloud-platform.justice.gov.uk/environment-name" = "production"
      "cloud-platform.justice.gov.uk/is-production"    = "true"
      "pod-security.kubernetes.io/enforce"             = "restricted"
    }

    annotations = {
      "cloud-platform.justice.gov.uk/application"   = "Keda"
      "cloud-platform.justice.gov.uk/business-unit" = "Platforms"
      "cloud-platform.justice.gov.uk/owner"         = "Cloud Platform: platforms@digital.justice.gov.uk"
      "cloud-platform.justice.gov.uk/source-code"   = "https://github.com/ministryofjustice/cloud-platform-infrastructure"
      "cloud-platform-out-of-hours-alert"           = "true"
      
    }
  }
}

resource "helm_release" "keda" {
  count = var.enable_keda ? 1 : 0
  name       = "keda"
  namespace  = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  version    = "v2.16.0" # latest version compatible with k8s 1.30, 1.31

  values = [templatefile("${path.module}/templates/keda.yaml.tpl", {
    cluster_name = terraform.workspace
    operator_replica_count = var.keda_operator_replica_count
    metrics_server_replica_count = var.keda_metrics_server_replica_count
    webhook_replica_count = var.keda_webhook_replica_count
    minimum_available = var.keda_minimum_Available
    maximum_unavailable = var.keda_maximum_Unavailable
    keda_operator_role_arn = aws_iam_role.keda-operator.arn
  })]
  depends_on = [
    kubernetes_namespace.keda
  ]

  lifecycle {
    precondition {
      condition     = var.keda_minimum_Available > 0 && var.keda_maximum_Unavailable > 0 ? false : true
      error_message = "keda_minimum_Available and keda_maximum_Unavailable cannot be both set at the same time, please set one of them to 0"
    }
  }
}