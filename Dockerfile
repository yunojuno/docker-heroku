# Dockfile for building an image based on the Heroku16 base with
# a specific Python runtime included.
FROM heroku/heroku:16-build

LABEL maintainer "YunoJuno <code@yunojuno.com>"

# default - can be overridden to build custom images
ARG PYTHON_VERSION=2.7.13

WORKDIR /tmp

RUN apt-get update && \

    # remove the current system python
    apt-get -y purge python2.7-minimal && \

    # re-install packages required to build python and python
    # extensions that may be loaded in subsequent images.
    apt-get install -y \
        build-essential \
        libbz2-dev \
        libexpat1-dev \
        libgdbm-dev \
        liblzma-dev \
        libmemcached-dev \
        libncurses5-dev \
        libnss3-dev \
        libpq-dev \
        libreadline6 \
        libreadline6-dev \
        libsqlite3-dev \
        libssl-dev \
        mercurial \
        python-dev \
        tk8.5-dev \
        zlib1g-dev && \

    # re-install the correct version of python from source
    wget http://python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar -xvf Python-${PYTHON_VERSION}.tgz && \
    cd Python-${PYTHON_VERSION} && \
    ./configure && \
    make && \
    make install && \
    python -m ensurepip --upgrade && \

    # and some basic cleanup
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

ENTRYPOINT ["/bin/bash"]
