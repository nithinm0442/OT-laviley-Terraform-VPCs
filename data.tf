data "aws_subnet_ids" "example" {
  vpc_id = aws_vpc.vpc.*.id
}