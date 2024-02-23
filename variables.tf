variable "cluster_domain_name" {
  description = "The cluster domain used for iam_assumable_role_admin role name"
  default = ""
}

variable "eks_cluster_oidc_issuer_url" {
  description = "This is going to be used when we create the IAM OIDC role"
  type        = string
  default     = ""
}

variable "enable_keda" {
  description = "Enable or not keda Helm Chart"
  default     = true
  type        = bool
}

variable "keda_operator_replica_count" {
  description = "The number of replicas for the Keda Operator"
  type        = number
  default     = 1
}

variable "keda_metrics_server_replica_count" {
  description = "The number of replicas for the Keda Metrics Server"
  type        = number
  default     = 1
}

variable "keda_webhook_replica_count" {
  description = "The number of replicas for the Keda Webhook"
  type        = number
  default     = 1
}

variable "keda_minimum_Available" {
  description = "The minimum number of available pods"
  type        = number
  default     = 0
}

variable "keda_maximum_Unavailable" {
  description = "The maximum number of unavailable pods"
  type        = number
  default     = 0
}

variable "labels" {
  description = "Labels to be added to the keda namespace"
  type        = map(string)
}