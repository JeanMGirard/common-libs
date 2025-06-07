

packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source = "github.com/hashicorp/amazon"
    }
  }
}


variable "region" {
  type    = string
  default = "us-east-1"
}


locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


source "amazon-ebs" "windows-2012R2" {
  ami_name      = "win-server_base--${local.timestamp}"
  communicator  = "winrm"
  instance_type = "t3a.small"
  region        = "${var.region}"

  source_ami_filter {
    filters = {
      name                = "Windows_Server-2012-R2*English-64Bit-Base*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  user_data_file = "./userdata/bootstrap_win.txt"
  winrm_password = "SuperS3cr3t!!!!"
  winrm_username = "Administrator"
}



# a build block invokes sources and runs provisioning steps on them.
build {
  name    = "packer_win-server_base"
  sources = ["source.amazon-ebs.windows-2012R2"]

  provisioner "powershell" {
    environment_vars = ["DEVOPS_LIFE_IMPROVER=PACKER"]
    inline           = ["Write-Host \"HELLO NEW USER; WELCOME TO $Env:DEVOPS_LIFE_IMPROVER\"", "Write-Host \"You need to use backtick escapes when using\"", "Write-Host \"characters such as DOLLAR`$ directly in a command\"", "Write-Host \"or in your own scripts.\""]
  }

  provisioner "windows-restart" {  }

  provisioner "powershell" {
    environment_vars = ["VAR1=A$Dollar", "VAR2=A`Backtick", "VAR3=A'SingleQuote", "VAR4=A\"DoubleQuote"]
    script           = "./scripts/sample_script.ps1"
  }

}
