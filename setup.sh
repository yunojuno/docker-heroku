#!/usr/bin/env bash
#
# Provision the runtime environment for the yunojuno/heroku image.
# Read comments inline for rationale.

set -euo pipefail
exec 2>&1        # Redirect stderr to stdout for cleaner logs
set -x            # Trace commands

export DEBIAN_FRONTEND=noninteractive
APT_FLAGS="-qq -y --no-install-recommends"

# -------------------------------------------------------------------
# System packages
# -------------------------------------------------------------------
apt-get update -qq
grep -v '^#' /tmp/packages.txt | xargs apt-get install ${APT_FLAGS}

# -------------------------------------------------------------------
# Python 3.13 from deadsnakes PPA
# -------------------------------------------------------------------
add-apt-repository -y ppa:deadsnakes
apt-get update -qq
apt-get install ${APT_FLAGS} python3.13 python3.13-dev python3.13-venv

# Make python/python3 point to the new interpreter
ln -sf /usr/bin/python3.13 /usr/bin/python
ln -sf /usr/bin/python3.13 /usr/bin/python3


# Install Task (taskfile.dev)
curl -sL https://taskfile.dev/install.sh | sh -s -- -d -b /usr/local/bin

# -------------------------------------------------------------------
# pip + Poetry + uv
# -------------------------------------------------------------------
curl -sS https://bootstrap.pypa.io/get-pip.py | python3.13 && pip install --break-system-packages --upgrade pip uv

pip3 install --upgrade --break-system-packages --no-cache-dir --no-compile \
  setuptools pip wheel poetry uv

# Remove duplicate pip3 binaries
rm -f /usr/bin/pip3 /usr/local/bin/pip3 || true

# -------------------------------------------------------------------
# Image cleanup
# -------------------------------------------------------------------
rm -rf /root/* /tmp/* \
       /root/.cache/pip \
       /var/cache/apt/archives/*.deb

set +x
echo
echo "Python-ecosystem summary"
echo "========================"
for bin in python python3 python3.13 pip poetry; do
  echo "${bin}: $(command -v ${bin}) -> $(${bin} --version 2>&1)"
done
