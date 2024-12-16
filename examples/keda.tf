module "keda" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-keda?ref=main"

  enable_keda = true
  namespace = "keda"
  keda_operator_replica_count = 2 # recommended to have a minimum of 2 replicas for the operator
  keda_metrics_server_replica_count = 1 # currently only have 1 replica for metrics server as it is not recommended to have more than 1 replica see README
  keda_webhook_replica_count = 1 # currently is the default value for the webhook replica count
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