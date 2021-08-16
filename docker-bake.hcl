group "default" {
  targets = ["image-local"]
}

target "image" {
  tags = ["docker:local"]
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
}

target "image-all" {
  inherits = ["image"]
  platforms = ["linux/amd64", "linux/arm64"]
  output = ["type=oci,dest=/tmp/docker.tar"]
}
