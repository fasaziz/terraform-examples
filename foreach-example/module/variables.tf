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

variable "peering_config" {
  description = "Peering config"
  type = map(object({
    peering_type                  = string
    peer_asn                      = string
    primary_peer_address_prefix   = string
    secondary_peer_address_prefix = string
    vlan_id                       = number

    microsoft_peering_config      = object({
      advertised_public_prefixes = list(string)
      customer_asn = string
      routing_registry_name = string
      advertised_communities = list(string)
    })
  }))
}
