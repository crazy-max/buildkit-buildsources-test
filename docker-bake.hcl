group "default" {
  targets = ["docker"]
}

target "image" {
  context = "https://github.com/crazy-max/buildkit-buildsources-test.git#master"
  tags = ["crazymax/buildkit-buildsources-test:latest"]
}

target "docker" {
  inherits = ["image"]
  output = ["type=docker"]
}

target "bi-all" {
  inherits = ["image"]
  output = ["type=docker,buildinfo=all"]
}

target "bi-imageconfig" {
  inherits = ["image"]
  output = ["type=docker,buildinfo=imageconfig"]
}

target "bi-metadata" {
  inherits = ["image"]
  output = ["type=docker,buildinfo=metadata"]
}

target "bi-none" {
  inherits = ["image"]
  output = ["type=docker,buildinfo=none"]
}

target "oci" {
  inherits = ["image"]
  platforms = ["linux/amd64", "linux/arm64"]
  output = ["type=oci,dest=./out/docker.tar"]
}
