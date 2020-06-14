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
    cidr        = "33.33.33.0/24"
  }
}

variable "http_instance_names" {
  type    = set(string)
  default = ["http-instance-1",
             "http-instance-2",
             "http-instance-3"]
}

#### VM DB parameters ####
variable "flavor_db" {
  type    = string
  default = "m1.medium"
}

variable "network_db" {
  type    = map(string)
  default = {
    subnet_name = "subnet-db"
    cidr        = "30.30.30.0/24"
  }
}

variable "db_instance_names" {
  type    = set(string)
  default = ["db-instance-1",
             "db-instance-2",
             "db-instance-3"]
}

## Data Source

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
  name = "external"
}

data "openstack_networking_secgroup_v2" "db" {
  name = "internal"
}

data "openstack_networking_secgroup_v2" "ssh" {
  name = "ssh"
}
