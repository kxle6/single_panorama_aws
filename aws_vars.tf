provider "aws" {
  access_key = "<access-key>"
  secret_key = "<secret-key>"
  region     = "${var.aws_region}"
}

data "aws_availability_zones" "available" {}

variable "aws_region" {
  default = "us-west-2"
}

variable "publicsubnetcidr" {
  default = "10.0.1.0/24"
}

variable "vpcname" {
  default = "panorama"
}

variable "vpccidr" {
  default = "10.0.0.0/16"
}

variable "serverkeyname" {
  default = "<ssh-key-name>"
}

variable "tags" {
  default = "panorama"
}

variable "panoramaregionmappanos812" {
  type = "map"

  default = {
    "ap-northeast-1" = "ami-bddaaa50"
    "ap-northeast-2" = "ami-172c9b79"
    "us-west-2"      = "ami-ba3a60c2"
    "us-west-1"      = "ami-c725c9a4"
    "ap-northeast-2" = "ami-59419037"
    "ap-southeast-1" = "ami-fec88814"
    "ap-southeast-2" = "ami-c7a001a5"
    "eu-central-1"   = "ami-05a7aaee"
    "eu-west-1"      = "ami-ef04e302"
    "eu-west-2"      = "ami-207f9547"
    "sa-east-1"      = "ami-0afabddf20fc7cea7"
    "us-east-1"      = "ami-68e8fc17"
    "us-east-2"      = "mi-389da75d"
    "ca-central-1"   = "ami-1d58d579"
    "ap-south-1"     = "ami-9ef6cbf1"
  }
}
