# OCI VCN network full for multiples accounts with Terraform module
* This module simplifies creating and configuring of VCN network full across multiple accounts on OCI

* Is possible use this module with one account using the standard profile or multi account using multiple profiles setting in the modules.

## Actions necessary to use this module:

* Criate file provider.tf with the exemple code below:
```hcl
provider "oci" {
  alias   = "alias_profile_a"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.ssh_private_key_path
  region           = var.region
}

provider "oci" {
  alias   = "alias_profile_b"
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.ssh_private_key_path
  region           = var.region
}
```


## Features enable of VCN network configurations for this module:

- Virtual network
- Internet gateway
- NAT gateway
- Nervice gateway
- Route table
- Subnet

## Usage exemples


### Create VCN with subnet public and private, internet gateway, NAT gateway, service gateway and route tables

```hcl
module "main_vcn" {
  source = "web-virtua-oci-multi-account-modules/vcn-full/oci"

  compartment_id           = var.compartment_id
  display_name             = "tf-network-dev-vcn"
  cidr_block               = "10.1.0.0/16"
  internet_gateway_name    = "tf-network-dev-igtw"
  nat_gateway_name         = "tf-network-dev-ngtw"
  service_gateway_name     = "tf-network-dev-sgtw"
  public_route_table_name  = "tf-network-dev-public-rt"
  private_route_table_name = "tf-network-dev-private-rt"

  public_subnets = [
    {
      name       = "tf-network-dev-sububnet-public"
      cidr_block = "10.1.1.0/24"
    }
  ]

  private_subnets = [
    {
      name       = "tf-network-dev-sububnet-private"
      cidr_block = "10.1.2.0/24"
    }
  ]

  providers = {
    oci = oci.alias_profile_a
  }
}
```


## Variables

| Name | Type | Default | Required | Description | Options |
|------|-------------|------|---------|:--------:|:--------|
| compartment_id | `string` | `-` | yes | Compartment ID | `-` |
| display_name | `string` | `-` | yes | VCN name | `-` |
| cidr_block | `string` | `-` | yes | Cidr block to VCN | `-` |
| cidr_blocks | `list(string)` | `null` | no | Cidr block list to VCN, is optional | `-` |
| dns_label | `string` | `null` | no | DNS label | `-` |
| ipv6private_cidr_blocks | `list(string)` | `null` | no | IPV6 private list to VCN, is optional | `-` |
| is_ipv6enabled | `bool` | `null` | no | If true the IPv6 is enabled for the VCN | `*`false <br> `*`true |
| is_oracle_gua_allocation_enabled | `bool` | `null` | no | Specifies whether to skip Oracle allocated IPv6 GUA. By default, Oracle will allocate one GUA of /56 size for an IPv6 enabled VCN | `*`false <br> `*`true |
| byoipv6cidr_details | `list(object)` | `null` | no | The list of BYOIPv6 OCIDs and BYOIPv6 CIDR blocks required to create a VCN that uses BYOIPv6 ranges | `-` |
| use_tags_default | `bool` | `true` | no | If true will be use the tags default to resources | `*`false <br> `*`true |
| tags | `map(any)` | `{}` | no | Tags to VCN | `-` |
| defined_tags | `map(any)` | `{}` | no | Defined tags to VCN | `-` |
| tags_igtw | `map(any)` | `{}` | no | Tags to internet gateway | `-` |
| defined_tags_igtw | `map(any)` | `{}` | no | Defined tags to internet gateway | `-` |
| tags_ngtw | `map(any)` | `{}` | no | Tags to NAT gateway | `-` |
| defined_tags_ngtw | `map(any)` | `{}` | no | Defined tags to NAT gateway | `-` |
| tags_sgtw | `map(any)` | `{}` | no | Tags to service gateway | `-` |
| defined_tags_sgtw | `map(any)` | `{}` | no | Defined tags to service gateway | `-` |
| tags_public_rt | `map(any)` | `{}` | no | Tags to public route table | `-` |
| defined_tags_public_rt | `map(any)` | `{}` | no | Defined tags to public route table | `-` |
| tags_private_rt | `map(any)` | `{}` | no | Tags to private route table | `-` |
| defined_tags_private_rt | `map(any)` | `{}` | no | Defined tags to private route table | `-` |
| has_internet | `bool` | `true` | no | If has internet gatway to internet | `*`false <br> `*`true |
| internet_gateway_name | `string` | `null` | no | Internet gateway name | `-` |
| is_igtw_enable | `bool` | `true` | no | When the gateway is disabled, traffic is not routed to/from the Internet, regardless of route rules | `*`false <br> `*`true |
| internet_gateway_route_table_id | `string` | `null` | no | The OCID of the route table the Internet Gateway is using | `-` |
| public_route_table_name | `string` | `null` | no | Public route table name | `-` |
| public_route_table_rules | `list(object)` | `object` | no | List with public routing table rules to VCN, to destination_type variable can be use CIDR_BLOCK, SERVICE_CIDR_BLOCK or Service, to route_type variable can be use STATIC or LOCAL | `-` |
| has_nat_gateway | `bool` | `true` | no | If has nat gatway | `*`false <br> `*`true |
| nat_gateway_name | `string` | `null` | no | Nat gateway name | `-` |
| is_ngtw_block_traffic | `bool` | `false` | no | NAT gateway blocks traffic | `*`false <br> `*`true |
| ngtw_public_ip_id | `string` | `null` | no | The OCID of the public IP address associated with the NAT gateway | `-` |
| nat_gateway_route_table_id | `string` | `null` | no | The OCID of the route table the NAT Gateway is using | `-` |
| private_route_table_name | `string` | `null` | no | Private route table name | `-` |
| has_service_gateway | `bool` | `true` | no | If true, will be created the service gateway and the traffic to all OCI services will be allowed | `*`false <br> `*`true |
| service_gateway_name | `string` | `null` | no | Service gateway name | `-` |
| service_gateway_route_table_id | `string` | `null` | no | The OCID of the route table the service Gateway is using | `-` |
| private_route_table_rules | `list(object)` | `object` | no | List with private routing table rules to VCN, to destination_type variable can be use CIDR_BLOCK, SERVICE_CIDR_BLOCK or Service, to route_type variable can be use STATIC or LOCAL | `-` |
| public_subnets | `list(object)` | `[]` | no | Define the public subnets configuration | `-` |
| private_subnets | `list(object)` | `[]` | no | Define the private subnets configuration | `-` |

