# -------------------------- #
# Main VPC
# -------------------------- #

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.default_tags, {
    Name = "${var.service_name_lowercase}.main.vpc"
  })
}

# -------------------------- #
# Internet Gateway
# -------------------------- #

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.default_tags, {
    Name = "${var.service_name_lowercase}.main.igw"
  })
}

# -------------------------- #
# Public Subnets
# -------------------------- #

resource "aws_subnet" "public-a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = data.aws_availability_zones.az.names[0]

  tags = merge(var.default_tags, {
    Name = "${var.service_name_lowercase}.public-a.subnet"
  })
}

# -------------------------- #
# Public Route Table
# -------------------------- #

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.default_tags, {
    Name = "${var.service_name_lowercase}.public.rt"
  })
}

resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.public.id
}
