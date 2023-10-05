resource "aws_vpc" "vpc" {

  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  enable_classiclink               = var.enable_classiclink
  enable_classiclink_dns_support   = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6

  tags = merge(
    {
      "Name" = var.vpc_name
    },
    var.tags,
    var.vpc_tags,
  )
}

resource "aws_subnet" "data" {
  count = var.create_vpc && length(var.data_subnets) > 0 ? length(var.data_subnets) : 0

  vpc_id                          = local.vpc_id
  cidr_block                      = var.data_subnets[count.index]
  availability_zone               = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id            = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  assign_ipv6_address_on_creation = var.data_subnet_assign_ipv6_address_on_creation == null ? var.assign_ipv6_address_on_creation : var.data_subnet_assign_ipv6_address_on_creation

  ipv6_cidr_block = var.enable_ipv6 && length(var.data_subnet_ipv6_prefixes) > 0 ? cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, var.data_subnet_ipv6_prefixes[count.index]) : null

  tags = merge(
    {
      "Name" = format(
        "%s-${var.data_subnet_suffix}-%s",
        var.vpc_name,
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.data_subnet_tags,
  )
}

resource "aws_subnet" "app" {
  count = var.create_vpc && length(var.app_subnets) > 0 ? length(var.app_subnets) : 0

  vpc_id                          = local.vpc_id
  cidr_block                      = var.app_subnets[count.index]
  availability_zone               = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id            = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  assign_ipv6_address_on_creation = var.app_subnet_assign_ipv6_address_on_creation == null ? var.assign_ipv6_address_on_creation : var.app_subnet_assign_ipv6_address_on_creation

  ipv6_cidr_block = var.enable_ipv6 && length(var.app_subnet_ipv6_prefixes) > 0 ? cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, var.app_subnet_ipv6_prefixes[count.index]) : null

  tags = merge(
    {
      "Name" = format(
        "%s-${var.app_subnet_suffix}-%s",
        var.vpc_name,
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.app_subnet_tags,
  )
}

resource "aws_subnet" "tgw" {
  count = var.create_vpc && length(var.tgw_subnets) > 0 ? length(var.tgw_subnets) : 0

  vpc_id                          = local.vpc_id
  cidr_block                      = var.tgw_subnets[count.index]
  availability_zone               = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id            = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  assign_ipv6_address_on_creation = var.tgw_subnet_assign_ipv6_address_on_creation == null ? var.assign_ipv6_address_on_creation : var.tgw_subnet_assign_ipv6_address_on_creation

  ipv6_cidr_block = var.enable_ipv6 && length(var.tgw_subnet_ipv6_prefixes) > 0 ? cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, var.tgw_subnet_ipv6_prefixes[count.index]) : null

  tags = merge(
    {
      "Name" = format(
        "%s-${var.tgw_subnet_suffix}-%s",
        var.vpc_name,
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.tgw_subnet_tags,
  )
}

resource "aws_default_route_table" "default_rt" {
  count = var.create_vpc && var.manage_default_route_table ? 1 : 0

  default_route_table_id = aws_vpc.vpc.default_route_table_id
  propagating_vgws       = var.default_route_table_propagating_vgws

  dynamic "route" {
    for_each = var.default_route_table_routes
    content {
      cidr_block      = route.value.cidr_block
      ipv6_cidr_block = lookup(route.value, "ipv6_cidr_block", null)

      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  tags = merge(
    { "Name" = var.vpc_name },
    var.tags,
    var.default_route_table_tags,
  )
  
}
resource "aws_vpc_ipv4_cidr_block_association" "this" {
  count = var.create_vpc && length(var.vpc_secondary_cidr) > 0 ? length(var.vpc_secondary_cidr) : 0

  vpc_id = aws_vpc.vpc.id

  cidr_block = element(var.vpc_secondary_cidr, count.index)
}

resource "aws_ec2_transit_gateway" "tgw" {
  description = "insight-tgw"
  tags = merge(
    {
      "Name" = format(
        "%s-${var.tgw_subnet_suffix}-%s",
        var.vpc_name,
        "tgw",
      )
    },
    var.tags,
    var.tgw_subnet_tags,
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  subnet_ids         = data.aws_subnet_ids.example.ids
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc.id
}
