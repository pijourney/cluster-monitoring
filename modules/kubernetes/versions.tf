terraform {
  required_version = ">= 0.13"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20.0"
    }
  
  }
}