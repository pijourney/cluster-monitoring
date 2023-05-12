provider "kubernetes" {
  config_path = var.kubernetes_config_path
}

## Creates grafana-db-conf secrets from values created in postgresql module.
resource "kubernetes_secret" "grafana_credentials" {
  metadata {
    name = "grafana-db-conf"
    namespace = kubernetes_namespace.monitoring.metadata.0.name 
  }
  data = {
    host     =  data.kubernetes_secret.database-conf.data.host
    username =  var.grafana_user
    password =  var.grafana_password
    database =  var.grafana_name
  }
  type = "Opaque"
}
## Creates grafana-dashboard-admin-pass-and-user this is just for example purposes, please change username and password. You will be prompted to change pw on first login.
resource "kubernetes_secret" "grafana_dashboard_conf" {
  metadata {
    name = "grafana-dashboard-conf"
    namespace = kubernetes_namespace.monitoring.metadata.0.name 
  }
  data = {
    username =  "admin"
    password =  "admin"
    
  }
  type = "Opaque"
}
## Fetches the database-conf secrets from kubernetes used buy postgresql moduleq.
data "kubernetes_secret" "database-conf" {
   metadata {
    name = "database-conf"
    namespace = var.namespace
  }
}

## loads the dashboard json files from the modules resources/dashboards folder.
locals {
  dashboards = fileset("${path.module}/resources/dashboards", "*.json")
}
## Creates Configmaps from json files in the folder resources/dashboards.
resource "kubernetes_config_map" "dashboards" {
  for_each = { for dashboard in local.dashboards : dashboard => dashboard }

  metadata {
    name      = replace(each.value, ".json", "")  # Remove the file extension using the replace function
    namespace = kubernetes_namespace.monitoring.metadata.0.name
    labels = {
      grafana_dashboard = "1"
    }
  }

  data = {
    "${replace(each.value, ".json", "")}.json" = file("${path.module}/resources/dashboards/${each.value}")
  }
}

## Create a namespace for monitoring

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.monitoring_namespace
  }
}

