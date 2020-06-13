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

#### VM parameters
variable "flavor_http" {
  type    = string
  default = "m1.medium"
}

variable "network_http" {
  type    = map(string)
  default = {
    subnet_name = "subnet-http"
    cidr        = "11.11.11.0/24"
  }
}

