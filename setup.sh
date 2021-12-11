#!/usr/bin/env bash

set -euo pipefail

# Redirect stderr to stdout since tracing/apt-get/dpkg
# spam it with things that are not errors.
exec 2>&1
set -x

export DEBIAN_FRONTEND=noninteractive

# Install packages for local/ci
# =============================
# Add apt repo: software-properties-common
# Build tooling: autoconf
# Build tooling: build-essential
# Translations: gettext
# Compile Memcached (pylibmc): libmemcached-dev
# FB's fast file watcher: watchman
# Compression lib: zlib1g-dev
apt-get update
apt-get install -y --no-install-recommends \
    software-properties-common \
    autoconf \
    build-essential \
    gettext \
    libmemcached-dev \
    watchman \
    zlib1g-dev

# Install latest Python. We use the deadsnakes ppa to get the
# latest patch version of our major python version rather than
# copying the style in the Heroku buildpack because it's vastly
# simpler and means we don't have to mess about with installing
# python or pip from a Heroku hosted S3 bucket.
add-apt-repository ppa:deadsnakes/ppa
apt-get update
# NB: Updating Python?
#   1) Update Docker custom-tag in GitHub Action workflow
#   2) Update throughout this script
#   3) Update FROM tags downstream (e.g yunojuno/platform)
apt-get install -y --no-install-recommends \
    python3.10 \
    python3.10-dev \
    python3.10-distutils \
    python3.10-venv  # includes ensurepip

# Relink default binaries to new Python install
rm /usr/bin/python
rm /usr/bin/python3
ln -s /usr/bin/python3.10 /usr/bin/python
ln -s /usr/bin/python3.10 /usr/bin/python3

# Upgrade Python-related packages to their latest versions. This
# actually doesn't match what the buildpacks in production do, as
# they pins versions of setuptools, pip. But we don't have a good
# way to stay in-line with these release numbers so instead we
# install the latest and that at least helps us catch issues early
# before Heroku upgrade. This is at the expense of the odd failed
# build in prod, but this is extremely rare and we can override the
# buildpack fairly easily to sort any issues.
python -m ensurepip --upgrade
pip3 install --upgrade setuptools pip poetry

# Remove other pip binaries to reduce confusion over
# which one should actually be used.
rm -rf /usr/bin/pip3
rm -rf /usr/local/bin/pip3

# Cleanup to reduce image size
rm -rf /root/*
rm -rf /tmp/*
rm -rf /var/cache/apt/archives/*.deb
rm -rf /var/lib/apt/lists/*

set +x

# Sanity check of Python ecosystem paths & versions,
# the image will get tagged with the Python version.
echo
echo "Python-ecosystem"
echo "================"
echo
echo "python:"
echo "  - $(which python)"
echo "  - $(python --version)"
echo "python3:"
echo "  - $(which python3)"
echo "  - $(python3 --version)"
echo "python3.10:"
echo "  - $(which python3.10)"
echo "  - $(python3.10 --version)"
echo "pip:"
echo "  $(which pip)"
echo "  $(pip --version)"
echo "poetry:"
echo "  - $(which poetry)"
echo "  - $(poetry --version)"
echo
