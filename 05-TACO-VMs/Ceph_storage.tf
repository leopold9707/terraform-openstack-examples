# Create internal network port
resource "openstack_networking_port_v2" "in-Ceph-storage" {
  count          = var.Ceph-storage.count
  name           = "internal-Ceph-storage-${count.index}"
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
resource "openstack_compute_instance_v2" "Ceph-storage" {
  count       = var.Ceph-storage.count
  name        = "Ceph-storage-${count.index}"
  image_name  = var.image
  flavor_name = var.Ceph-storage.flavor
  key_pair    = data.openstack_compute_keypair_v2.user_key.name
  user_data   = file("scripts/first-boot.sh")
  network {
    port = openstack_networking_port_v2.in-Ceph-storage[count.index].id
  }
  block_device {
    volume_size           = var.Ceph-storage.disk
    destination_type      = "volume"
    delete_on_termination = true
    source_type           = "image"
    uuid                  = data.openstack_images_image_v2.centos_7.id
  }
}

