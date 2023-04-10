data "tls_certificate" "cluster_certificate" {
  url = aws_eks_cluster.web_server_eks.identity.0.oidc.0.issuer
}

resource "aws_iam_openid_connect_provider" "web_server_cluster_identity_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster_certificate.certificates.0.sha1_fingerprint]
  url             = aws_eks_cluster.web_server_eks.identity.0.oidc.0.issuer
}