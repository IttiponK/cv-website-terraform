# create vpc 

resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_hostnames = true

    tags = {
      Name = "${var.project_name}-${var.environment}-vpc"
    }
}

resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.project_name}-${var.environment}-igw"
    }
}

data "aws_availability_zones" "available_zones" {}

resource "aws_subnet" "private_subnet_az1" {
    vpc_id = aws_vpc.vpc.id 
    cidr_block = "10.0.1.0/24"
    availability_zone = data.aws_availability_zones.available_zones.names[0]
    map_public_ip_on_launch = false 

    tags = {
      Name = "${var.project_name}-${var.environment}-private-subnet-az1"
    }
}

resource "aws_subnet" "public_subnet_az1" {
    vpc_id = aws_vpc.vpc.id 
    cidr_block = "10.0.2.0/24"
    availability_zone = data.aws_availability_zones.available_zones.names[0]
    map_public_ip_on_launch = true 

    tags = {
      Name = "${var.project_name}-${var.environment}-public-subnet-az1"
    }
  
}

resource "aws_route_table" "public_route_table_az1" {
    vpc_id = aws_vpc.vpc.id 

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

    tags = {
        Name = "${var.project_name}-${var.environment}-public-rt-az1"
    }
  
}

resource "aws_route_table_association" "public_route_association_az1" {
    subnet_id = aws_subnet.public_subnet_az1.id 
    route_table_id = aws_route_table.public_route_table_az1.id
  
}

resource "aws_eip" "eip1" {
    domain = "vpc"

    tags = {
        Name =  "${var.project_name}-${var.environment}-eip1"
    }
}

resource "aws_nat_gateway" "public_nat_az1" {
    allocation_id = aws_eip.eip1.id 
    subnet_id = aws_subnet.public_subnet_az1.id

    tags = {
        Name = "${var.project_name}-${var.environment}-ng-az1"
    }

    depends_on = [ aws_internet_gateway.internet_gateway ]
}

resource "aws_route_table" "private_route_table_az1" {
    vpc_id = aws_vpc.vpc.id 

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.public_nat_az1.id
    }

    tags = {
        Name = "${var.project_name}-${var.environment}-private-rt-az1"
    }
}

resource "aws_route_table_association" "private_route_association_az1" {
    subnet_id = aws_subnet.private_subnet_az1.id
    route_table_id = aws_route_table.private_route_table_az1.id
}


resource "aws_subnet" "private_subnet_az2" {
    vpc_id = aws_vpc.vpc.id 
    cidr_block = "10.0.3.0/24"
    availability_zone = data.aws_availability_zones.available_zones.names[1]
    map_public_ip_on_launch = false 

    tags = {
      Name = "${var.project_name}-${var.environment}-private-subnet-az2"
    }
}

resource "aws_subnet" "public_subnet_az2" {
    vpc_id = aws_vpc.vpc.id 
    cidr_block = "10.0.4.0/24"
    availability_zone = data.aws_availability_zones.available_zones.names[1]
    map_public_ip_on_launch = true 

    tags = {
      Name = "${var.project_name}-${var.environment}-public-subnet-az2"
    }
  
}

resource "aws_route_table" "public_route_table_az2" {
    vpc_id = aws_vpc.vpc.id 

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

    tags = {
        Name = "${var.project_name}-${var.environment}-public-rt-az2"
    }
  
}

resource "aws_route_table_association" "public_route_association_az2" {
    subnet_id = aws_subnet.public_subnet_az2.id 
    route_table_id = aws_route_table.public_route_table_az2.id
  
}

resource "aws_eip" "eip2" {
    domain = "vpc"

    tags = {
        Name =  "${var.project_name}-${var.environment}-eip2"
    }
}

resource "aws_nat_gateway" "public_nat_az2" {
    allocation_id = aws_eip.eip2.id 
    subnet_id = aws_subnet.public_subnet_az2.id

    tags = {
        Name = "${var.project_name}-${var.environment}-ng-az2"
    }

    depends_on = [ aws_internet_gateway.internet_gateway ]
}

resource "aws_route_table" "private_route_table_az2" {
    vpc_id = aws_vpc.vpc.id 

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.public_nat_az2.id
    }

    tags = {
        Name = "${var.project_name}-${var.environment}-private-rt-az2"
    }
}

resource "aws_route_table_association" "private_route_association_az2" {
    subnet_id = aws_subnet.private_subnet_az2.id
    route_table_id = aws_route_table.private_route_table_az2.id
}