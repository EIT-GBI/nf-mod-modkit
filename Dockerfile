# modkit — ONT's toolkit for working with modified bases in modBAMs (MM/ML tags).
# CPU-only. Precompiled linux/amd64 binary, like the Dorado image.
ARG DEBIAN_VERSION=13-slim

FROM debian:${DEBIAN_VERSION}

ARG DEBIAN_VERSION
ARG MODKIT_VERSION=0.6.4
ARG MODKIT_SHA256=fb332c691431bd336eb0a81cbca17d2a35caf442ac48277ed3e296c2fe061d80
ARG MODKIT_URL="https://github.com/nanoporetech/modkit/releases/download/v${MODKIT_VERSION}/modkit_v${MODKIT_VERSION}_u16_x86_64.tar.gz"

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=C.UTF-8

# procps for `ps`: Nextflow's task wrapper shells out to it to collect metrics,
# and without it every task dies with
#   Command 'ps' required by nextflow to collect task metrics cannot be found
#
# The tarball's top-level directory carries a commit hash, so strip it rather
# than naming it.
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl procps \
    && curl -fsSL "${MODKIT_URL}" -o /tmp/modkit.tar.gz \
    && echo "${MODKIT_SHA256}  /tmp/modkit.tar.gz" | sha256sum -c - \
    && mkdir -p /opt/modkit \
    && tar -xzf /tmp/modkit.tar.gz --strip-components=1 -C /opt/modkit \
    && ln -s /opt/modkit/modkit /usr/local/bin/modkit \
    && rm -f /tmp/modkit.tar.gz \
    && apt-get purge -y curl \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

LABEL org.opencontainers.image.title="modkit" \
    org.opencontainers.image.description="modkit on debian:${DEBIAN_VERSION}" \
    org.opencontainers.image.version="${MODKIT_VERSION}" \
    org.opencontainers.image.source="https://github.com/nanoporetech/modkit" \
    org.opencontainers.image.licenses="ONT-Public-License"

# No ENTRYPOINT: Nextflow invokes the container as `/bin/bash -c ...`, and an
# ENTRYPOINT of ["modkit"] turns that into `modkit /bin/bash`, which fails.
CMD ["modkit", "--help"]
