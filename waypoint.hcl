project = "titanic"

app "api" {
  path = "./services/api.nodejs"
  labels = {
    "service" = "example-nodejs",
    "env" = "dev"
  }

#  runner {
#    profile = "docker-codelabs-dev"
#  }
  build {
    use "pack" {}
    # use "docker" {}
#    registry {
#      use "docker" {
#        //The following field was skipped during file generation
#        image = ""
#        //The following field was skipped during file generation
#        tag = ""
#      }
#    }
  }
  deploy {
    use "docker" {}
#    use "kubernetes" {
#      pod {
#        container = "k8s.Container"
#        //The following field was skipped during file generation
#        security_context = ""
#        //The following field was skipped during file generation
#        sidecar = ""
#      }
#    }
  }
  release {
    use "kubernetes" {
      ingress {
        //The following field was skipped during file generation
        tls = ""
      }
    }
  }
}
