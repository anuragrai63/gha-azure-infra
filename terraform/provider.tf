  terraform {
  required_version = ">=1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
tls = {
  source = "hashicorp/tls"
}
random = {
   source = "hashicorp/random"
}

  }

  backend "azurerm" {
    
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
subscription_id = "9734ed68-621d-47ed-babd-269110dbacb1"
}
