variable "region" {
  default = "us-west-2"
}

variable "env" {
  default = "dev"
}

variable "vpc_name" {
  default = ""
}

variable "vpc_cidr" {
  default = ""
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_classiclink" {
  type    = bool
  default = null
}

variable "enable_classiclink_dns_support" {
  type    = bool
  default = null
}

variable "enable_ipv6" {
  type    = bool
  default = false
}

variable "vpc_tags" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type = map(string)
  default = {
    Terraform   = true
    Environment = "dev"
    Owner       = "Project DevOps Team"
  }
}

variable "azs" {
  type    = list(any)
  default = []
}

variable "data_subnets" {
  type    = list(any)
  default = []
}

variable "data_subnet_suffix" {
  type    = string
  default = "data"
}

variable "data_subnet_tags" {
  type = map(string)
  default = {
    DATA-subnet = true
  }
}

variable "data_subnet_assign_ipv6_address_on_creation" {
  type    = bool
  default = null
}

variable "data_subnet_ipv6_prefixes" {
  type    = list(string)
  default = []
}

variable "app_subnets" {
  type    = list(any)
  default = []
}

variable "app_subnet_suffix" {
  type    = string
  default = "app"
}

variable "app_subnet_tags" {
  type = map(string)
  default = {
    APP-subnet = true
  }
}

variable "app_subnet_assign_ipv6_address_on_creation" {
  type    = bool
  default = null
}

variable "app_subnet_ipv6_prefixes" {
  type    = list(string)
  default = []
}

variable "tgw_subnets" {
  type    = list(any)
  default = []
}

variable "tgw_subnet_suffix" {
  type    = string
  default = "tgw"
}

variable "tgw_subnet_tags" {
  type = map(string)
  default = {
    TGW-subnet = true
  }
}

variable "tgw_subnet_assign_ipv6_address_on_creation" {
  type    = bool
  default = null
}

variable "tgw_subnet_ipv6_prefixes" {
  type    = list(string)
  default = []
}

variable "manage_default_route_table" {
  type    = bool
  default = false
}

variable "default_route_table_propagating_vgws" {
  type    = list(string)
  default = []
}

variable "default_route_table_routes" {
  type    = list(map(string))
  default = []
}

variable "default_route_table_tags" {
  type    = map(string)
  default = {}
}

variable "create_vpc" {
  type    = bool
  default = true
}

variable "vpc_secondary_cidr" {
  type    = list(string)
  default = []
}

variable "assign_ipv6_address_on_creation" {
  type    = bool
  default = null
}