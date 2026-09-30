aws_region     = "ap-south-1"
aws_account_id = "992382771174"

environment  = "dev"
cluster_name = "petclinic"

kubernetes_version = "1.33"

eks_public_access_cidrs = [
  "0.0.0.0/0"
]

eks_cluster_admin_principal_arns = [
  "arn:aws:iam::992382771174:user/hamza",
  "arn:aws:iam::992382771174:role/GitHubActions-TerraformRole"
]