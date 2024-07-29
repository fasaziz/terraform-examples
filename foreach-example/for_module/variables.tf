variable "circuit_config" {
  description = "express route circuit config"
  type = map(object({
    circuit_name          = string
    service_provider_name = string
    peering_location      = string
    bandwidth_in_mbps     = number
    tier                  = string
    family                = string

    route_filter = optional(object({
      route_filter_name = optional(string)
      rule_name         = optional(string)
      rule_access       = optional(string)
      rule_type         = optional(string)
      rule_communities  = optional(list(string))
    }))
  }))
}

variable "location" {
  type = string
}

# variable "environments" {
#   description = "environment name"
#   type        = map(string)
#   default = {
#     "dev"    = "development"
#     "stg"    = "staging"
#     "prd"    = "production"
#   }
# }

# variable "short_location" {
#   description = "location the resource is to be deployed to"
#   type        = string
#   default = "cus"
# }

# variable "locations" {
#   description = "Short location resolves to a region for the resources"
#   type        = map(string)
#   default = {
#     "uks"  = "uksouth"
#     "ukw"  = "ukwest"
#     "eus2" = "eastus2"
#     "wus2" = "westus2"
#     "cus"  = "centralus"
#   }
# }

variable "peering_config" {
  description = "Peering config"
  type = map(object({
    peering_type                  = string
    peer_asn                      = string
    primary_peer_address_prefix   = string
    secondary_peer_address_prefix = string
    vlan_id                       = number
    route_filter_key              = optional(string)

    microsoft_peering_config = object({
      advertised_public_prefixes = list(string)
      customer_asn               = string
      routing_registry_name      = string
      advertised_communities     = list(string)
    })
  }))
}

variable "gateway_config" {
  type = map(object({
    gateway_name      = optional(string)
    pip_name          = string
    gateway_subnet_id = optional(string)
    ip_config_snid    = optional(string)
    gateway_rg_locations = object({
      resource_group = string
      location       = string
    })
  }))
}

