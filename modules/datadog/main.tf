terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }

    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

resource "kubernetes_namespace" "datadog" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "datadog_api_key" {
  metadata {
    name      = var.api_key_secret_name
    namespace = var.namespace
  }

  type = "Opaque"

  data = {
    "api-key" = var.datadog_api_key
  }

  depends_on = [
    kubernetes_namespace.datadog
  ]
}

resource "helm_release" "datadog" {
  name             = "datadog-agent"
  repository       = var.chart_repository
  chart            = "datadog"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = false

  atomic          = true
  cleanup_on_fail = true
  timeout         = 600

  depends_on = [
    kubernetes_secret.datadog_api_key
  ]

  values = [
    yamlencode({
      datadog = {
        apiKeyExistingSecret = var.api_key_secret_name
        site                 = var.site

        logs = {
          enabled             = var.collect_container_logs
          containerCollectAll = var.collect_container_logs
        }
      }

      agents = {
        useHostNetwork = false
      }
    })
  ]
}

