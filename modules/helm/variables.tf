variable "kubernetes_config_path" {
  description = "Path to the Kubernetes config file."
}

variable namespace {
  description = "The namespace to deploy to."
}

variable "grafana_secert_name" {
  description = "The Grafana credentials secret name."
}
