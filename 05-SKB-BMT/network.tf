#### NETWORK CONFIGURATION ####

# Network creation
resource "openstack_networking_network_v2" "vpc" {
  name = "private-network-TACO"
}

#### EXTERNAL SUBNET CONFIGURATION

resource "openstack_networking_subnet_v2" "external" {
  name            = var.external-network["subnet_name"]
  network_id      = openstack_networking_network_v2.vpc.id
  cidr            = var.external-network["cidr"]
  dns_nameservers = var.dns_ip
}

# Router interface configuration
resource "openstack_networking_router_interface_v2" "external" {
  router_id = data.openstack_networking_router_v2.jinho-router.id
  subnet_id = openstack_networking_subnet_v2.external.id
}

#### INTERNAL SUBNET CONFIGURATION

resource "openstack_networking_subnet_v2" "internal" {
  name            = var.internal-network["subnet_name"]
  network_id      = openstack_networking_network_v2.vpc.id
  cidr            = var.internal-network["cidr"]
  dns_nameservers = var.dns_ip
}

