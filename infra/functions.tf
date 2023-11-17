
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "eastus"
}

resource "azurerm_storage_account" "example" {
  name                     = "jeffsgofunction"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "example" {
  name                         = "example-app-service-plan"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  os_type                      = "Linux"
  sku_name                     = "EP1"
  zone_balancing_enabled       = true
  maximum_elastic_worker_count = 10
  worker_count                 = 3
}

resource "azurerm_linux_function_app" "example" {
  name                = "jeffs-go-lang"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  service_plan_id     = azurerm_service_plan.example.id

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key

  site_config {
    application_stack {
      use_custom_runtime = true
    }
  }
}

resource "azurerm_linux_function_app_slot" "example" {
  name            = "stage"
  function_app_id = azurerm_linux_function_app.example.id

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  site_config {
    application_stack {
      use_custom_runtime = true
    }
  }
}
