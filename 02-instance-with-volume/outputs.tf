output fip_http {
  value = openstack_networking_floatingip_v2.http.address
}

output fip_db {
  value = openstack_networking_floatingip_v2.db.address
}
