terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

data "aws_key_pair" "this" {
  key_name = var.access_key_name
  filter {
    name   = "tag:Project"
    values = ["warden"]
  }
}

######
#VPC
######
resource "aws_vpc" "this" {
  cidr_block       = var.cidr
  instance_tenancy = "default"

  tags = merge(
    var.default_tags, {
      Name = "vw-vpc"
    }
  )
}

#Subnets
resource "aws_subnet" "this" {
  availability_zone = var.aval_zone
  cidr_block        = var.cidr
  vpc_id            = aws_vpc.this.id

  tags = merge(
    var.default_tags, {
      Name = format("vw-sbn-%s", var.aval_zone)
    }
  )
}

#Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.default_tags, {
      Name = "vw-gateway"
    }
  )
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    var.default_tags, {
      Name = "vw-route-table",
    }
  )
}
