resource "aws_eks_cluster" "web_server_eks" {
  name     = "web-server-eks"
  role_arn = aws_iam_role.web_server_cluster_role.arn

  vpc_config {
    endpoint_public_access = true

    subnet_ids = [
      aws_subnet.web_server_subnet_1.id,
      aws_subnet.web_server_subnet_2.id,
      aws_subnet.web_server_subnet_3.id
    ]
    security_group_ids = [aws_security_group.web_server_sg.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy
  ]
}

resource "aws_iam_role" "web_server_cluster_role" {
  name = "web-server-cluster-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "eks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.web_server_cluster_role.name
}
