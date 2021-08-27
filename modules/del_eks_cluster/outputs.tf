output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}

output "cluster_identity" {
  value = aws_eks_cluster.cluster.identity
}

output "cluster_arn" {
  value = aws_eks_cluster.cluster.arn
}

output "node_sg_arn" {
  value = aws_security_group.node_sg.arn
}

output "node_sg_id" {
  value = aws_security_group.node_sg.id
}

output "node_iam_role_arn" {
  value = aws_iam_role.node.arn
}

output "node_iam_role_id" {
  value = aws_iam_role.node.id
}

output "node_iam_profile_name" {
  value = aws_iam_instance_profile.node_profile.name
}

output "cluster_name" {
  value = aws_eks_cluster.cluster.name
}