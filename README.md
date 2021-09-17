Resources to try it:

* BuildKit image: `crazymax/buildkit:buildsources`
* Dockerfile frontend image: `crazymax/dockerfile:master`
* Repo example: [crazy-max/buildkit-buildsources-test](https://github.com/crazy-max/buildkit-buildsources-test)

Create and boot builder:

```console
$ docker buildx create \
  --name buildsources \
  --driver docker-container \
  --driver-opt image=crazymax/buildkit:buildsources \
  --use
$ docker buildx inspect --bootstrap
```

Build image:

```console
$ docker buildx bake --metadata-file metadata.json git://github.com/crazy-max/buildkit-buildsources-test.git
```
> * `metadata-file` writes the build result to the file
> * `git://github.com/crazy-max/buildkit-buildsources-test.git` is the remote bake definition (`docker-bake.hcl`)

`ExporterResponse` in build result contains a new key `containerimage.buildinfo` to be able to use it in the `client.SolveResponse`:

```text
{
  "ExporterResponse": {
    "containerimage.buildinfo": "eyJzb3VyY2VzIjpbeyJ0eXBlIjoiaW1hZ2UiLCJyZWYiOiJkb2NrZXIuaW8vZG9ja2VyL2J1aWxkeC1iaW46MC42LjFAc2hhMjU2OmE2NTJjZWQ0YTQxNDE5NzdjN2RhYWVkMGEwNzRkY2Q5ODQ0YTc4ZDdkMjYxNTQ2NWIxMmY0MzNhZTZkZDI5ZjAiLCJwaW4iOiJzaGEyNTY6YTY1MmNlZDRhNDE0MTk3N2M3ZGFhZWQwYTA3NGRjZDk4NDRhNzhkN2QyNjE1NDY1YjEyZjQzM2FlNmRkMjlmMCJ9LHsidHlwZSI6ImltYWdlIiwicmVmIjoiZG9ja2VyLmlvL2xpYnJhcnkvYWxwaW5lOjMuMTMiLCJwaW4iOiJzaGEyNTY6MWQzMGQxYmEzY2I5MDk2MjA2N2U5YjI5NDkxZmJkNTY5OTc5NzlkNTQzNzZmMjNmMDE0NDhiNWM1Y2Q4YjQ2MiJ9LHsidHlwZSI6ImltYWdlIiwicmVmIjoiZG9ja2VyLmlvL21vYnkvYnVpbGRraXQ6djAuOS4wIiwicGluIjoic2hhMjU2OjhkYzY2OGU3ZjY2ZGIxYzA0NGFhZGJlZDMwNjAyMDc0MzUxNmE5NDg0ODc5M2UwZjgxZjk0YTA4N2VlNzhjYWIifSx7InR5cGUiOiJpbWFnZSIsInJlZiI6ImRvY2tlci5pby90b25pc3RpaWdpL3h4QHNoYTI1NjoyMWE2MWJlNDc0NGY2NTMxY2I1ZjMzYjBlNmY0MGVkZTQxZmEzYTFiOGM4MmQ1OTQ2MTc4ZjgwY2M4NGJmYzA0IiwicGluIjoic2hhMjU2OjIxYTYxYmU0NzQ0ZjY1MzFjYjVmMzNiMGU2ZjQwZWRlNDFmYTNhMWI4YzgyZDU5NDYxNzhmODBjYzg0YmZjMDQifSx7InR5cGUiOiJnaXQiLCJyZWYiOiJodHRwczovL2dpdGh1Yi5jb20vY3JhenktbWF4L2J1aWxka2l0LWJ1aWxkc291cmNlcy10ZXN0LmdpdCNtYXN0ZXIiLCJwaW4iOiIyNTlhNWFhNWFhNWJiMzU2MmQxMmNjNjMxZmUzOTlmNDc4ODY0MmMxIn0seyJ0eXBlIjoiaHR0cCIsInJlZiI6Imh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9tb2J5L21vYnkvbWFzdGVyL1JFQURNRS5tZCIsInBpbiI6InNoYTI1Njo0MTk0NTUyMDJiMGVmOTdlNDgwZDdmODE5OWIyNmE3MjFhNDE3ODE4YmMwZTJkMTA2OTc1Zjc0MzIzZjI1ZTZjIn1dfQ==",
    "containerimage.config.digest": "sha256:f9b46e53f841560ba75645d3a8727e8ce3b051da89ffca3d9937130d8e5af02c",
    "containerimage.digest": "sha256:9d3b157491a5dbb009a22a9c8aaef86b04fb247b1b8b5b0c745e32d256d028a2",
    "image.name": "docker.io/library/docker:local"
  }
}
```

`containerimage.buildinfo` is a single base64 encoded string and will look like this with the above response:

```json
{
  "sources": [
    {
      "type": "docker-image",
      "ref": "docker.io/docker/buildx-bin:0.6.1@sha256:a652ced4a4141977c7daaed0a074dcd9844a78d7d2615465b12f433ae6dd29f0",
      "pin": "sha256:a652ced4a4141977c7daaed0a074dcd9844a78d7d2615465b12f433ae6dd29f0"
    },
    {
      "type": "docker-image",
      "ref": "docker.io/library/alpine:3.13",
      "pin": "sha256:1d30d1ba3cb90962067e9b29491fbd56997979d54376f23f01448b5c5cd8b462"
    },
    {
      "type": "docker-image",
      "ref": "docker.io/moby/buildkit:v0.9.0",
      "pin": "sha256:8dc668e7f66db1c044aadbed306020743516a94848793e0f81f94a087ee78cab"
    },
    {
      "type": "docker-image",
      "ref": "docker.io/tonistiigi/xx@sha256:21a61be4744f6531cb5f33b0e6f40ede41fa3a1b8c82d5946178f80cc84bfc04",
      "pin": "sha256:21a61be4744f6531cb5f33b0e6f40ede41fa3a1b8c82d5946178f80cc84bfc04"
    },
    {
      "type": "git",
      "ref": "https://github.com/crazy-max/buildkit-buildsources-test.git#master",
      "pin": "259a5aa5aa5bb3562d12cc631fe399f4788642c1"
    },
    {
      "type": "http",
      "ref": "https://raw.githubusercontent.com/moby/moby/master/README.md",
      "pin": "sha256:419455202b0ef97e480d7f8199b26a721a417818bc0e2d106975f74323f25e6c"
    }
  ]
}
```

Multi-platform is also handled:

```console
$ docker buildx bake --metadata-file metadata.json oci
```

Each image config will have the same structure but `ExporterResponse` will have a key for each platform:

```text
{
  "ExporterResponse": {
    "containerimage.buildinfo/linux/amd64": "eyJzb3VyY2VzIjpbeyJ0eXBlIjoiaW1hZ2UiLCJyZWYiOiJkb2NrZXIuaW8vZG9ja2VyL2J1aWxkeC1iaW46MC42LjFAc2hhMjU2OmE2NTJjZWQ0YTQxNDE5NzdjN2RhYWVkMGEwNzRkY2Q5ODQ0YTc4ZDdkMjYxNTQ2NWIxMmY0MzNhZTZkZDI5ZjAiLCJwaW4iOiJzaGEyNTY6YTY1MmNlZDRhNDE0MTk3N2M3ZGFhZWQwYTA3NGRjZDk4NDRhNzhkN2QyNjE1NDY1YjEyZjQzM2FlNmRkMjlmMCJ9LHsidHlwZSI6ImltYWdlIiwicmVmIjoiZG9ja2VyLmlvL2xpYnJhcnkvYWxwaW5lOjMuMTMiLCJwaW4iOiJzaGEyNTY6MWQzMGQxYmEzY2I5MDk2MjA2N2U5YjI5NDkxZmJkNTY5OTc5NzlkNTQzNzZmMjNmMDE0NDhiNWM1Y2Q4YjQ2MiJ9LHsidHlwZSI6ImltYWdlIiwicmVmIjoiZG9ja2VyLmlvL21vYnkvYnVpbGRraXQ6djAuOS4wIiwicGluIjoic2hhMjU2OjhkYzY2OGU3ZjY2ZGIxYzA0NGFhZGJlZDMwNjAyMDc0MzUxNmE5NDg0ODc5M2UwZjgxZjk0YTA4N2VlNzhjYWIifSx7InR5cGUiOiJpbWFnZSIsInJlZiI6ImRvY2tlci5pby90b25pc3RpaWdpL3h4QHNoYTI1NjoyMWE2MWJlNDc0NGY2NTMxY2I1ZjMzYjBlNmY0MGVkZTQxZmEzYTFiOGM4MmQ1OTQ2MTc4ZjgwY2M4NGJmYzA0IiwicGluIjoic2hhMjU2OjIxYTYxYmU0NzQ0ZjY1MzFjYjVmMzNiMGU2ZjQwZWRlNDFmYTNhMWI4YzgyZDU5NDYxNzhmODBjYzg0YmZjMDQifSx7InR5cGUiOiJnaXQiLCJyZWYiOiJodHRwczovL2dpdGh1Yi5jb20vY3JhenktbWF4L2J1aWxka2l0LWJ1aWxkc291cmNlcy10ZXN0LmdpdCNtYXN0ZXIiLCJwaW4iOiIyNTlhNWFhNWFhNWJiMzU2MmQxMmNjNjMxZmUzOTlmNDc4ODY0MmMxIn0seyJ0eXBlIjoiaHR0cCIsInJlZiI6Imh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9tb2J5L21vYnkvbWFzdGVyL1JFQURNRS5tZCIsInBpbiI6InNoYTI1Njo0MTk0NTUyMDJiMGVmOTdlNDgwZDdmODE5OWIyNmE3MjFhNDE3ODE4YmMwZTJkMTA2OTc1Zjc0MzIzZjI1ZTZjIn1dfQ==",
    "containerimage.buildinfo/linux/arm64": "eyJzb3VyY2VzIjpbeyJ0eXBlIjoiaW1hZ2UiLCJyZWYiOiJkb2NrZXIuaW8vZG9ja2VyL2J1aWxkeC1iaW46MC42LjFAc2hhMjU2OmE2NTJjZWQ0YTQxNDE5NzdjN2RhYWVkMGEwNzRkY2Q5ODQ0YTc4ZDdkMjYxNTQ2NWIxMmY0MzNhZTZkZDI5ZjAiLCJwaW4iOiJzaGEyNTY6YTY1MmNlZDRhNDE0MTk3N2M3ZGFhZWQwYTA3NGRjZDk4NDRhNzhkN2QyNjE1NDY1YjEyZjQzM2FlNmRkMjlmMCJ9LHsidHlwZSI6ImltYWdlIiwicmVmIjoiZG9ja2VyLmlvL2xpYnJhcnkvYWxwaW5lOjMuMTMiLCJwaW4iOiJzaGEyNTY6MWQzMGQxYmEzY2I5MDk2MjA2N2U5YjI5NDkxZmJkNTY5OTc5NzlkNTQzNzZmMjNmMDE0NDhiNWM1Y2Q4YjQ2MiJ9LHsidHlwZSI6ImltYWdlIiwicmVmIjoiZG9ja2VyLmlvL21vYnkvYnVpbGRraXQ6djAuOS4wIiwicGluIjoic2hhMjU2OjhkYzY2OGU3ZjY2ZGIxYzA0NGFhZGJlZDMwNjAyMDc0MzUxNmE5NDg0ODc5M2UwZjgxZjk0YTA4N2VlNzhjYWIifSx7InR5cGUiOiJpbWFnZSIsInJlZiI6ImRvY2tlci5pby90b25pc3RpaWdpL3h4QHNoYTI1NjoyMWE2MWJlNDc0NGY2NTMxY2I1ZjMzYjBlNmY0MGVkZTQxZmEzYTFiOGM4MmQ1OTQ2MTc4ZjgwY2M4NGJmYzA0IiwicGluIjoic2hhMjU2OjIxYTYxYmU0NzQ0ZjY1MzFjYjVmMzNiMGU2ZjQwZWRlNDFmYTNhMWI4YzgyZDU5NDYxNzhmODBjYzg0YmZjMDQifSx7InR5cGUiOiJnaXQiLCJyZWYiOiJodHRwczovL2dpdGh1Yi5jb20vY3JhenktbWF4L2J1aWxka2l0LWJ1aWxkc291cmNlcy10ZXN0LmdpdCNtYXN0ZXIiLCJwaW4iOiIyNTlhNWFhNWFhNWJiMzU2MmQxMmNjNjMxZmUzOTlmNDc4ODY0MmMxIn0seyJ0eXBlIjoiaHR0cCIsInJlZiI6Imh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9tb2J5L21vYnkvbWFzdGVyL1JFQURNRS5tZCIsInBpbiI6InNoYTI1Njo0MTk0NTUyMDJiMGVmOTdlNDgwZDdmODE5OWIyNmE3MjFhNDE3ODE4YmMwZTJkMTA2OTc1Zjc0MzIzZjI1ZTZjIn1dfQ==",
    "containerimage.digest": "sha256:0984b39f779f14077f6f7c324fe0f3cd5cc9af7483105281031a5e2308556c39",
    "image.name": "docker.io/library/docker:local"
  }
}
```
