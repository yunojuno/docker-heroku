# Dockerfile for yunojuno/heroku
#
# Read setup.sh for a better rundown.
#
# Images get tagged with the Python major version:
#
#    e.g yunojuno/heroku:3.12-latest

FROM heroku/heroku:24

# OCI-compliant metadata
LABEL maintainer="YunoJuno <code@yunojuno.com>"            \
      org.opencontainers.image.source="https://github.com/yunojuno/docker-heroku" \
      org.opencontainers.image.licenses="MIT"

# Use bash + pipefail for all RUN instructions
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# -------------------------------------------------------------------
# Build stage
# -------------------------------------------------------------------
COPY packages.txt /tmp/packages.txt
COPY setup.sh     /tmp/setup.sh

USER root
RUN bash /tmp/setup.sh

# Switch back to the default non-root user provided by the base image
USER heroku
