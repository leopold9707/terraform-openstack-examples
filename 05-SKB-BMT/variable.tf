#### OS IMAGE ####

variable "image" {
  type    = string
  default = "CentOS-7-1907"
}

data "openstack_images_image_v2" "centos_7" {
  name        = var.image
  most_recent = true
}

#### DNS ####

variable "dns_ip" {
  type    = list(string)
  default = ["8.8.8.8", "8.8.8.4"]
}

#### NODE parameters ####
variable "Admin" {
  type    = object(
    {
    flavor = string
    disk   = number
    count  = number
    })
  default = {
    flavor = "m1.medium"
    disk   = 80
    count  = 1
  }
}

variable "K8s-master" {
  type    = object(
    {
    flavor = string
    disk   = number
    count  = number
    })
  default = {
    flavor = "m1.medium"
    disk   = 40
    count  = 1
  }
}

variable "K8s-worker" {
  type    = object(
    {
    flavor = string
    disk   = number
    count  = number
    })
  default = {
    flavor = "m1.medium"
    disk   = 80
    count  = 4
  }
}

variable "Container-registry" {
  type    = object(
    {
    flavor = string
    disk   = number
    count  = number
    })
  default = {
    flavor = "m1.medium"
    disk   = 80
    count  = 1
  }
}

variable "External-backend" {
  type    = object(
    {
    flavor = string
    disk   = number
    count  = number
    })
  default = {
    flavor = "m1.medium"
    disk   = 80
    count  = 1
  }
}

variable "Ceph-storage" {
  type    = object(
    {
    flavor = string
    disk   = number
    count  = number
    })
  default = {
    flavor = "m1.medium"
    disk   = 100
    count  = 2
  }
}

#### EXTERNAL&INTERANL SUBNET CONFIG ####

variable "external-network" {
  type    = map(string)
  default = {
    subnet_name = "external-subnet"
    cidr        = "55.55.55.0/24"
  }
}

variable "internal-network" {
  type    = map(string)
  default = {
    subnet_name = "internal-subnet"
    cidr        = "10.10.10.0/24"
  }
}

######## Data Source ########

# get info about existing keypair on openstack
data "openstack_compute_keypair_v2" "user_key" {
  name = "jinho_key"
}

# get info about existing external_network(gateway)
data "openstack_networking_network_v2" "external_network" {
  name = "public-provider-97"
}

# get info about existing router
data "openstack_networking_router_v2" "jinho-router" {
  name = "jinho-router"
}

# get info about external security group
data "openstack_networking_secgroup_v2" "external" {
  name = "external"
}

# get info about internal security group
data "openstack_networking_secgroup_v2" "internal" {
  name = "internal"
}

# get info about ssh security group
data "openstack_networking_secgroup_v2" "ssh" {
  name = "ssh"
}

