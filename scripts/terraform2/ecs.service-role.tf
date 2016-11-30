resource "aws_iam_role" "service" {
  name               = "tfciServiceRole"
  assume_role_policy = "${file("ecs.service-assume-role.policy.json")}"
  depends_on         = ["aws_iam_policy.ecs_policy"]
}

resource "aws_iam_role_policy_attachment" "service" {
  role       = "${aws_iam_role.service.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_instance_profile" "service" {
  name  = "tfciServiceProfile"
  roles = ["${aws_iam_role.service.name}"]
}
