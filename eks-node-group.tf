# resource "aws_eks_node_group" "eks_node_group" {
#   cluster_name = aws_eks_cluster.my_web_server_eks.name
#   node_group_name = "web-server-cluster-node-group"
#   node_role_arn = aws_iam_role.eks_cluster_node_role.arn
#   subnet_ids = [
#     aws_subnet.my_subnet_test_1.id ,
#     aws_subnet.my_subnet_test_2.id ,
#     aws_subnet.my_subnet_test_3.id 
#     ]
#     depends_on = [
#       aws_iam_role_policy_attachment.eks_AmazonEC2ContainerRegistryReadOnly,
#       aws_iam_role_policy_attachment.eks_AmazonEKS_CNI_Policy,
#       aws_iam_role_policy_attachment.eks_AmazonEKSWorkerNodePolicy
#     ]

# }

resource "aws_iam_role" "eks_cluster_node_role" {
  name = "eks-cluster-nore-role"

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
  role       = aws_iam_role.eks_cluster_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_cluster_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_cluster_node_role.name
}
