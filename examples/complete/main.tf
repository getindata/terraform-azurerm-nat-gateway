module "resource_group" {
  source  = "github.com/getindata/terraform-azurerm-resource-group?ref=v1.2.0"
  context = module.this.context

  name     = var.resource_group_name
  location = var.location
}

module "vnet" {
  source              = "github.com/Azure/terraform-azurerm-vnet?ref=3.0.0"
  resource_group_name = module.resource_group.name
  vnet_location       = module.resource_group.location
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = module.this.id
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags                = module.this.tags
  sku                 = "PerGB2018"
}

module "nat_gateway" {
  source  = "../../"
  context = module.this.context

  name = "example"

  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  subnet_ids = module.vnet.vnet_subnets

  public_ip = {
    count = 2
    diagnostic_settings = {
      enabled               = true
      logs_destinations_ids = [azurerm_log_analytics_workspace.this.id]
    }
  }
}
