# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }

  # backend "azurerm" {
  #   resource_group_name  = "" 
  #   storage_account_name = ""
  #   container_name       = ""
  #   key                  = "terraform.tfstate"
  # }

}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
