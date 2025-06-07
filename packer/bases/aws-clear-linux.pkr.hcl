#
#
#variable "ami_prefix" {
#  type    = string
#  default = "k8s-rancher-coreos"
#}
#variable "node_username" {
#  type    = string
#  default = "fedora"
#}
#locals {
#  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
#}
#
#
#
#source "amazon-ebs" "fedora" {
#  ami_name      = "${var.ami_prefix}-${local.timestamp}"
#  instance_type = "t3.small"
#  region        = "us-east-1"
#
#  source_ami_filter {
#    filters = {
#      name = "*Fedora-Cloud-Base-3*"
#      # image_id            = "ami-0883f2d26628ad0cf"
#      root-device-type    = "ebs"
#      virtualization-type = "hvm"
#      architecture        = "x86_64"
#      is-public           = true
#      state               = "available"
#
#    }
#    most_recent = true
#    owners      = ["aws-marketplace"]
#  }
#  tags = {
#    Name          = var.ami_prefix
#    OS            = "Linux"
#    Architecture  = "x86_64"
#    Timestamp     = "${local.timestamp}"
#    Base_AMI_ID   = "{{ .SourceAMI }}"
#    Base_AMI_Name = "{{ .SourceAMIName }}"
#  }
#  ssh_username            = var.node_username
#  temporary_key_pair_type = "ed25519"
#  # insecure_skip_tls_verify=true
#  # pause_before_connecting="15s"
#  # temporary_key_pair_type (string) - dsa | ecdsa | ed25519 | rsa ( the default )
#  #  ssh_keypair_name = ""
#  #  ssh_private_key_file="~/.ssh/id_rsa"
#  # ssh_password =
#  # ssh_ciphers=[ "aes128-gcm@openssh.com", "chacha20-poly1305@openssh.com", "aes128-ctr", "aes192-ctr", "aes256-ctr", ]
#  # communicator = "ssh"
#}
#
#build {
#  name = "${var.ami_prefix}-${local.timestamp}"
#  sources = [
#    "source.amazon-ebs.fedora"
#  ]
#  provisioner "shell" {
#    scripts = [
#      "../scripts/init.sh",
#      "../scripts/init_update.sh",
#      "../scripts/bases/coreos.sh",
#      "../scripts/setups/swapoff.sh",
#      "../scripts/setups/tcp-forwarding.sh",
#      "../scripts/setups/iptables.bridged-traffic.sh",
#      "../scripts/installers/awscli.sh",
#      "../scripts/installers/kubectl.sh",
#      "../scripts/installers/eksctl.sh",
#      "../scripts/installers/helm.sh",
#      "../scripts/installers/istioctl.sh",
##      "../scripts/installers/rke2.sh",
##      "../scripts/installers/k3s.sh"
#    ]
#  }
#}
