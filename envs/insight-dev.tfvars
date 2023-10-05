region = "us-west-2"
# cidr_blocks= ["10.0.0.0/8"]
#########VPC Variables#############
env                        = "insight-dev"
vpc_name                   = "insight-dev-vpc"
vpc_cidr                   = "10.174.32.0/19"
enable_dns_hostnames       = true
enable_dns_support         = true
azs                        = ["us-west-2a", "us-west-2b", "us-west-2c"]
data_subnets               = ["10.174.44.0/23","10.174.46.0/23","10.174.48.0/23"]
app_subnets                = ["10.174.34.0/23","10.174.36.0/23","10.174.38.0/23"]
tgw_subnets                = ["10.174.32.0/28","10.174.32.16/28","10.174.32.32/28"]
manage_default_route_table = true
default_route_table_tags   = { DefaultRouteTable = true }
