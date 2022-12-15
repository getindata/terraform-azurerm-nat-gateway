module "resource_group" {
  source = "github.com/getindata/terraform-azurerm-resource-group?ref=v1.2.0"

  name     = var.resource_group_name
  location = var.location
}

module "nat_gateway" {
  source = "../../"

  name = "example-nat-gw"

  location            = module.resource_group.location
  resource_group_name = module.resource_group.name

  public_ip = {
    count = 1
  }
}
