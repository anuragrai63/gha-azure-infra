    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "1-54b3b90d-playground-sandbox"
    storage_account_name = "stbtgmvaccessdev"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    
    # Note: State locking is enabled natively and automatically by Terraform 
    # using Azure Blob Storage Leases. No additional configuration is required!
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}
