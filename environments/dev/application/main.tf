module "applicationset" {
  source = "../../../modules/applicationset"

  providers = {
    kubectl = kubectl
  }

  repository_url           = var.repository_url
  application_path_pattern = var.application_path_pattern
  application_environments = ["dev", "staging", "prod"]

  namespace          = "argocd"
  destination_server = "https://kubernetes.default.svc"
  project            = "default"
  git_revision       = "HEAD"
}