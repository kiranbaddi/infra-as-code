resource "aws_vpc" "main" {
  cidr_block = var.VPC_CIDR_BLOCK
  tags = {
    name        = var.ENVIRONMENT != "" ? "${var.PREFIX}-${var.ENVIRONMENT}-VPC" : "${var.PREFIX}-VPC"
    environment = var.ENVIRONMENT != "" ? var.ENVIRONMENT : "Production"
  }
}


resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    name        = var.ENVIRONMENT != "" ? "${var.PREFIX}-${var.ENVIRONMENT}-VPC" : "${var.PREFIX}-VPC"
    environment = var.ENVIRONMENT != "" ? var.ENVIRONMENT : "Production"
  }

}

resource "aws_subnet" "nat_gateway" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.NAT_GATEWAY_CIDR_BLOCK
  map_public_ip_on_launch = true
}

resource "aws_subnet" "main" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.subnet_cidr
  map_public_ip_on_launch = each.value.public

  tags = {
    Name        = "${var.PREFIX}-${each.key}-subnet"
    Environment = var.ENVIRONMENT != "" ? var.ENVIRONMENT : "Production"
    Type        = each.value.public ? "public" : "private"
  }
}
resource "aws_nat_gateway" "main" {
  subnet_id     = aws_subnet.nat_gateway.id
  allocation_id = aws_eip.nat_gateway.id
  depends_on    = [aws_eip.nat_gateway]
}

resource "aws_eip" "nat_gateway" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.main]
}