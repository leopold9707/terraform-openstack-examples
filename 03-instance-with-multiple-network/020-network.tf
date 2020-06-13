#### NETWORK CONFIGURATION ####

# Network creation
resource "openstack_networking_network_v2" "vpc" {
  name = "private-network-3"
}

#### HTTP SUBNET ####

# Subnet http configuration
resource "openstack_networking_subnet_v2" "http" {
  name            = var.network_http["subnet_name"]
  network_id      = openstack_networking_network_v2.vpc.id
  cidr            = var.network_http["cidr"]
  dns_nameservers = var.dns_ip
}

# Router interface configuration
resource "openstack_networking_router_interface_v2" "http" {
  router_id = data.openstack_networking_router_v2.jinho-router.id
  subnet_id = openstack_networking_subnet_v2.http.id
}

#### DB SUBNET ####

# Subnet db configuration
resource "openstack_networking_subnet_v2" "db" {
  name            = var.network_db["subnet_name"]
  network_id      = openstack_networking_network_v2.vpc.id
  cidr            = var.network_db["cidr"]
  dns_nameservers = var.dns_ip
}

# Router interface configuration
resource "openstack_networking_router_interface_v2" "db" {
  router_id = data.openstack_networking_router_v2.jinho-router.id
  subnet_id = openstack_networking_subnet_v2.db.id
}

