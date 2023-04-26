variable "compartment_id" {
  description = "Compartment ID"
  type        = string
}

variable "display_name" {
  description = "VCN name"
  type        = string
}

variable "cidr_block" {
  description = "Cidr block to VCN"
  type        = string
}

variable "compartment_name" {
  description = "Compartment name"
  type        = string
  default     = null
}

variable "cidr_blocks" {
  description = "Cidr block list to VCN, is optional"
  type        = list(string)
  default     = null
}

variable "dns_label" {
  description = "DNS label"
  type        = string
  default     = ""
}

variable "ipv6private_cidr_blocks" {
  description = "IPV6 private list to VCN, is optional"
  type        = list(string)
  default     = null
}

variable "is_ipv6enabled" {
  description = "If true the IPv6 is enabled for the VCN"
  type        = bool
  default     = null
}

variable "is_oracle_gua_allocation_enabled" {
  description = "Specifies whether to skip Oracle allocated IPv6 GUA. By default, Oracle will allocate one GUA of /56 size for an IPv6 enabled VCN"
  type        = bool
  default     = null
}

variable "byoipv6cidr_details" {
  description = "The list of BYOIPv6 OCIDs and BYOIPv6 CIDR blocks required to create a VCN that uses BYOIPv6 ranges"
  type = object({
    byoipv6range_id = string
    ipv6cidr_block  = string
  })
  default = null
}

variable "use_tags_default" {
  description = "If true will be use the tags default to resources"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to VCN"
  type        = map(any)
  default     = {}
}

variable "defined_tags" {
  description = "Defined tags to VCN"
  type        = map(any)
  default     = null
}

variable "tags_igtw" {
  description = "Tags to internet gateway"
  type        = map(any)
  default     = {}
}

variable "defined_tags_igtw" {
  description = "Defined tags to internet gateway"
  type        = map(any)
  default     = null
}

variable "tags_ngtw" {
  description = "Tags to NAT gateway"
  type        = map(any)
  default     = {}
}

variable "defined_tags_ngtw" {
  description = "Defined tags to NAT gateway"
  type        = map(any)
  default     = null
}

variable "tags_sgtw" {
  description = "Tags to service gateway"
  type        = map(any)
  default     = {}
}

variable "defined_tags_sgtw" {
  description = "Defined tags to service gateway"
  type        = map(any)
  default     = null
}

variable "tags_public_rt" {
  description = "Tags to public route table"
  type        = map(any)
  default     = {}
}

variable "defined_tags_public_rt" {
  description = "Defined tags to public route table"
  type        = map(any)
  default     = null
}

variable "tags_private_rt" {
  description = "Tags to private route table"
  type        = map(any)
  default     = {}
}

variable "defined_tags_private_rt" {
  description = "Defined tags to private route table"
  type        = map(any)
  default     = null
}

#------------------------------------------------#
#---------------Internet Gateway-----------------#
variable "has_internet" {
  description = "If has internet gatway to internet"
  type        = string
  default     = true
}

variable "internet_gateway_name" {
  description = "Internet gateway name"
  type        = string
  default     = null
}

variable "is_igtw_enable" {
  description = "When the gateway is disabled, traffic is not routed to/from the Internet, regardless of route rules"
  type        = bool
  default     = true
}

variable "internet_gateway_route_table_id" {
  description = "The OCID of the route table the Internet Gateway is using"
  type        = string
  default     = null
}

variable "public_route_table_name" {
  description = "Public route table name"
  type        = string
  default     = null
}

variable "public_route_table_rules" {
  description = "List with public routing table rules to VCN, to destination_type variable can be use CIDR_BLOCK, SERVICE_CIDR_BLOCK or Service, to route_type variable can be use STATIC or LOCAL"
  type = list(object({
    destination       = string
    destination_type  = optional(string, "CIDR_BLOCK")
    description       = optional(string)
    route_type        = optional(string)
    network_entity_id = optional(string)
  }))
  default = [{
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }]
}

#------------------------------------------------#
#------------------NAT Gateway-------------------#
variable "has_nat_gateway" {
  description = "If has nat gatway"
  type        = string
  default     = true
}

variable "nat_gateway_name" {
  description = "Nat gateway name"
  type        = string
  default     = null
}

variable "is_ngtw_block_traffic" {
  description = "NAT gateway blocks traffic"
  type        = bool
  default     = false
}

variable "ngtw_public_ip_id" {
  description = "The OCID of the public IP address associated with the NAT gateway"
  type        = string
  default     = null
}

variable "nat_gateway_route_table_id" {
  description = "The OCID of the route table the NAT Gateway is using"
  type        = string
  default     = null
}

variable "private_route_table_name" {
  description = "Private route table name"
  type        = string
  default     = null
}

variable "has_service_gateway" {
  description = "If true, will be created the service gateway and the traffic to all OCI services will be allowed"
  type        = bool
  default     = true
}

variable "service_gateway_name" {
  description = "Service gateway name"
  type        = string
  default     = null
}

variable "service_gateway_route_table_id" {
  description = "The OCID of the route table the service Gateway is using"
  type        = string
  default     = null
}

variable "private_route_table_rules" {
  description = "List with private routing table rules to VCN, to destination_type variable can be use CIDR_BLOCK, SERVICE_CIDR_BLOCK or Service, to route_type variable can be use STATIC or LOCAL"
  type = list(object({
    destination       = string
    destination_type  = optional(string, "CIDR_BLOCK")
    description       = optional(string)
    route_type        = optional(string)
    network_entity_id = optional(string)
  }))
  default = [{
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }]
}

#------------------------------------------------#
#--------------------Subnets---------------------#
variable "public_subnets" {
  description = "Define the public subnets configuration"
  type = list(object({
    name                       = string
    cidr_block                 = string
    dns_label                  = optional(string)
    dhcp_options_id            = optional(string)
    security_list_ids          = optional(list(string))
    tags                       = optional(map(any))
    defined_tags               = optional(map(any))
    availability_domain        = optional(string)
    ipv6cidr_block             = optional(string)
    ipv6cidr_blocks            = optional(list(string))
    prohibit_internet_ingress  = optional(bool)
    prohibit_public_ip_on_vnic = optional(bool)
  }))
  default = []
}

variable "private_subnets" {
  description = "Define the private subnets configuration"
  type = list(object({
    name                       = string
    cidr_block                 = string
    dns_label                  = optional(string)
    dhcp_options_id            = optional(string)
    security_list_ids          = optional(list(string))
    tags                       = optional(map(any))
    defined_tags               = optional(map(any))
    availability_domain        = optional(string)
    ipv6cidr_block             = optional(string)
    ipv6cidr_blocks            = optional(list(string))
    prohibit_internet_ingress  = optional(bool)
    prohibit_public_ip_on_vnic = optional(bool)
  }))
  default = []
}
