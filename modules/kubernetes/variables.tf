variable "kubernetes_config_path" {
  description = "Path to the Kubernetes config file."
}

variable "grafana_user" {
  description = "Grafana db user"
}

variable "grafana_password" {
  description = "Grafana db password"
}
variable "grafana_name" {
  description = "Grafana database name"
}

variable namespace {
  description = "The namespace to deploy to."
}
variable monitoring_namespace {
  description = "The namespace to deploy to."
}