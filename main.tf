resource "kubernetes_namespace" "keda" {
  count = var.enable_keda ? 1 : 0
  metadata {
    name = "keda"

    labels = {
      "component"                                      = "keda"
      "cloud-platform.justice.gov.uk/environment-name" = "production"
      "cloud-platform.justice.gov.uk/is-production"    = "true"
      "pod-security.kubernetes.io/enforce"             = "privileged"
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
  namespace  = data.kubernetes_namespace.keda.metadata.name
  repository = "https://kedacore.github.io/charts"
  chart      = "kedacore/keda"
  version    = "v2.12.1" # v2.12.1 is the latest version for kubernetes 1.26

  values = [templatefile("${path.module}/templates/keda.yaml.tpl", {
    cluster_name = terraform.workspace
    cluster_region = var.cluster_region
    operator_replica_count = var.keda_operator_replica_count
    metrics_server_replica_count = var.keda_metrics_server_replica_count
    webhook_replica_count = var.keda_webhook_replica_count
    minimum_Available = var.keda_minimum_Available
    maximum_Unavailable = var.keda_maximum_Unavailable
  })]
  depends_on = [
    kubernetes_namespace.keda
  ]
}