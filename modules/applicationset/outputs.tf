output "name" {
  description = "Name of the ApplicationSet resource."
  value       = kubectl_manifest.spring_petclinic.name
}
