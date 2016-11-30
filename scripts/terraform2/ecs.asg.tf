data "template_file" "user_data" {
  template = "${file("userdata.tpl")}"

  vars {
    cluster_name = "${aws_ecs_cluster.tfci.name}"
  }
}

resource "aws_launch_configuration" "tfci" {
  name_prefix                 = "tfci-"
  image_id                    = "${lookup(var.amis, var.region)}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_pair_name}"
  associate_public_ip_address = true

  security_groups = [
    "${aws_security_group.tfci_web.id}",
  ]

  user_data            = "${data.template_file.user_data.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.tfci.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "tfci" {
  name                 = "tfci"
  launch_configuration = "${aws_launch_configuration.tfci.name}"
  max_size             = 8
  min_size             = 1
  availability_zones   = ["${var.availability_zones}"]
  vpc_zone_identifier  = ["${aws_subnet.tfci.*.id}"]

  tag {
    propagate_at_launch = true
    key                 = "Name"
    value               = "${aws_ecs_cluster.tfci.name}"
  }
}
