output "postgresql_port" {
  value       = data.kubernetes_secret.database-conf.data["port"]
  description = "The PostgreSQL port."
}
output "postgresql_host" {
  value       = data.kubernetes_secret.database-conf.data["host"]
  description = "The PostgreSQL host."
}
output "postgresql_user" {
  value       = data.kubernetes_secret.database-conf.data["user"]
  description = "The PostgreSQL user."
}

output "postgresql_password" {
  value       = data.kubernetes_secret.database-conf.data["password"]
  sensitive   = true
  description = "The PostgreSQL password."
}

output "grafana_credentials_secret_name" {
  value = kubernetes_secret.grafana_credentials.metadata.0.name
}
output "namespace" {
  value = kubernetes_namespace.monitoring.metadata.0.name
}