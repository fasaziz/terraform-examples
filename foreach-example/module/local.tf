locals {
  circuit_names = { for circuit in var.circuit_config : circuit.circuit_name => circuit }
  peering_type = { for peer in var.peering_config : peer.peering_type => peer }
}