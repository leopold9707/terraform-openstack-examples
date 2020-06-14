# Create external network port
resource "openstack_networking_port_v2" "ex-K8s-master" {
  count          = var.K8s-master.count
  name           = "external-K8s-master-${count.index}"
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
resource "openstack_networking_port_v2" "in-K8s-master" {
  count          = var.K8s-master.count
  name           = "internal-K8s-master-${count.index}"
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
resource "openstack_compute_instance_v2" "K8s-master" {
  count       = var.K8s-master.count
  name        = "K8s-master-${count.index}"
  image_name  = var.image
  flavor_name = var.K8s-master.flavor
  key_pair    = data.openstack_compute_keypair_v2.user_key.name
  user_data   = file("scripts/first-boot.sh")
  network {
    port = openstack_networking_port_v2.ex-K8s-master[count.index].id
  }
  network {
    port = openstack_networking_port_v2.in-K8s-master[count.index].id
  }
  block_device {
    volume_size           = var.K8s-master.disk
    destination_type      = "volume"
    delete_on_termination = true
    source_type           = "image"
    uuid                  = data.openstack_images_image_v2.centos_7.id
  }
}

# Create floating ip
resource "openstack_networking_floatingip_v2" "K8s-master" {
  count    = var.K8s-master.count
  pool     = data.openstack_networking_network_v2.external_network.name
}

# Attach floating ip to instance
resource "openstack_compute_floatingip_associate_v2" "external-K8s-master" {
  count       = var.K8s-master.count
  floating_ip = openstack_networking_floatingip_v2.K8s-master[count.index].address
  instance_id = openstack_compute_instance_v2.K8s-master[count.index].id
}
