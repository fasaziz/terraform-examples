
resource "azurerm_resource_group" "example" {
  name     = "fastest-rg"
  location = "UK South"
}


resource "azurerm_express_route_circuit" "circuitname" {
  for_each              = var.circuit_config == {} ? {} : var.circuit_config
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
  for_each            = var.circuit_config == {} ? {} : var.circuit_config
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
  for_each                   = var.peering_config == {} ? {} : var.peering_config
  peering_type               = each.value.peering_type
  express_route_circuit_name = "test"
  resource_group_name        = azurerm_resource_group.example.id
  peer_asn                   = each.value.peer_asn

  primary_peer_address_prefix   = each.value.primary_peer_address_prefix
  secondary_peer_address_prefix = each.value.secondary_peer_address_prefix
  vlan_id                       = each.value.vlan_id
  route_filter_id               = each.value.peering_type == "MicrosoftPeering" ? azurerm_route_filter.routefilter[each.value.route_filter_key].id : null


  microsoft_peering_config {
    advertised_public_prefixes = each.value.microsoft_peering_config.advertised_public_prefixes
    customer_asn               = each.value.microsoft_peering_config.customer_asn
    routing_registry_name      = each.value.microsoft_peering_config.routing_registry_name
    advertised_communities     = each.value.microsoft_peering_config.advertised_communities
  }
}

resource "azurerm_public_ip" "publicip" {
  for_each            = var.gateway_config == {} ? {} : var.gateway_config
  name                = each.value.pip_name
  location            = each.value.gateway_rg_locations.location
  resource_group_name = each.value.gateway_rg_locations.resource_group
  allocation_method   = "Static"
  domain_name_label   = each.value.pip_name
  sku                 = "Standard"
  zones               = ["1", "2", "3"]

}

resource "azurerm_virtual_network_gateway" "virtualnwg" {
  for_each            = var.gateway_config == {} ? {} : var.gateway_config
  name                = each.key
  location            = each.value.gateway_rg_locations.location
  resource_group_name = each.value.gateway_rg_locations.resource_group

  type     = "ExpressRoute"
  vpn_type = "PolicyBased"

  active_active               = false
  enable_bgp                  = false
  sku                         = "ErGw1AZ"
  remote_vnet_traffic_enabled = true
  virtual_wan_traffic_enabled = true

  ip_configuration {
    name                          = "default"
    public_ip_address_id          = azurerm_public_ip.publicip[each.key].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = each.value.ip_config_snid

  }
  depends_on = [
    azurerm_public_ip.publicip
  ]
}