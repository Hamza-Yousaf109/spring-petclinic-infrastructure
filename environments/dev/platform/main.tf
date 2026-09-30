module "argocd" {
  source = "../../../modules/argocd"

  namespace     = "argocd"
  chart_version = "8.5.7"
}

module "datadog" {
  source = "../../../modules/datadog"

  namespace              = "datadog"
  chart_version          = "3.152.0"
  api_key_secret_name    = var.datadog_api_key_secret_name
  datadog_api_key        = var.datadog_api_key
  collect_container_logs = var.collect_container_logs
}