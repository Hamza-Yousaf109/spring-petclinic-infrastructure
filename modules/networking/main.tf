locals {
  common_tags = merge(var.tags, {
    Project     = var.name
    Environment = var.environment
  })

  subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_vpc" "petclinic" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.name}-vpc"
  })

  lifecycle {
    prevent_destroy = false

    precondition {
      condition     = length(var.availability_zones) == length(var.public_subnet_cidrs) && length(var.availability_zones) == length(var.private_subnet_cidrs)
      error_message = "availability_zones, public_subnet_cidrs, and private_subnet_cidrs must have equal lengths."
    }

    precondition {
      condition = alltrue([
        for cidr in concat(var.public_subnet_cidrs, var.private_subnet_cidrs) : can(cidrhost(cidr, 0))
      ])
      error_message = "All public and private subnet values must be valid CIDRs."
    }
  }
}

resource "aws_internet_gateway" "petclinic" {
  vpc_id = aws_vpc.petclinic.id

  tags = merge(local.common_tags, {
    Name = "${var.name}-igw"
  })
}

resource "aws_subnet" "public" {
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.petclinic.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, local.subnet_tags, {
    Name                     = "${var.name}-public-${var.availability_zones[count.index]}"
    "kubernetes.io/role/elb" = "1"
  })
}

resource "aws_subnet" "private" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.petclinic.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(local.common_tags, local.subnet_tags, {
    Name                              = "${var.name}-private-${var.availability_zones[count.index]}"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.petclinic.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.petclinic.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.name}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count  = var.nat_gateway_count
  domain = "vpc"

  depends_on = [aws_internet_gateway.petclinic]

  tags = merge(local.common_tags, {
    Name = "${var.name}-nat-eip-${count.index + 1}"
  })
}

resource "aws_nat_gateway" "petclinic" {
  count = var.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  depends_on = [aws_internet_gateway.petclinic]

  tags = merge(local.common_tags, {
    Name = "${var.name}-nat-${count.index + 1}"
  })
}

resource "aws_route_table" "private" {
  count = var.single_nat_gateway ? 1 : length(var.availability_zones)

  vpc_id = aws_vpc.petclinic.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.petclinic[var.single_nat_gateway ? 0 : count.index].id
  }

  tags = merge(local.common_tags, {
    Name = "${var.name}-private-rt-${count.index + 1}"
  })
}

resource "aws_route_table_association" "private" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[var.single_nat_gateway ? 0 : count.index].id
}