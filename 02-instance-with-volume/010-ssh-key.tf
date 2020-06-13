## Define ssh to config in instance
#
#오픈스택 프로젝트에 이미 jinho_key가 생성되어있으므로 생성하지는 않는다.
#resource "openstack_compute_keypair_v2" "user_key" {
#  name       = "jinho_key"
#  public_key = file("~/.ssh/id_rsa.pub")
#}

