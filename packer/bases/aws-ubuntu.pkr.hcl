variable "ami_prefix" {
	type    = string
	default = "k8s-rancher-ubuntu"
}
locals {
	timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


source "amazon-ebs" "ubuntu" {
	ami_name      = "${var.ami_prefix}-${local.timestamp}"
	instance_type = "t3.small"
	region        = "us-east-1"

	source_ami_filter {
		filters = {
			name                = "*/images/hvm-ssd/ubuntu-focal-20.04-amd64-minimal-*"
			root-device-type    = "ebs"
			virtualization-type = "hvm"
			architecture        = "x86_64"
			is-public           = true
			#      owner-alias         = "amazon"
			state               = "available"
		}
		most_recent = true
		owners      = [
			"amazon",
			"aws-marketplace"
		]
	}
	tags = {
		Name          = "K8S-Ubuntu"
		OS            = "Linux"
		Architecture  = "x86_64"
		Timestamp     = "${local.timestamp}"
		Base_AMI_ID   = "{{ .SourceAMI }}"
		Base_AMI_Name = "{{ .SourceAMIName }}"
	}
	ssh_username = "ubuntu"
}

build {
	name    = "${var.ami_prefix}-${local.timestamp}"
	sources = [
		"source.amazon-ebs.ubuntu"
	]

	provisioner "shell" {
		inline = [
			"sleep 30",
			# Updating
			"sudo apt update -y && sudo apt autoremove -y && sudo apt upgrade -y",
			# "sudo yum install -y unzip yum-tools tar",
			# Updating AWS CLI
			# "curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\" && unzip awscliv2.zip && sudo ./aws/install",
		]
	}
	#  provisioner "shell" {
	#    scripts = [
	#      "../scripts/install-awscli.sh",
	#      "../scripts/install-kubernetes.sh"
	#    ]
	#  }
}

#post-processors {
#  post-processor "compress" {}
#}
