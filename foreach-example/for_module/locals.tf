# locals {
#   circuit_names = { for key, value in var.circuit_config : value.circuit_name => value }
#   map = merge(var.circuit_config, var.peering_config)
# }

# output "c" {
#   value = local.circuit_names
#}
#  + c = {
#       + fii-prd-azer-spt-central-chicago-1 = {
#           + bandwidth_in_mbps     = 200
#           + circuit_name          = "fii-prd-azer-spt-central-chicago-1"
#           + family                = "MeteredData"
#           + peering_location      = "Chicago"
#           + route_filter          = {
#               + route_filter_name = "fii-prd-azer-spt-centralus-rf"
#               + rule_access       = "Allow"
#               + rule_communities  = [
#                   + "12076:52004",
#                   + "12076:54004",
#                   + "12076:52005",
#                   + "12076:54005",
#                   + "12076:52009",
#                   + "12076:54009",
#                   + "12076:53005",
#                   + "12076:53004",
#                   + "12076:53009",
#                   + "12076:5060",
#                   + "12076:5050",
#                 ]
#               + rule_name         = "fii-prd-azer-spt-centralus-rf-rule-bgp-communities"
#               + rule_type         = "Community"
#             }
#           + service_provider_name = "Level 3 Communications - Exchange"
#           + tier                  = "Standard"
#         }