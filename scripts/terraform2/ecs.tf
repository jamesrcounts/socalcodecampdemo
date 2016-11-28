resource "aws_ecs_cluster" "tfci" {
  name       = "tfci"
  depends_on = ["aws_iam_user_policy_attachment.ecs_policy_attach"]
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

