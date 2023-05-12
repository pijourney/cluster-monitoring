provider "helm" {
  kubernetes {
    config_path = var.kubernetes_config_path
  }
}

## TODO provision grafana dashboard user user. // connect it ot the auth service.
## Create grafana deployment
resource "helm_release" "grafana" {
  name       = "grafana"
  chart      = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  namespace = var.namespace

  values = [
    file("${path.module}/resources/grafana.yaml")
  ]

  depends_on = [ var.grafana_secert_name ]
}


## Create prometheus deployment

/*resource "helm_release" "prometheus" {
  name      = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart     = "kube-prometheus-stack"
  namespace = var.namespace

  set {
    name  = "prometheus.prometheusSpec.additionalScrapeConfigs[0].name"
    value = var.namespace
  }

  set {
    name  = "prometheus.prometheusSpec.additionalScrapeConfigs[0].key"
    value = "prometheus-additional.yaml"
  }

  set {
    name  = "prometheus.prometheusSpec.additionalScrapeConfigs[0].mountPath"
    value = "/etc/prometheus/config_out"
  }
}*/