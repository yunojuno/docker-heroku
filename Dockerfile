# Dockerfile used to build Heroku-18 stack container.
FROM heroku/heroku:18

LABEL maintainer "YunoJuno <code@yunojuno.com>"

# see: https://github.com/pypa/pip/issues/5367#issuecomment-386864941
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# install minimal deps required to build pylibmc
RUN apt-get update && apt-get install -y \
    libmemcached-dev \
    python3-distutils \
    python3-pip \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && pip3 install -U pip pipenv

ENTRYPOINT ["bash"]
