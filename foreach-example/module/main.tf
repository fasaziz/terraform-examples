
resource "azurerm_resource_group" "example" {
  name     = "fastest-rg"
  location = "UK South"
}


resource "azurerm_express_route_circuit" "circuitname" {
#   for_each              = var.circuit_config == {} ? {} : var.circuit_config
  for_each              = local.circuits
  name                  = each.value.circuit_name
  resource_group_name   = azurerm_resource_group.example.id
  location              = var.location
  service_provider_name = each.value.service_provider_name
  peering_location      = each.value.peering_location
  bandwidth_in_mbps     = each.value.bandwidth_in_mbps

  sku {
    tier   = each.value.tier
    family = each.value.family
  }

}

resource "azurerm_route_filter" "routefilter" {
#   for_each            = { for k, v in var.circuit_config : k => v if length(v.route_filter) > 0 }
#   for_each            = var.circuit_config == {} ? {} : var.circuit_config
  for_each            = local.circuit_names
  name                = each.value.route_filter.route_filter_name
  resource_group_name = azurerm_resource_group.example.id
  location            = azurerm_resource_group.example.location

    rule {
      name        = each.value.route_filter.rule_name
      access      = each.value.route_filter.rule_access
      rule_type   = each.value.route_filter.rule_type
      communities = each.value.route_filter.rule_communities
    }

}

resource "azurerm_express_route_circuit_peering" "peering" {
  for_each                   = local.peering_type
  peering_type               = each.value.peering_type
  express_route_circuit_name = local.circuit_names
  resource_group_name        = azurerm_resource_group.example.id
  peer_asn                   = each.value.peer_asn

  primary_peer_address_prefix   = each.value.primary_peer_address_prefix
  secondary_peer_address_prefix = each.value.secondary_peer_address_prefix
  vlan_id                       = each.value.vlan_id
  route_filter_id               = 


  microsoft_peering_config {
    advertised_public_prefixes = each.value.microsoft_peering_config.advertised_public_prefixes
    customer_asn               = each.value.microsoft_peering_config.customer_asn
    routing_registry_name      = each.value.microsoft_peering_config.routing_registry_name
    advertised_communities     = each.value.microsoft_peering_config.advertised_communities
  }
}

