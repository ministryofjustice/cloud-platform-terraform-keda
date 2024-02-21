# keda operator iam role
resource "aws_iam_role" "keda-operator" {
  name               = "keda-operator"
  assume_role_policy = data.aws_iam_policy_document.keda-operator-trust-policy.json
}
data "aws_iam_policy_document" "keda-operator-trust-policy" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    principals {
      type = "Federated"
      identifiers = ["arn:aws:iam::${var.cluster_domain_name}:oidc-provider/${var.eks_cluster_oidc_issuer_url}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${var.eks_cluster_oidc_issuer_url}:sub"
      values   = ["system:serviceaccount:keda:keda-operator"]
    }
  }
}

#  keda operator sqs queue policy
resource "aws_iam_role_policy" "sqs-policy" {
  name     = "sqs-queue-policy"
  role     = aws_iam_role.keda-operator.id
  policy   = data.aws_iam_policy_document.sqs-policy-document.json
}
data "aws_iam_policy_document" "sqs-policy-document" {
  statement {
    sid    = "SQS"
    effect = "Allow"
    actions = [
      "sqs:GetQueueAttributes",
    ]
    resources = [ "*" ]
  }
}