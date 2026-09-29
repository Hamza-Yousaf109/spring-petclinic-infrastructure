terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = var.chart_repository
  chart            = "argo-cd"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  timeout          = 900

  values = [yamlencode({
    applicationSet = {
      enabled = true
    }
    configs = {
      params = {
        "server.insecure" = false
      }
    }
  })]
}