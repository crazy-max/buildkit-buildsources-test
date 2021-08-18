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

target "nobi" {
  inherits = ["image"]
  output = ["type=docker,buildinfo=false"]
}

target "oci" {
  inherits = ["image"]
  platforms = ["linux/amd64", "linux/arm64"]
  output = ["type=oci,dest=/tmp/docker.tar"]
}
