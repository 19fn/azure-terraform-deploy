terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }

    backend "azurerm" {
        resource_group_name  = "sandbox" 
        storage_account_name = "stgsandbox1"
        container_name       = "cnsandbox"
        key                  = "terraform.tfstate"
    }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "sandbox" {
	name = var.resource_group_name
}
