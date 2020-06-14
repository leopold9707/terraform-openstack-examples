#### INSTANCE HTTP ####
#
# Create instance
#
resource "openstack_compute_instance_v2" "http" {
  name        = "http"
  image_name  = var.image
  flavor_name = var.flavor_http
  key_pair    = data.openstack_compute_keypair_v2.user_key.name
  user_data   = file("scripts/first-boot.sh")
  network {
    port = openstack_networking_port_v2.http.id
  }
}

# Create network port
resource "openstack_networking_port_v2" "http" {
  name           = "port-instance-http"
  network_id     = openstack_networking_network_v2.vpc.id
  admin_state_up = true
  security_group_ids = [
    data.openstack_networking_secgroup_v2.ssh.id,
    data.openstack_networking_secgroup_v2.external.id,
  ]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.http.id
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "http" {
  pool = data.openstack_networking_network_v2.external_network.name
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "http" {
  floating_ip = openstack_networking_floatingip_v2.http.address
  instance_id = openstack_compute_instance_v2.http.id
}

