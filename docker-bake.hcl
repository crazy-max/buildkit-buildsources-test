group "default" {
  targets = ["local"]
}

target "image" {
  tags = ["docker:local"]
}

target "local" {
  inherits = ["image"]
  output = ["type=docker"]
}

target "nobuildinfo" {
  inherits = ["image"]
  output = ["type=docker,buildinfo=false"]
}

target "all" {
  inherits = ["image"]
  platforms = ["linux/amd64", "linux/arm64"]
  output = ["type=oci,dest=/tmp/docker.tar"]
}
