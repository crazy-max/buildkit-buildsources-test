group "default" {
  targets = ["image"]
}

target "image" {
  output = ["type=docker"]
}

target "image-all" {
  platforms = [
    "linux/amd64",
    "linux/arm/v7",
    "linux/arm64"
  ]
}