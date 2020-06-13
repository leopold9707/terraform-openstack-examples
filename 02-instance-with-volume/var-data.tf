# Params file for variables

#### GLANCE
variable "image" {
  type    = string
  default = "CentOS-7-1907"
}

variable "dns_ip" {
  type    = list(string)
  default = ["8.8.8.8", "8.8.8.4"]
}

#### VM HTTP parameters ####
variable "flavor_http" {
  type    = string
  default = "m1.medium"
}

variable "network_http" {
  type    = map(string)
  default = {
    subnet_name = "subnet-http"
    cidr        = "22.22.22.0/24"
  }
}

#### MAIN DISK SIZE FOR HTTP
variable "volume_http" {
  type    = number
  default = 50
}

#### VM DB parameters ####
variable "flavor_db" {
  type    = string
  default = "m1.medium"
}

#### ATTACHED VOLUME PARAMS
variable "volume_db" {
  type    = number
  default = 30
}

# Data Source

data "openstack_compute_keypair_v2" "user_key" {
  name = "jinho_key"
}

data "openstack_networking_network_v2" "external_network" {
  name = "public-provider-97"
}

data "openstack_networking_router_v2" "jinho-router" {
  name = "jinho-router"
}

data "openstack_networking_secgroup_v2" "http" {
  name = "http"
}

data "openstack_networking_secgroup_v2" "db" {
  name = "db"
}

data "openstack_networking_secgroup_v2" "ssh" {
  name = "ssh"
}
