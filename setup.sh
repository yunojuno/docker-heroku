#!/usr/bin/env bash

set -euo pipefail

# Redirect stderr to stdout since tracing/apt-get/dpkg
# spam it with things that are not errors.
exec 2>&1
set -x

export DEBIAN_FRONTEND=noninteractive

# Install packages for local/ci
# =============================
apt-get update
apt-get install -y --no-install-recommends \
    # General build help
    software-properties-common \
    pkg-config \
    build-essential \
    autoconf \
    # Translation tooling
    gettext \
    # SAML support
    xmlsec1 \
    libxmlsec1-dev \
    # Image support
    zlib1g-dev \
    # For runnning the state transitions graphing
    graphviz \
    # For building pikepdf
    libqpdf-dev \
    # For building reportlab
    libfreetype6-dev \
    # Misc tools
    vim \
    curl

# Install latest Python. We use the deadsnakes ppa to get the
# latest patch version of our major python version rather than
# copying the style in the Heroku buildpack because it's vastly
# simpler and means we don't have to mess about with installing
# python or pip from a Heroku hosted S3 bucket.
add-apt-repository ppa:deadsnakes
apt-get update
# NB: Are you updating Python version?
#   1) Update Docker custom-tag in GitHub Action workflow
#   2) Update throughout this script
#   3) Update FROM tags downstream (e.g yunojuno/platform)
apt-get install -y --no-install-recommends \
    python3.12 \
    python3.12-dev \
    python3.12-venv

# Relink default binaries to new Python install
if [ -f /usr/bin/python ]; then
    rm /usr/bin/python
fi
if [ -f /usr/bin/python3 ]; then
    rm /usr/bin/python3
fi
ln -s /usr/bin/python3.12 /usr/bin/python
ln -s /usr/bin/python3.12 /usr/bin/python3

# We can't use -m ensurepip as Debian strips that module
# from the Py3.12 library it supports, so we use the get-pip.py
# supported install process instead.
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py --break-system-packages

# Upgrade Python-related packages to their latest versions. This
# actually doesn't match what the buildpacks in production do, as
# they pins versions of setuptools, pip. But we don't have a good
# way to stay in-line with these release numbers so instead we
# install the latest and that at least helps us catch issues early
# before Heroku upgrade. This is at the expense of the odd failed
# build in prod, but this is extremely rare and we can override the
# buildpack fairly easily to sort any issues.
pip3 install --upgrade setuptools pip wheel --break-system-packages

# do not install poetry using pip - its dependencies cause conflicts with
# ours. Installing this way defaults to installing the binary in the local
# user's ~/.local/ folder - which isn't on the PATH.
curl -sSL https://install.python-poetry.org | POETRY_HOME=/etc/poetry python -
cp /etc/poetry/bin/poetry /usr/bin/poetry

# Remove other pip binaries to reduce confusion over
# which one should actually be used.
if [ -f /usr/bin/pip3 ]; then
    rm -f /usr/bin/pip3
fi
if [ -d /usr/local/bin/pip3 ]; then
    rm -rf /usr/local/bin/pip3
fi

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
echo "python3.12:"
echo "  - $(which python3.12)"
echo "  - $(python3.12 --version)"
echo "pip:"
echo "  $(which pip)"
echo "  $(pip --version)"
echo "poetry:"
echo "  - $(which poetry)"
echo "  - $(poetry --version)"
echo
