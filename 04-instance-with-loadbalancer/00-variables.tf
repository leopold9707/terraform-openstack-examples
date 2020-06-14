# Params file for variables

#### GLANCE
variable "image" {
  type    = string
  default = "CentOS-7-1907"
}

#### NEUTRON
variable "external_network" {
  type    = string
  default = "public-provider-97"
}

# UUID of external gateway
variable "external_gateway" {
  type    = string
  default = "e98e5ab1-1775-46bb-8a7b-ae1ced2950ff"
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
    subnet_name = "subnet-http-4"
    cidr        = "44.44.44.0/24"
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
    cidr        = "40.40.40.0/24"
  }
}

variable "db_instance_names" {
  type    = set(string)
  default = ["db-instance-1",
             "db-instance-2",
             "db-instance-3"]
}
