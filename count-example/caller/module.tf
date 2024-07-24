module "express_route" {
  source         = "../module"
  circuit_config = var.circuit_config
  location       = var.location
  peering_config = var.peering_config
  gateway_config = var.gateway_config
}

# locals {
#   c_map = merge(var.circuit_config, var.peering_config)
#   circuit_names = { for circuit in var.circuit_config : circuit.circuit_name => circuit }
#   peering_type = { for peer in var.peering_config : peer.peering_type => peer }

# }

# output "circuit_names" {
#     value = local.circuit_names
# }
