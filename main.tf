module "postgresql" {
  source = "./modules/postgresql"
  
  postgresql_host     = module.kubernetes.postgresql_host
  postgresql_port     = tonumber(module.kubernetes.postgresql_port)
  postgresql_user     = module.kubernetes.postgresql_user
  postgresql_password = module.kubernetes.postgresql_password
}

module "kubernetes" {
  source = "./modules/kubernetes"
  
  grafana_user            = module.postgresql.grafana_user
  grafana_password        = module.postgresql.grafana_password
  grafana_name            = module.postgresql.grafana_name
  kubernetes_config_path  = var.kubernetes_config_path
  namespace               = var.namespace
  monitoring_namespace    = var.monitoring_namespace
}

module "helm" {
  source = "./modules/helm"

  kubernetes_config_path  = var.kubernetes_config_path
  namespace               = module.kubernetes.namespace
  grafana_secert_name     = module.kubernetes.grafana_credentials_secret_name
}






