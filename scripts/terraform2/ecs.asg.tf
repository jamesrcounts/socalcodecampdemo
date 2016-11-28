data "template_file" "user_data" {
  template = "${file("userdata.tpl")}"

  vars {
    cluster_name = "${aws_ecs_cluster.tfci.name}"
  }
}

resource "aws_launch_configuration" "tfci" {
  name                        = "tfci"
  image_id                    = "${lookup(var.amis, var.region)}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_pair_name}"
  associate_public_ip_address = false

  security_groups = [
    "${aws_security_group.tfci_web.id}",
  ]

  user_data            = "${data.template_file.user_data.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.tfci.name}"
}

resource "aws_autoscaling_group" "tfci" {
  name                 = "tfci"
  launch_configuration = "${aws_launch_configuration.tfci.name}"
  max_size             = 8
  min_size             = 1
  availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]

  tag {
    propagate_at_launch = true
    key                 = "Name"
    value               = "${aws_ecs_cluster.tfci.name}"
  }
}
