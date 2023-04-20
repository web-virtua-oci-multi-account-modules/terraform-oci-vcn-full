output "vcn" {
  description = "VCN"
  value       = oci_core_virtual_network.create_vcn
}

output "vcn_id" {
  description = "VCN ID"
  value       = oci_core_virtual_network.create_vcn.id
}

output "internet_gateway" {
  description = "Internet gateway"
  value       = try(oci_core_internet_gateway.create_internet_gateway[0], null)
}

output "internet_gateway_id" {
  description = "Internet gateway ID"
  value       = try(oci_core_internet_gateway.create_internet_gateway[0].id, null)
}

output "nat_gateway" {
  description = "NAT gateway"
  value       = try(oci_core_nat_gateway.create_nat_gateway[0], null)
}

output "nat_gateway_id" {
  description = "NAT gateway ID"
  value       = try(oci_core_nat_gateway.create_nat_gateway[0].id, null)
}

output "service_gateway" {
  description = "Service gateway"
  value       = try(oci_core_service_gateway.create_service_gateway[0], null)
}

output "service_gateway_id" {
  description = "Service gateway ID"
  value       = try(oci_core_service_gateway.create_service_gateway[0].id, null)
}

output "public_route_table" {
  description = "Public route table"
  value       = try(oci_core_route_table.create_public_route_table[0], null)
}

output "public_route_table_id" {
  description = "Public route table ID"
  value       = try(oci_core_route_table.create_public_route_table[0].id, null)
}

output "private_route_table" {
  description = "Private route table"
  value       = try(oci_core_route_table.create_private_route_table[0], null)
}

output "private_route_table_id" {
  description = "Private route table ID"
  value       = try(oci_core_route_table.create_private_route_table[0].id, null)
}

output "public_subnets" {
  description = "Public subnets"
  value       = try(oci_core_subnet.create_public_subnets, null)
}

output "public_subnets_ids" {
  description = "Public subnets IDs"
  value       = try([for subnet in oci_core_subnet.create_public_subnets : subnet.id], null)
}

output "private_subnets" {
  description = "Private subnets"
  value       = try(oci_core_subnet.create_private_subnets, null)
}

output "private_subnets_ids" {
  description = "Private subnets IDs"
  value       = try([for subnet in oci_core_subnet.create_private_subnets : subnet.id], null)
}
