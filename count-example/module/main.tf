
resource "azurerm_resource_group" "example" {
  name     = "fastest-rg"
  location = "UK South"
}


resource "azurerm_express_route_circuit" "circuitname" {
  count                 = length(keys(var.circuit_config))
  name                  = var.circuit_config[keys(var.circuit_config)[count.index]].circuit_name
  resource_group_name   = azurerm_resource_group.example.id
  location              = var.location
  service_provider_name = var.circuit_config[keys(var.circuit_config)[count.index]].service_provider_name
  peering_location      = var.circuit_config[keys(var.circuit_config)[count.index]].peering_location
  bandwidth_in_mbps     = var.circuit_config[keys(var.circuit_config)[count.index]].bandwidth_in_mbps

  sku {
    tier   = var.circuit_config[keys(var.circuit_config)[count.index]].tier
    family = var.circuit_config[keys(var.circuit_config)[count.index]].family
  }

}

resource "azurerm_route_filter" "routefilter" {
  #   for_each            = { for k, v in var.circuit_config : k => v if length(v.route_filter) > 0 }
  #   for_each            = var.circuit_config == {} ? {} : var.circuit_config
  count               = length(keys(var.circuit_config))
  name                = var.circuit_config[keys(var.circuit_config)[count.index]].route_filter.route_filter_name
  resource_group_name = azurerm_resource_group.example.id
  location            = azurerm_resource_group.example.location

  rule {
    name        = var.circuit_config[keys(var.circuit_config)[count.index]].route_filter.rule_name
    access      = var.circuit_config[keys(var.circuit_config)[count.index]].route_filter.rule_access
    rule_type   = var.circuit_config[keys(var.circuit_config)[count.index]].route_filter.rule_type
    communities = var.circuit_config[keys(var.circuit_config)[count.index]].route_filter.rule_communities
  }

}

resource "azurerm_express_route_circuit_peering" "peering" {
  count                      = length(keys(var.peering_config))
  peering_type               = var.peering_config[keys(var.peering_config)[count.index]].peering_type
  express_route_circuit_name = element(azurerm_express_route_circuit.circuitname.*.name, count.index)
  resource_group_name        = azurerm_resource_group.example.id
  peer_asn                   = var.peering_config[keys(var.peering_config)[count.index]].peer_asn

  primary_peer_address_prefix   = var.peering_config[keys(var.peering_config)[count.index]].primary_peer_address_prefix
  secondary_peer_address_prefix = var.peering_config[keys(var.peering_config)[count.index]].secondary_peer_address_prefix
  vlan_id                       = var.peering_config[keys(var.peering_config)[count.index]].vlan_id
  route_filter_id               = element(azurerm_route_filter.routefilter.*.id, count.index)


  microsoft_peering_config {
    advertised_public_prefixes = var.peering_config[keys(var.peering_config)[count.index]].microsoft_peering_config.advertised_public_prefixes
    customer_asn               = var.peering_config[keys(var.peering_config)[count.index]].microsoft_peering_config.customer_asn
    routing_registry_name      = var.peering_config[keys(var.peering_config)[count.index]].microsoft_peering_config.routing_registry_name
    advertised_communities     = var.peering_config[keys(var.peering_config)[count.index]].microsoft_peering_config.advertised_communities
  }
}

resource "azurerm_public_ip" "publicip" {
  count               = length(keys(var.gateway_config))
  name                = var.gateway_config[keys(var.gateway_config)[count.index]].pip_name
  location            = var.gateway_config[keys(var.gateway_config)[count.index]].gateway_rg_locations.location
  resource_group_name = var.gateway_config[keys(var.gateway_config)[count.index]].gateway_rg_locations.resource_group
  allocation_method   = "Static"
  domain_name_label   = var.gateway_config[keys(var.gateway_config)[count.index]].pip_name
  sku                 = "Standard"
  zones               = ["1", "2", "3"]

}

resource "azurerm_virtual_network_gateway" "virtualnwg" {
  count               = length(keys(var.gateway_config))
  name                = keys(var.gateway_config)[count.index]
  location            = var.gateway_config[keys(var.gateway_config)[count.index]].gateway_rg_locations.location
  resource_group_name = var.gateway_config[keys(var.gateway_config)[count.index]].gateway_rg_locations.resource_group

  type     = "ExpressRoute"
  vpn_type = "PolicyBased"

  active_active               = false
  enable_bgp                  = false
  sku                         = "ErGw1AZ"
  remote_vnet_traffic_enabled = true
  virtual_wan_traffic_enabled = true

  ip_configuration {
    name                          = "default"
    public_ip_address_id          = azurerm_public_ip.publicip[count.index].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gateway_config[keys(var.gateway_config)[count.index]].ip_config_snid

  }
  depends_on = [
    azurerm_public_ip.publicip
  ]
}