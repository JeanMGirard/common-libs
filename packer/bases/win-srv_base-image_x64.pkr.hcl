# name                = "Windows_Server-2012-R2*English-64Bit-Base*"
# name                = "Windows_Server-2016-English-Full-Base*"
# name                = "Windows_Server-2019-English-Full-Base*"

packer {
  required_plugins {
    azure = {
      version = ">= 1.3.0"
      source = "github.com/hashicorp/azure"
    }
    amazon = {
      version = ">= 1.1.0"
      source = "github.com/hashicorp/amazon"
    }
  }
}


locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  admin_username = "packer"
  admin_password = "packer"
  user_data = base64encode(templatefile("./userdata/windows-base.tpl", {
    admin_username = local.admin_username
    admin_password = local.admin_password
  }))
}


source "amazon-ebs" "windows-server-core" {
  ami_name      = "windows-base--srv-core-ebs-hvm--${local.timestamp}"
  communicator  = "winrm"
  instance_type = "t3a.medium"
  region        = "${var.region}"

  source_ami_filter {
    filters = {
      name                = "Windows_Server-2019-English-Core-Base*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  user_data      = base64encode(local.userdata)
  winrm_username = local.admin_username
  winrm_password = local.admin_password
}
source "azure-arm" "windows-server-core" {
  subscription_id = "221ff291-4cbe-43bf-97e1-55ea5fed42e7"
  tenant_id = "afe3b0e5-8b43-47c4-974d-3dab5cefc96a"
  client_id = "68e3259f-1e77-4568-aa1f-1a0f89974a83"
  client_secret = "SVC8Q~T_2BprEC23D4JZK4b-vvoGif2KSg4HeaZa"

  location = "East US"
  vm_size = "Standard_DS1_v2"

  os_type = "Windows"
  image_offer = "WindowsServer"
  image_publisher = "MicrosoftWindowsServer"
  image_sku = "2019-Datacenter-Core"


  communicator = "winrm"
  winrm_use_ssl = true
  winrm_insecure = true
  winrm_timeout = "7m"
  winrm_username = "packer"

  # resource_group_name = "ci-packer"
  #  azure_tags = { dept = "engineering"  }
  #  storage_account = "virtualmachines"
  #  capture_container_name = "images"
  # capture_name_prefix = "win-base"

  managed_image_resource_group_name = "ci-packer"
  managed_image_name = "WindowsServer2019-Base"
  os_disk_size_gb = 128 # min 128+
  disk_additional_size = []
  user_data = local.user_data
}


# a build block invokes sources and runs provisioning steps on them.
build {
  name    = "windows-server-base"
  sources = [
    # "source.amazon-ebs.windows-server-core",
    "source.azure-arm.windows-server-core"
  ]



  #  provisioner "powershell" {
  #    inline           = [
  #      #" # NOTE: the following *3* lines are only needed if the you have installed the Guest Agent.",
  #      # "  while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
  #      # "  while ((Get-Service WindowsAzureTelemetryService).Status -ne 'Running') { Start-Sleep -s 5 }",
  #      # "  while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
  #      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm",
  #      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
  #    ]
  #  }
  # "# Install IIS",
  provisioner "powershell" {
    inline = [
      "Install-WindowsFeature -name Web-Server -IncludeManagementTools",
      "Install-WindowsFeature Web-Asp-Net45"
    ]
  }
  provisioner "windows-restart" {  }
  provisioner "powershell" {
    environment_vars = ["VAR1=A$Dollar", "VAR2=A`Backtick", "VAR3=A'SingleQuote", "VAR4=A\"DoubleQuote"]
    script           = "./scripts/sample_script.ps1"
  }


  post-processors {
    post-processor "checksum" {
      checksum_types = ["md5", "sha512"]
    }
    post-processor "manifest" {
      output = "manifest.json"
      strip_path = true
      custom_data = {}
    }
  }
  # post-processors {
    #    post-processor "amazon-import" {
    #      access_key = "YOUR KEY HERE"
    #      secret_key = "YOUR SECRET KEY HERE"
    #      region  ="us-east-1"
    #      s3_bucket_name = "importbucket"
    #      license_type = "BYOL"
    #      tags = {}
    #    }
    # post-processor "googlecompute-import" { # upload image to GCP  }
  # }
}
