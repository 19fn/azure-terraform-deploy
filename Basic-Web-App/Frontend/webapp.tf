data "azurerm_virtual_network" "vnet" {
  name                 = var.vnet_name
  resource_group_name  = var.rg_name 
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [ "10.0.6.0/24" ]

  delegation {
    name = "subnet-delegation"

  service_delegation {
    name    = "Microsoft.Web/serverFarms"
    actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }

  depends_on           = [ data.azurerm_virtual_network.vnet ] 
}

resource "azurerm_service_plan" "splan" {
  name                = var.serviceplan_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "webapp" {
  name                        = var.webapp_name
  resource_group_name         = var.rg_name
  location                    = var.rg_location
  service_plan_id             = azurerm_service_plan.example.id
  https_only                  = true
  
  site_config { 
    minimum_tls_version = "1.2"
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "swift" {
  app_service_id = azurerm_linux_web_app.example.id
  subnet_id      = azurerm_subnet.subnet.id
}

resource "azurerm_linux_web_app_slot" "slot" {
  count          = 3
  name           = "slot-${count.index}"
  app_service_id = azurerm_linux_web_app.example.id

  site_config {}
}
