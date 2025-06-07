variable "ami_prefix" {
	type    = string
	default = "k8s-rancher-ami2"
}
locals {
	timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


source "amazon-ebs" "amzn2" {
	ami_name      = "${var.ami_prefix}-${local.timestamp}"
	instance_type = "t2.micro"
	region        = "us-east-1"


  source_ami_filter {
    filters = {
      # name                = "amzn2-ami-ecs-hvm-*"
      # image-id            = "ami-0f80e6144aa24f34d" # ECS Optimized
      image-id            = "ami-09d3b3274b6c5d4aa" # Default
      root-device-type    = "ebs"
      virtualization-type = "hvm"
      architecture        = "x86_64"
      is-public           = true
      owner-alias         = "amazon"
      state               = "available"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  tags = {
    Name          = "K8S-Amzn2"
    OS            = "Linux"
    Architecture  = "x86_64"
    Timestamp     = "${local.timestamp}"
    Base_AMI_ID   = "{{ .SourceAMI }}"
    Base_AMI_Name = "{{ .SourceAMIName }}"
  }
  ssh_username = "ec2-user"
  # s3_bucket = "packer-images"
}

build {
	name    = "${var.ami_prefix}-${local.timestamp}"
	sources = [
		"source.amazon-ebs.amzn2"
	]

	provisioner "shell" {
		inline = [
			"sleep 30",
			# Updating
			"sudo yum update -y && sudo yum upgrade -y",
			"sudo yum install -y unzip yum-utils tar",
			# Updating AWS CLI
			# "curl \"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip\" -o \"awscliv2.zip\" && unzip awscliv2.zip && sudo ./aws/install",
		]
	}
	#  provisioner "shell" {
	#    env = {
	#      CNI_VERSION     = "v1.1.1",
	#      CRICTL_VERSION  = "v1.22.0",
	#      RELEASE_VERSION = "v0.4.0",
	#      ARCH            = "amd64",
	#      DOWNLOAD_DIR    = "/usr/local/bin"
	#    }
	#    environment_vars = [
	#      "CNI_VERSION=v1.1.1",
	#      "CRICTL_VERSION=v1.22.0",
	#      "RELEASE_VERSION=v0.4.0",
	#      "ARCH=amd64",
	#      "DOWNLOAD_DIR=/usr/local/bin"
	#    ]
	#    scripts = [
	##      "../scripts/install-awscli.sh",
	##      "../scripts/install-awscli.sh",
	#      # "../scripts/install-kubernetes.sh"
	#    ]
	#    #inline = [
	#      # Install eksctl
	#      #      'sudo curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | sudo tar xz -C /usr/local/bin',
	#      #      "sudo chmod +x /usr/local/bin/eksctl",
	#      # Install kubectl
	#      #      'sudo curl --silent --location -o /usr/local/bin/kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl',
	#      #      'sudo curl --silent --location -o /usr/local/bin/kubelet https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubelet',
	#      #      'sudo curl --silent --location -o /usr/local/bin/kube-proxy https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kube-proxy',
	#      #      "sudo chmod +x /usr/local/bin/kubelet /usr/local/bin/kubectl /usr/local/bin/kube-proxy",
	#      # Install kubeadm
	#      #      "sudo mkdir -p /opt/cni/bin $$DOWNLOAD_DIR /etc/systemd/system/kubelet.service.d",
	#      #      "curl -L \"https://github.com/containernetworking/plugins/releases/download/$${CNI_VERSION}/cni-plugins-linux-$${ARCH}-$${CNI_VERSION}.tgz\" | sudo tar -C /opt/cni/bin -xz",
	#      #      "curl -L \"https://github.com/kubernetes-sigs/cri-tools/releases/download/$${CRICTL_VERSION}/crictl-$${CRICTL_VERSION}-linux-$${ARCH}.tar.gz\" | sudo tar -C $$DOWNLOAD_DIR -xz",
	#      #      "RELEASE=\"$$(curl -sSL https://dl.k8s.io/release/stable.txt)\"",
	#      #      "cd $$DOWNLOAD_DIR",
	#      #      "sudo curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/$${RELEASE}/bin/linux/$${ARCH}/{kubeadm,kubelet,kubectl}",
	#      #      "sudo chmod +x {kubeadm,kubelet,kubectl}",
	#      #      "curl -sSL \"https://raw.githubusercontent.com/kubernetes/release/$${RELEASE_VERSION}/cmd/kubepkg/templates/latest/deb/kubelet/lib/systemd/system/kubelet.service\" | sed \"s:/usr/bin:$${DOWNLOAD_DIR}:g\" | sudo tee /etc/systemd/system/kubelet.service",
	#      #      "curl -sSL \"https://raw.githubusercontent.com/kubernetes/release/$${RELEASE_VERSION}/cmd/kubepkg/templates/latest/deb/kubeadm/10-kubeadm.conf\" | sed \"s:/usr/bin:$${DOWNLOAD_DIR}:g\" | sudo tee /etc/systemd/system/kubelet.service.d/10-kubeadm.conf",
	#
	#    #]
	#  }
}

#post-processors {
#  post-processor "compress" {}
#}
