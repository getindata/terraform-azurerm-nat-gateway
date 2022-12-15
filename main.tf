data "azurerm_resource_group" "this" {
  count = module.this.enabled && var.location == null ? 1 : 0

  name = var.resource_group_name
}

resource "azurerm_nat_gateway" "this" {
  count = module.this.enabled ? 1 : 0

  name                = local.name_from_descriptor
  location            = local.location
  resource_group_name = local.resource_group_name

  sku_name = "Standard"

  zones                   = var.zones
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
}

resource "azurerm_subnet_nat_gateway_association" "this" {
  count = length(var.subnet_ids)

  nat_gateway_id = one(azurerm_nat_gateway.this[*].id)
  subnet_id      = var.subnet_ids[count.index]
}

module "nat_gateway_public_ip" {
  count = var.public_ip.count

  source  = "getindata/public-ip/azurerm"
  version = "1.0.0"
  context = module.this.context

  location            = local.location
  resource_group_name = local.resource_group_name

  attributes = [format("%02s", (count.index + 1))]

  allocation_method = var.public_ip.allocation_method
  zones             = var.public_ip.zones
  ip_version        = var.public_ip.ip_version
  sku               = var.public_ip.sku
  sku_tier          = var.public_ip.sku_tier

  diagnostic_settings = var.diagnostic_settings
}

resource "azurerm_nat_gateway_public_ip_association" "provided" {
  count = length(var.public_ip_address_ids)

  nat_gateway_id       = one(azurerm_nat_gateway.this[*].id)
  public_ip_address_id = var.public_ip_address_ids[count.index]
}

resource "azurerm_nat_gateway_public_ip_association" "managed" {
  count = length(module.nat_gateway_public_ip[*].id)

  nat_gateway_id       = one(azurerm_nat_gateway.this[*].id)
  public_ip_address_id = module.nat_gateway_public_ip[count.index].id
}

resource "azurerm_nat_gateway_public_ip_prefix_association" "provided" {
  count = length(var.public_ip_prefix_ids)

  nat_gateway_id      = one(azurerm_nat_gateway.this[*].id)
  public_ip_prefix_id = var.public_ip_prefix_ids[count.index]
}

module "diagnostic_settings" {
  count = module.this.enabled && var.diagnostic_settings.enabled != null ? 1 : 0

  source  = "claranet/diagnostic-settings/azurerm"
  version = "6.2.0"

  resource_id           = one(azurerm_nat_gateway.this[*].id)
  logs_destinations_ids = var.diagnostic_settings.logs_destinations_ids
}