* Model of public_route_table_rules variable
```hcl
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
```

* Model of private_route_table_rules variable
```hcl
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
```

* Model of public_subnets variable
```hcl
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
    prohibit_public_ip_on_vnic = optional(string)
  }))
  default = [
    {
      name       = "tf-network-dev-sububnet-public-1"
      cidr_block = "10.1.1.0/24"
    }
  ]
}
```

* Model of private_subnets variable
```hcl
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
    prohibit_public_ip_on_vnic = optional(string)
  }))
  default = [
    {
      name       = "tf-network-dev-sububnet-private-1"
      cidr_block = "10.1.2.0/24"
    }
  ]
}
```

* Model of byoipv6cidr_details variable
```hcl
variable "byoipv6cidr_details" {
  description = "The list of BYOIPv6 OCIDs and BYOIPv6 CIDR blocks required to create a VCN that uses BYOIPv6 ranges"
  type = object({
    byoipv6range_id = string
    ipv6cidr_block  = string
  })
  default = null
}
```


## Resources

| Name | Type |
|------|------|
| [oci_core_virtual_network.create_vcn](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vcn.html) | resource |
| [oci_core_internet_gateway.create_internet_gateway](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_nat_gateway.create_nat_gateway](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_service_gateway.create_service_gateway](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_service_gateway) | resource |
| [oci_core_route_table.create_public_route_table](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_route_table.create_private_route_table](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_subnet.create_public_subnets](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_subnet.create_private_subnets](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |

## Outputs

| Name | Description |
|------|-------------|
| `vcn` | VCN |
| `vcn_id` | VCN ID |
| `internet_gateway` | Internet gateway |
| `internet_gateway_id` | Internet gateway ID |
| `nat_gateway` | NAT gateway |
| `nat_gateway_id` | NAT gateway ID |
| `service_gateway` | Service gateway |
| `service_gateway_id` | Service gateway ID |
| `public_route_table` | Public route table |
| `public_route_table_id` | Public route table ID |
| `private_route_table` | Private route table |
| `private_route_table_id` | Private route table ID |
| `public_subnets` | Public subnets |
| `public_subnets_ids` | Public subnets IDs |
| `private_subnets` | Private subnets |
| `private_subnets` | Private subnets |
| `private_subnets_ids` | Private subnets IDs |
