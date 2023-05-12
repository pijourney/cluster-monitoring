output "grafana_user" {
  value       = postgresql_role.grafana.name
  description = "The Grafana user for the PostgreSQL database."
}

output "grafana_password" {
  value       = postgresql_role.grafana.password
  sensitive   = true
  description = "The Grafana user's password for the PostgreSQL database."
}
output "grafana_name" {
  value       = postgresql_database.grafana.name
  description = "The Grafana database name."
}
