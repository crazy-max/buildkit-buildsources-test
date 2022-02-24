# syntax=docker/dockerfile-upstream:master-labs

ARG DOCKER_VERSION="20.10.7"
ARG BUILDKIT_VERSION="0.9.0"
ARG COMPOSE_CLI_VERSION="2.0.0-beta.6"

# xx is a helper for cross-compilation
FROM --platform=$BUILDPLATFORM tonistiigi/xx@sha256:21a61be4744f6531cb5f33b0e6f40ede41fa3a1b8c82d5946178f80cc84bfc04 AS xx

FROM moby/buildkit:v${BUILDKIT_VERSION} AS buildkit
FROM docker.io/docker/buildx-bin:0.6.1@sha256:a652ced4a4141977c7daaed0a074dcd9844a78d7d2615465b12f433ae6dd29f0 AS buildx

FROM alpine:3.13 AS base
COPY --from=xx / /
RUN apk --update --no-cache add \
    ca-certificates \
    openssh-client \
  && rm -rf /tmp/* /var/cache/apk/*

FROM base AS docker-static
ARG TARGETPLATFORM
ARG DOCKER_VERSION
WORKDIR /opt/docker
RUN DOCKER_ARCH=$(case ${TARGETPLATFORM:-linux/amd64} in \
    "linux/amd64")   echo "x86_64"  ;; \
    "linux/arm/v7")  echo "armhf"   ;; \
    "linux/arm64")   echo "aarch64" ;; \
    *)               echo ""        ;; esac) \
  && echo "DOCKER_ARCH=$DOCKER_ARCH" \
  && wget -qO- "https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-${DOCKER_VERSION}.tgz" | tar xvz --strip 1

FROM base AS compose-cli
ARG TARGETPLATFORM
ARG COMPOSE_CLI_VERSION
WORKDIR /opt
RUN COMPOSE_CLI_ARCH=$(case ${TARGETPLATFORM:-linux/amd64} in \
    "linux/amd64")   echo "linux-amd64"  ;; \
    "linux/arm/v7")  echo "linux-armv7"  ;; \
    "linux/arm64")   echo "linux-arm64"  ;; \
    *)               echo ""        ;; esac) \
  && echo "COMPOSE_CLI_ARCH=$COMPOSE_CLI_ARCH" \
  && wget -q "https://github.com/docker/compose-cli/releases/download/v${COMPOSE_CLI_VERSION}/docker-compose-${COMPOSE_CLI_ARCH}" -qO "/opt/docker-compose" \
  && chmod +x /opt/docker-compose

FROM alpine:3.13

RUN apk --update --no-cache add \
    bash \
    ca-certificates \
    openssh-client \
  && rm -rf /tmp/* /var/cache/apk/*

COPY --from=docker-static /opt/docker/ /usr/local/bin/
COPY --from=buildkit /usr/bin/buildctl /usr/local/bin/buildctl
COPY --from=buildkit /usr/bin/buildkit* /usr/local/bin/
COPY --from=buildx /buildx /usr/libexec/docker/cli-plugins/docker-buildx
COPY --from=compose-cli /opt/docker-compose /usr/libexec/docker/cli-plugins/docker-compose
ADD https://raw.githubusercontent.com/moby/moby/master/README.md /

# https://github.com/docker-library/docker/pull/166
#   dockerd-entrypoint.sh uses DOCKER_TLS_CERTDIR for auto-generating TLS certificates
#   docker-entrypoint.sh uses DOCKER_TLS_CERTDIR for auto-setting DOCKER_TLS_VERIFY and DOCKER_CERT_PATH
# (For this to work, at least the "client" subdirectory of this path needs to be shared between the client and server containers via a volume, "docker cp", or other means of data sharing.)
ENV DOCKER_TLS_CERTDIR=/certs
ENV DOCKER_CLI_EXPERIMENTAL=enabled

RUN docker --version \
  && buildkitd --version \
  && buildctl --version \
  && docker buildx version \
  && docker compose version \
  && mkdir /certs /certs/client \
  && chmod 1777 /certs /certs/client

COPY rootfs/modprobe.sh /usr/local/bin/modprobe
COPY rootfs/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]
