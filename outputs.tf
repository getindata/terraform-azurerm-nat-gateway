output "name" {
  description = "Name of the resource"
  value       = one(azurerm_nat_gateway.this[*].name)
}

output "id" {
  description = "ID of the resource"
  value       = one(azurerm_nat_gateway.this[*].id)
}

output "resource_group_name" {
  description = "Name of the resource resource group"
  value       = one(azurerm_nat_gateway.this[*].resource_group_name)
}

output "public_ip" {
  description = "Public IPs created for this NAT Gateway"
  value       = module.nat_gateway_public_ip
}
