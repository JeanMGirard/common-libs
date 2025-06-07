#
#
#source "amazon-ebs" "flatcar" {
#  ami_name      = "ks8-flatcar"
#  instance_type = "t2.micro"
#  region        = var.aws_region
#
#  source_ami_filter {
#    filters = {
#      # name                = "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*"
#      name                = "Flatcar-stable-*"
#      root-device-type    = "ebs"
#      virtualization-type = "hvm"
#      architecture        = "x86_64"
#    }
#    most_recent = true
#    owners      = ["aws-marketplace"]
#  }
#  ssh_username = "core"
#}
#
#build {
#  name    = "build-ks8-flatcar"
#  sources = [
#    "source.amazon-ebs.flatcar"
#  ]
#}