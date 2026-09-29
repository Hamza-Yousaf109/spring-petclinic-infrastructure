output "configuration" {
  description = "Non-sensitive Datadog Helm release metadata."
  value = {
    namespace      = helm_release.datadog.namespace
    release_name   = helm_release.datadog.name
    chart_version  = helm_release.datadog.version
    release_status = helm_release.datadog.status
  }
}