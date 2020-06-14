### Data Source ###

# 사용 가능한 외부망 네트워크
data "openstack_networking_network_v2" "external_gateway" {
  name = "public-provider-97" ##FIXME
}

### Resource ###

# 사용할 키페어
resource "openstack_compute_keypair_v2" "user_key" {
  name       = "jinho_key"
  public_key = file("~/.ssh/id_rsa.pub") ##FIXME
}

# Router 생성
resource "openstack_networking_router_v2" "router" {
  name                = "jinho-router"
  external_network_id = data.openstack_networking_network_v2.external_gateway.id
}

# 3가지 보안그룹 생성
resource "openstack_compute_secgroup_v2" "external" {
  name        = "external"
  description = "Open input external port"
  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "ssh" {
  name        = "ssh"
  description = "Open input ssh port"
  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_secgroup_v2" "internal" {
  name        = "internal"
  description = "Open input internal port"
  rule {
    from_port   = 3306
    to_port     = 3306
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}
