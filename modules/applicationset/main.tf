terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

resource "kubectl_manifest" "spring_petclinic" {
  yaml_body = yamlencode({
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "ApplicationSet"

    metadata = {
      name      = "spring-petclinic"
      namespace = var.namespace
    }

    spec = {
      generators = [
        {
          list = {
            elements = [
              for environment in sort(tolist(var.application_environments)) : {
                environment = environment
              }
            ]
          }
        }
      ]

      template = {
        metadata = {
          name = "spring-petclinic-{{environment}}"
        }

        spec = {
          project = var.project

          sources = [
            {
              repoURL        = var.repository_url
              targetRevision = var.git_revision
              ref            = "values"
            },
            {
              repoURL        = var.repository_url
              targetRevision = var.git_revision
              path           = var.application_path_pattern

              helm = {
                valueFiles = [
                  "$values/environments/{{environment}}/values.yaml"
                ]
              }
            }
          ]

          destination = {
            server    = var.destination_server
            namespace = "spring-petclinic-{{environment}}"
          }

          syncPolicy = {
            automated = {
              prune    = false
              selfHeal = true
            }

            syncOptions = [
              "CreateNamespace=true"
            ]
          }
        }
      }
    }
  })
}