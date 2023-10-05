locals {
  vpc_id = element(
    concat(
      aws_vpc_ipv4_cidr_block_association.this.*.vpc_id,
      aws_vpc.vpc.*.id,
      [""],
    ),
    0,
  )
}

locals {
  tgw_subnets = [for k,v in aws_subnet.tgw: v.id]
}