module "keda" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-keda?ref=main"

  enable_keda = true
  namespace = "keda"
  keda_operator_replica_count = 3
  keda_metrics_server_replica_count = 3
  keda_webhook_replica_count = 3
  keda_minimum_Available = 1
  keda_maximum_Unavailable = 0

  labels = {
      business-unit = "Platforms"
      application   = "cloud-platform-terraform-keda"
      is-production = "true"
      owner         = "Cloud Platform: platforms@digital.justice.gov.uk"
      source-code   = "github.com/ministryofjustice/cloud-platform-terraform-keda"
    }
}