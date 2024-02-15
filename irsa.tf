module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.13.0"
  create_role                   = true
  role_name                     = "keda.${var.cluster_domain_name}"
  provider_url                  = var.eks_cluster_oidc_issuer_url
  role_policy_arns              = [length(aws_iam_policy.keda) >= 1 ? aws_iam_policy.keda.arn : ""]
  oidc_fully_qualified_subjects = ["system:serviceaccount:keda:keda-operator"]
}

resource "aws_iam_policy" "keda" {
  name        = "keda"
  description = "Keda policy"
  policy      = data.aws_iam_policy_document.keda.json
}

data "aws_iam_policy_document" "keda_irsa" {
  statement {
    effect    = "Allow"
    principals {
      type = "Federated"
      identifiers = [arn("aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${var.eks_cluster_oidc_issuer_url}")]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${var.eks_cluster_oidc_issuer_url}:sub"
      values   = ["system:serviceaccount:keda:keda-operator"]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.eks_cluster_oidc_issuer_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_sqs_queue_policy" "keda_sqs_policy" {
  count = var.enable_keda ? 1 : 0
  queue_url = aws_sqs_queue.keda_queue.id
  policy    = data.aws_iam_policy_document.keda_sqs.json
  
}

data "aws_iam_policy_document" "keda_sqs" {
  statement {
    actions   = ["sqs:*"]
    effect = ["Allow"]
    resources = ["*"]
  }
}