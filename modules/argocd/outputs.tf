output "configuration" {
  description = "Argo CD namespace and Helm release status."
  value = {
    namespace      = helm_release.argocd.namespace
    release_name   = helm_release.argocd.name
    chart_version  = helm_release.argocd.version
    release_status = helm_release.argocd.status
  }
}