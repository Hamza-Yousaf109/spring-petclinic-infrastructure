output "configuration" {
  description = "Non-sensitive IAM role and policy identifiers for the PetClinic EKS cluster."
  value = {
    cluster_role_arn        = aws_iam_role.eks_cluster.arn
    auto_mode_node_role_arn = aws_iam_role.eks_auto_mode_nodes.arn
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster,
    aws_iam_role_policy_attachment.node_worker,
    aws_iam_role_policy_attachment.node_ecr,
    aws_iam_role_policy.auto_mode_instance_profiles,
  ]
}