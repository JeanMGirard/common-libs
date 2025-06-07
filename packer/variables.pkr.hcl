packer {
	required_plugins {
		amazon = {
			version = ">= 1.0.8"
			source  = "github.com/hashicorp/amazon"
		}
	}
}
#
#variable "aws_region" {
#  type        = string
#  default     = "us-east-1"
#}
