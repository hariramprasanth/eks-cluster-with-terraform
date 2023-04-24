resource "aws_vpc" "my_vpc_test" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "my-vpc-test"
  }
}

resource "aws_subnet" "my_subnet_test_1" {
  vpc_id                  = aws_vpc.my_vpc_test.id
  cidr_block              = "10.0.0.0/26"
  availability_zone_id    = "aps1-az1"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-test-1"
    "kubernetes.io/cluster/my-web-server" = "shared"
  }
}
resource "aws_subnet" "my_subnet_test_2" {
  vpc_id                  = aws_vpc.my_vpc_test.id
  cidr_block              = "10.0.0.64/26"
  availability_zone_id    = "aps1-az2"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-test-2"
    "kubernetes.io/cluster/my-web-server" = "shared"

  }
}
resource "aws_subnet" "my_subnet_test_3" {
  vpc_id                  = aws_vpc.my_vpc_test.id
  cidr_block              = "10.0.0.128/26"
  availability_zone_id    = "aps1-az3"
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet-test-3"
    "kubernetes.io/cluster/my-web-server" = "shared"

  }
}
resource "aws_internet_gateway" "my_test_Ig" {
  vpc_id = aws_vpc.my_vpc_test.id


  tags = {
    Name = "my-test-ig"
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc_test.id

  tags = {
    Name = "my-test-route-table"
  }
}

resource "aws_route_table_association" "my_subnet_1_vpc_route_table_association" {
  subnet_id      = aws_subnet.my_subnet_test_1.id
  route_table_id = aws_route_table.my_route_table.id

}
resource "aws_route_table_association" "my_subnet_2_vpc_route_table_association" {
  subnet_id      = aws_subnet.my_subnet_test_2.id
  route_table_id = aws_route_table.my_route_table.id

}
resource "aws_route_table_association" "my_subnet_3_vpc_route_table_association" {
  subnet_id      = aws_subnet.my_subnet_test_3.id
  route_table_id = aws_route_table.my_route_table.id

}
resource "aws_route" "my_route" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_test_Ig.id
}

