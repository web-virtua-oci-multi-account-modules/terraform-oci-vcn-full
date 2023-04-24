data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

locals {
  tags_network = {
    "tf-name"        = var.display_name
    "tf-type"        = "vcn"
    "tf-compartment" = var.compartment_name
  }

  internet_gateway_name = var.internet_gateway_name != null ? var.internet_gateway_name : "${var.display_name}-igtw"

  tags_internet_gateway = {
    "tf-name"        = local.internet_gateway_name
    "tf-main"        = "vcn"
    "tf-type"        = "internet-gateway"
    "tf-compartment" = var.compartment_name
  }

  nat_gateway_name = var.nat_gateway_name != null ? var.nat_gateway_name : "${var.display_name}-ngtw"

  tags_nat_gateway = {
    "tf-name"        = local.nat_gateway_name
    "tf-main"        = "vcn"
    "tf-type"        = "nat-gateway"
    "tf-compartment" = var.compartment_name
  }

  service_gateway_name = var.service_gateway_name != null ? var.service_gateway_name : "${var.display_name}-sgtw"

  tags_service_gateway = {
    "tf-name"        = local.service_gateway_name
    "tf-main"        = "vcn"
    "tf-type"        = "service-gateway"
    "tf-compartment" = var.compartment_name
  }

  route_table_public_name = var.public_route_table_name != null ? var.public_route_table_name : "${var.display_name}-public-rt"

  tags_route_table_public = {
    "tf-name"        = local.route_table_public_name
    "tf-main"        = "vcn"
    "tf-type"        = "route-table"
    "tf-type-env"    = "public"
    "tf-compartment" = var.compartment_name
  }

  route_table_private_name = var.private_route_table_name != null ? var.private_route_table_name : "${var.display_name}-private-rt"

  tags_route_table_private = {
    "tf-name"        = local.route_table_private_name
    "tf-main"        = "vcn"
    "tf-type"        = "route-table"
    "tf-type-env"    = "private"
    "tf-compartment" = var.compartment_name
  }
}

resource "oci_core_virtual_network" "create_vcn" {
  compartment_id                   = var.compartment_id
  display_name                     = var.display_name
  dns_label                        = var.dns_label == "" ? replace(var.display_name, "-", "") : var.dns_label
  cidr_block                       = var.cidr_block
  freeform_tags                    = merge(var.tags, var.use_tags_default ? local.tags_network : {})
  defined_tags                     = var.defined_tags
  cidr_blocks                      = var.cidr_blocks
  ipv6private_cidr_blocks          = var.ipv6private_cidr_blocks
  is_ipv6enabled                   = var.is_ipv6enabled
  is_oracle_gua_allocation_enabled = var.is_oracle_gua_allocation_enabled

  dynamic "byoipv6cidr_details" {
    for_each = var.byoipv6cidr_details != null ? [1] : []

    content {
      byoipv6range_id = var.byoipv6cidr_details.byoipv6range_id
      ipv6cidr_block  = var.byoipv6cidr_details.ipv6cidr_block
    }
  }
}

resource "oci_core_internet_gateway" "create_internet_gateway" {
  count = var.has_internet ? 1 : 0

  compartment_id = var.compartment_id
  display_name   = local.internet_gateway_name
  vcn_id         = oci_core_virtual_network.create_vcn.id
  freeform_tags  = merge(var.tags_igtw, var.use_tags_default ? local.tags_internet_gateway : {})
  defined_tags   = var.defined_tags_igtw
  enabled        = var.is_igtw_enable
  route_table_id = var.internet_gateway_route_table_id
}

resource "oci_core_nat_gateway" "create_nat_gateway" {
  count = var.has_nat_gateway ? 1 : 0

  compartment_id = var.compartment_id
  display_name   = local.nat_gateway_name
  vcn_id         = oci_core_virtual_network.create_vcn.id
  freeform_tags  = merge(var.tags_ngtw, var.use_tags_default ? local.tags_nat_gateway : {})
  defined_tags   = var.defined_tags_ngtw
  block_traffic  = var.is_ngtw_block_traffic
  public_ip_id   = var.ngtw_public_ip_id
  route_table_id = var.nat_gateway_route_table_id
}

resource "oci_core_service_gateway" "create_service_gateway" {
  count = var.has_service_gateway ? 1 : 0

  compartment_id = var.compartment_id
  display_name   = local.service_gateway_name
  vcn_id         = oci_core_virtual_network.create_vcn.id
  freeform_tags  = merge(var.tags_sgtw, var.use_tags_default ? local.tags_service_gateway : {})
  defined_tags   = var.defined_tags_sgtw
  route_table_id = var.service_gateway_route_table_id

  services {
    service_id = lookup(data.oci_core_services.all_services.services[0], "id")
  }
}

