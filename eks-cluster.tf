resource "aws_eks_cluster" "my_web_server_eks" {
  name     = "my-web-server"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    endpoint_public_access = true

    subnet_ids = [
      aws_subnet.my_subnet_test_1.id,
      aws_subnet.my_subnet_test_2.id,
      aws_subnet.my_subnet_test_3.id
    ]
    security_group_ids = [ aws_security_group.my_sg_ssh.id ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy
  ]
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster"

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
  role       = aws_iam_role.eks_cluster_role.name
}
