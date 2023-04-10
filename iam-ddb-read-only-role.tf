resource "aws_iam_role" "web_server_pods_ddb_read_only_role" {
  name = "web-server-pods-ddb-read-only-role"

  assume_role_policy = templatefile("AssumeRolePolicy.json", {
    OIDC_ARN        = aws_iam_openid_connect_provider.web_server_cluster_identity_provider.arn,
    OIDC_ID         = replace(aws_eks_cluster.web_server_eks.identity.0.oidc.0.issuer, "https://", "")
    NAMESPACE       = var.k8_namespace,
    SERVICE_ACCOUNT = var.k8_service_account
  })
}

resource "aws_iam_role_policy_attachment" "eks_AmazonDynamoDBReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess"
  role       = aws_iam_role.web_server_pods_ddb_read_only_role.name
}