resource "oci_core_route_table" "create_public_route_table" {
  count = var.has_internet ? 1 : 0

  compartment_id = var.compartment_id
  display_name   = local.route_table_public_name
  vcn_id         = oci_core_virtual_network.create_vcn.id
  freeform_tags  = merge(var.tags_public_rt, var.use_tags_default ? local.tags_route_table_public : {})
  defined_tags   = var.defined_tags_public_rt

  dynamic "route_rules" {
    for_each = { for index, rt in var.public_route_table_rules : index => rt }

    content {
      destination       = route_rules.value.destination
      destination_type  = route_rules.value.destination_type
      description       = route_rules.value.description
      route_type        = route_rules.value.route_type
      network_entity_id = route_rules.value.network_entity_id != null ? route_rules.value.network_entity_id : oci_core_internet_gateway.create_internet_gateway[0].id
    }
  }
}

resource "oci_core_route_table" "create_private_route_table" {
  count = var.has_nat_gateway ? 1 : 0

  compartment_id = var.compartment_id
  display_name   = local.route_table_private_name
  vcn_id         = oci_core_virtual_network.create_vcn.id
  freeform_tags  = merge(var.tags_private_rt, var.use_tags_default ? local.tags_route_table_private : {})
  defined_tags   = var.defined_tags_private_rt

  dynamic "route_rules" {
    for_each = var.has_service_gateway ? [1] : []

    content {
      description       = "Traffic to OCI services"
      destination       = lookup(data.oci_core_services.all_services.services[0], "cidr_block")
      destination_type  = "SERVICE_CIDR_BLOCK"
      network_entity_id = oci_core_service_gateway.create_service_gateway[0].id
    }
  }

  dynamic "route_rules" {
    for_each = { for index, rt in var.private_route_table_rules : index => rt }

    content {
      destination       = route_rules.value.destination
      destination_type  = route_rules.value.destination_type
      description       = route_rules.value.description
      route_type        = route_rules.value.route_type
      network_entity_id = route_rules.value.network_entity_id != null ? route_rules.value.network_entity_id : oci_core_nat_gateway.create_nat_gateway[0].id
    }
  }
}

resource "oci_core_subnet" "create_public_subnets" {
  for_each = { for index, subnet in var.public_subnets : index => subnet }

  vcn_id                     = oci_core_virtual_network.create_vcn.id
  route_table_id             = oci_core_route_table.create_public_route_table[0].id
  compartment_id             = var.compartment_id
  cidr_block                 = each.value.cidr_block
  display_name               = each.value.name
  dns_label                  = each.value.dns_label
  dhcp_options_id            = each.value.dhcp_options_id
  security_list_ids          = each.value.security_list_ids
  defined_tags               = each.value.defined_tags
  availability_domain        = each.value.availability_domain
  ipv6cidr_block             = each.value.ipv6cidr_block
  ipv6cidr_blocks            = each.value.ipv6cidr_blocks
  prohibit_internet_ingress  = each.value.prohibit_internet_ingress
  prohibit_public_ip_on_vnic = each.value.prohibit_public_ip_on_vnic

  freeform_tags = merge(var.tags, var.use_tags_default ? {
    "tf-name"        = each.value.name
    "tf-main"        = "vcn"
    "tf-type"        = "public-subnet"
    "tf-compartment" = var.compartment_name
  } : {})
}

resource "oci_core_subnet" "create_private_subnets" {
  for_each = { for index, subnet in var.private_subnets : index => subnet }

  vcn_id                     = oci_core_virtual_network.create_vcn.id
  route_table_id             = oci_core_route_table.create_private_route_table[0].id
  compartment_id             = var.compartment_id
  cidr_block                 = each.value.cidr_block
  display_name               = each.value.name
  dns_label                  = each.value.dns_label
  dhcp_options_id            = each.value.dhcp_options_id
  security_list_ids          = each.value.security_list_ids
  defined_tags               = each.value.defined_tags
  availability_domain        = each.value.availability_domain
  ipv6cidr_block             = each.value.ipv6cidr_block
  ipv6cidr_blocks            = each.value.ipv6cidr_blocks
  prohibit_internet_ingress  = each.value.prohibit_internet_ingress
  prohibit_public_ip_on_vnic = each.value.prohibit_public_ip_on_vnic

  freeform_tags = merge(var.tags, var.use_tags_default ? {
    "tf-name"        = each.value.name
    "tf-main"        = "vcn"
    "tf-type"        = "private-subnet"
    "tf-compartment" = var.compartment_name
  } : {})
}
