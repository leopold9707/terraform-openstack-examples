# Create external network port
resource "openstack_networking_port_v2" "ex-Admin" {
  count          = var.Admin.count
  name           = "external-Admin-${count.index}"
  network_id     = openstack_networking_network_v2.vpc.id
  admin_state_up = true
  security_group_ids = [
    data.openstack_networking_secgroup_v2.ssh.id,
    data.openstack_networking_secgroup_v2.external.id
  ]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.external.id
  }
}

# Create internal network port
resource "openstack_networking_port_v2" "in-Admin" {
  count          = var.Admin.count
  name           = "internal-Admin-${count.index}"
  network_id     = openstack_networking_network_v2.vpc.id
  admin_state_up = true
  security_group_ids = [
    data.openstack_networking_secgroup_v2.ssh.id,
    data.openstack_networking_secgroup_v2.internal.id
  ]
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.internal.id
  }
}

# Create instance
#
resource "openstack_compute_instance_v2" "Admin" {
  count       = var.Admin.count
  name        = "Admin-${count.index}"
  image_name  = var.image
  flavor_name = var.Admin.flavor
  key_pair    = data.openstack_compute_keypair_v2.user_key.name
  user_data   = file("scripts/first-boot.sh")
  network {
    port = openstack_networking_port_v2.ex-Admin[count.index].id
  }
  network {
    port = openstack_networking_port_v2.in-Admin[count.index].id
  }
  block_device {
    volume_size           = var.Admin.disk
    destination_type      = "volume"
    delete_on_termination = true
    source_type           = "image"
    uuid                  = data.openstack_images_image_v2.centos_7.id
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "Admin" {
  count    = var.Admin.count
  pool     = data.openstack_networking_network_v2.external_network.name
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "external-master" {
  count       = var.Admin.count
  floating_ip = openstack_networking_floatingip_v2.Admin[count.index].address
  instance_id = openstack_compute_instance_v2.Admin[count.index].id
}
