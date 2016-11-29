resource "aws_alb" "tfci" {
  name_prefix     = "tfci"
  security_groups = ["${aws_security_group.tfci_alb.id}"]
  subnets         = ["${aws_subnet.tfci.*.id}"]

  tags {
    Environment = "production"
  }
}

resource "aws_alb_target_group" "tfci_web" {
  name     = "tfci-web"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.tfci.id}"
}

resource "aws_alb_listener" "tfci" {
  "default_action" {
    target_group_arn = "${aws_alb_target_group.tfci_web.arn}"
    type             = "forward"
  }

  load_balancer_arn = "${aws_alb.tfci.arn}"
  port              = 80
  protocol          = "HTTP"
}
