variable "ami_prefix" {
	type    = string
	default = "k8s-rancher-suse"
}
variable "node_username" {
	type    = string
	default = "ec2-user"
}
locals {
	timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


source "amazon-ebs" "suse" {
	ami_name      = "${var.ami_prefix}-${local.timestamp}"
	instance_type = "t3.small"
	region        = "us-east-1"

	source_ami_filter {
		filters = {
			name                = "*suse-sles-15-sp3*"
			root-device-type    = "ebs"
			virtualization-type = "hvm"
			architecture        = "x86_64"
			is-public           = true
			state               = "available"
		}
		most_recent = true
		owners      = ["013907871322"] # SUSE
	}
	tags = {
		Name          = var.ami_prefix
		OS            = "Linux"
		Architecture  = "x86_64"
		Timestamp     = "${local.timestamp}"
		Base_AMI_ID   = "{{ .SourceAMI }}"
		Base_AMI_Name = "{{ .SourceAMIName }}"
	}
	ssh_username = var.node_username
}

build {
	name    = "${var.ami_prefix}-${local.timestamp}"
	sources = [
		"source.amazon-ebs.suse"
	]
	provisioner "shell" {
		scripts = [
			"../scripts/init.sh",
			"../scripts/init_update.sh",
			"../scripts/bases/suse.sh",
			"../scripts/setups/swapoff.sh",
			"../scripts/setups/tcp-forwarding.sh",
			"../scripts/setups/iptables.bridged-traffic.sh",
			"../scripts/installers/awscli.sh",
			"../scripts/installers/kubectl.sh",
			"../scripts/installers/eksctl.sh",
			"../scripts/installers/helm.sh",
			"../scripts/installers/istioctl.sh",
			#      "../scripts/installers/rke2.sh",
			#      "../scripts/installers/k3s.sh"
		]
	}
}
