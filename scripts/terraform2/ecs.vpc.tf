variable "cidr_blocks" {
  type        = "list"
  description = "CIDR blocks for subnets"

  default = [
    "10.0.0.0/20",
    "10.0.16.0/20",
    "10.0.32.0/20",
    "10.0.48.0/20",
  ]
}

variable "availability_zones" {
  type        = "list"
  description = "Availability zones for subnets"

  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c",
    "us-east-1e",
  ]
}

resource "aws_vpc" "tfci" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "tfci"
  }
}

resource "aws_subnet" "tfci" {
  vpc_id            = "${aws_vpc.tfci.id}"
  cidr_block        = "${var.cidr_blocks[count.index]}"
  availability_zone = "${var.availability_zones[count.index]}"

  tags {
    Name = "TFCI-${count.index}"
  }

  count = 4
}