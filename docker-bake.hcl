group "default" {
  targets = ["image"]
}

target "image" {
  output = ["type=docker"]
}

target "image-all" {
  platforms = ["linux/amd64", "linux/arm64"]
  output = ["type=oci,dest=/tmp/docker.tar"]
}
