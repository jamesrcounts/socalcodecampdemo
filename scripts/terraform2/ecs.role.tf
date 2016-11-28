resource "aws_iam_role" "tfci" {
  name               = "tfciRole"
  assume_role_policy = "${file("ecs.assume-role.policy.json")}"
  depends_on         = ["aws_iam_policy.ecs_policy"]
}

resource "aws_iam_role_policy_attachment" "profile_policy" {
  role       = "${aws_iam_role.tfci.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "tfci" {
  name  = "tfciInstanceProfile"
  roles = ["${aws_iam_role.tfci.name}"]
}

