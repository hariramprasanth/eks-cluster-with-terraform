resource "aws_eks_node_group" "web_server_node_group" {
  cluster_name    = aws_eks_cluster.web_server_eks.name
  node_group_name = "web-server-cluster-node-group"
  node_role_arn   = aws_iam_role.web_server_node_role.arn
  ami_type        = "AL2_x86_64"
  capacity_type   = "ON_DEMAND"
  instance_types  = ["t2.medium"]

  remote_access {
    ec2_ssh_key               = "web-server-ssh-key-pair"
    source_security_group_ids = [aws_security_group.web_server_sg.id]
  }

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 2
  }
  subnet_ids = [
    aws_subnet.web_server_subnet_1.id,
    aws_subnet.web_server_subnet_2.id,
    aws_subnet.web_server_subnet_3.id
  ]
  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_AmazonEKSWorkerNodePolicy
  ]

}

resource "aws_iam_role" "web_server_node_role" {
  name = "eks-cluster-node-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.web_server_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.web_server_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.web_server_node_role.name
}
