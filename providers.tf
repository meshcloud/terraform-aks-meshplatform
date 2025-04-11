terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.15.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=3.0.2"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.26.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.0"
    }
  }
}
