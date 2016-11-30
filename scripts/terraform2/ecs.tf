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

variable "build_label" {}

data "template_file" "task-web" {
  template = "${file("task-definitions/tfci-web.json")}"

  vars {
    TASK_NAME = "${aws_ecr_repository.tfci_ecr.name}"
    IMAGE_URL = "${replace(aws_ecr_repository.tfci_ecr.repository_url, "https://", "")}:1.0.${var.build_label}"
  }
}

resource "aws_ecs_task_definition" "web" {
  family                = "tfci-web"
  container_definitions = "${data.template_file.task-web.rendered}"
}

resource "aws_ecs_service" "tfci" {
  name            = "tfci"
  cluster         = "${aws_ecs_cluster.tfci.id}"
  task_definition = "${aws_ecs_task_definition.web.arn}"
  desired_count   = 2
  iam_role        = "${aws_iam_role.service.arn}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.tfci_web.arn}"
    container_name   = "${aws_ecr_repository.tfci_ecr.name}"
    container_port   = 3000
  }
}
