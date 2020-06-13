# Define ssh to config in instance

resource "openstack_compute_keypair_v2" "user_key" {
  name       = "jinho_key-2"
  public_key = file("~/.ssh/id_rsa.pub")
}

