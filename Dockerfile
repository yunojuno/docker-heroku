# Dockerfile used to build Heroku-18 stack container.
FROM heroku/heroku:18

LABEL maintainer "YunoJuno <code@yunojuno.com>"

# see: https://github.com/pypa/pip/issues/5367#issuecomment-386864941
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# See https://unix.stackexchange.com/q/146283
ENV DEBIAN_FRONTEND noninteractive

# Add deadsnakes PPA to get latest version of python
RUN apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa

# install minimal deps required to build pylibmc and update Python3
RUN apt-get update && apt-get install -y \
    gettext \
    libmemcached-dev \
    python3-distutils \
    python3-pip \
    python3.8 \
    python3.8-dev \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && rm /usr/bin/python3 && ln -s /usr/bin/python3.8 /usr/bin/python3 \
    && python3 --version

# install pipenv
RUN set -ex && pip3 install pipenv
