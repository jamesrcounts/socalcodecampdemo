variable "access_key" {}

variable "secret_key" {}

variable "region" {
  default = "us-east-1"
}

variable "key_pair_name" {
  default = "demos-ci"
}

variable "amis" {
  type = "map"

  default = {
    us-east-1 = "ami-eca289fb"
    us-west-2 = "ami-7abc111a"
  }
}
