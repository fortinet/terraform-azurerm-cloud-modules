terraform {
  required_version = ">= 1.3, < 2.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

# Provider configuration for Azure
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = var.azure_subscription_id
}
