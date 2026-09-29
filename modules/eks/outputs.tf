output "configuration" {
  description = "EKS connection details used by Kubernetes platform providers."
  value = {
    cluster_name     = aws_eks_cluster.petclinic.name
    cluster_arn      = aws_eks_cluster.petclinic.arn
    cluster_endpoint = aws_eks_cluster.petclinic.endpoint
    cluster_ca_data  = aws_eks_cluster.petclinic.certificate_authority[0].data
  }
}