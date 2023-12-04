provider "azurerm" {
  version = "=1.35.0"

  subscription_id = "e8f987cd-3be9-45e8-8ee2-e94ad9e076c2" 
}

# Create a resource group
resource "azurerm_resource_group" "dj" {
  name     = "dj-test"
  location = var.location
}
