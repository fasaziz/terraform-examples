circuit_config = {
  "circuit_one" = {
    circuit_name          = "fii-prd-azer-spt-central-chicago-1"
    service_provider_name = "Level 3 Communications - Exchange"
    peering_location      = "Chicago"
    bandwidth_in_mbps     = 200
    tier                  = "Standard"
    family                = "MeteredData"

    route_filter = {
      route_filter_name = "fii-prd-azer-spt-centralus-rf"
      rule_name         = "fii-prd-azer-spt-centralus-rf-rule-bgp-communities"
      rule_access       = "Allow"
      rule_type         = "Community"
      rule_communities = [
        "12076:52004",
        "12076:54004",
        "12076:52005",
        "12076:54005",
        "12076:52009",
        "12076:54009",
        "12076:53005",
        "12076:53004",
        "12076:53009",
        "12076:5060",
        "12076:5050"
      ]
    }
  }
}

location = "UK South"

peering_config = {
  "ms_peering" = {
    peering_type                  = "MicrosoftPeering"
    peer_asn                      = 397991
    primary_peer_address_prefix   = "162.110.22.120/30"
    secondary_peer_address_prefix = "162.110.22.124/30"
    vlan_id                       = 70

    microsoft_peering_config = {
      advertised_public_prefixes = ["162.110.22.116/30"]
      customer_asn               = 397991
      routing_registry_name      = "ARIN"
      advertised_communities = [
        "12076:52004",
        "12076:54004",
        "12076:52005",
        "12076:54005",
        "12076:52009",
        "12076:54009",
        "12076:53005",
        "12076:53004",
        "12076:53009",
        "12076:5060",
        "12076:5050",
      ]
    }
  }
  "private_peering" = {
    peering_type                  = "AzurePrivatePeering"
    peer_asn                      = 397991
    primary_peer_address_prefix   = "162.110.22.108/30"
    secondary_peer_address_prefix = "162.110.22.112/30"
    vlan_id                       = 170

    microsoft_peering_config = {
      advertised_public_prefixes = []
      customer_asn               = 0
      routing_registry_name      = "NONE"
      advertised_communities     = []
    }
  }
}

# route_filter = {
#   "filter1" = {
#     route_filter_name = "fii-prd-azer-spt-centralus-rf"
#     rule_name         = "fii-prd-azer-spt-centralus-rf-rule-bgp-communities"
#     rule_access       = "Allow"
#     rule_type         = "Community"
#     rule_communities = [
#       "12076:52004",
#       "12076:54004",
#       "12076:52005",
#       "12076:54005",
#       "12076:52009",
#       "12076:54009",
#       "12076:53005",
#       "12076:53004",
#       "12076:53009",
#       "12076:5060",
#       "12076:5050"
#     ]
#   }
# }