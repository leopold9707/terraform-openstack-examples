output "Admin_VM_fip" {
  value = openstack_networking_floatingip_v2.Admin[*].address
}

output "Master_VM_fip" {
  value = openstack_networking_floatingip_v2.K8s-master[*].address
}

output "Worker_VM_fip" {
  value = openstack_networking_floatingip_v2.K8s-worker[*].address
}
