# Dockerfile for yunojuno/heroku
#
# Read setup.sh for a better rundown.
#
# Images get tagged with the Python major version:
#
#    e.g yunojuno/heroku:3.12-latest

FROM heroku/heroku:24

# For Heroku-24 and newer, the build image sets a non-root default `USER`.
# https://github.com/heroku/heroku-buildpack-python/blob/main/builds/Dockerfile#L8C1-L8C75
USER root

# OCI-compliant metadata
LABEL maintainer="YunoJuno <code@yunojuno.com>" \
    org.opencontainers.image.source="https://github.com/yunojuno/docker-heroku" \
    org.opencontainers.image.licenses="MIT"

# Use bash + pipefail for all RUN instructions
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8


COPY packages.txt /tmp/packages.txt
COPY setup.sh     /tmp/setup.sh

RUN bash /tmp/setup.sh
