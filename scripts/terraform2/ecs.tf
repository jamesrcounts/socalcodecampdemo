resource "aws_ecs_cluster" "tfci" {
  name = "tfci"

  depends_on = [
    "aws_iam_user_policy_attachment.ecs_policy_attach",
  ]
}

resource "aws_iam_policy" "ecs_policy" {
  name        = "tf-ecs"
  description = "Allows terraform to operate on ECS"
  policy      = "${file("ecs.policy.json")}"
}

resource "aws_iam_user_policy_attachment" "ecs_policy_attach" {
  user       = "demos-terraform"
  policy_arn = "${aws_iam_policy.ecs_policy.arn}"
}

resource "aws_vpc" "tfci" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "tfci"
  }
}

resource "aws_alb_target_group" "tfci_web" {
  name     = "tfci-web"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.tfci.id}"
}

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

resource "aws_subnet" "tfci" {
  vpc_id            = "${aws_vpc.tfci.id}"
  cidr_block        = "${var.cidr_blocks[count.index]}"
  availability_zone = "${var.availability_zones[count.index]}"

  tags {
    Name = "TFCI-${count.index}"
  }

  count = 4
}

//resource "aws_alb" "tfci" {


//  name = "tfci"


//


//  security_groups = ["${aws_security_group.tfci_alb.id}"]


//


//  subnets = ["${aws_subnet.tfci.*.id}"]


//


//  tags {


//    Environment = "production"


//  }


//}

