# Dockfile for building an image based on the Heroku16 base with
# a specific Python runtime included.
FROM heroku/heroku:16-build

LABEL maintainer "YunoJuno <code@yunojuno.com>"

ARG PYTHON_VERSION

WORKDIR /tmp

RUN apt-get update && \
    apt-get upgrade -y && \
    # install packages required to build python and python
    # extensions that may be loaded in subsequent images.
    apt-get install -y \
        build-essential \
        gettext \
        graphviz \
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
        python3-dev \
        tk8.5-dev \
        zlib1g-dev && \
    # install a new non-root user
    useradd -m python_user && \
    # and some basic cleanup
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

# now we reset the user and install pyenv
USER python_user
WORKDIR /home/python_user
ENV HOME  /home/python_user
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/bin:$PATH
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN git clone git://github.com/yyuu/pyenv.git .pyenv && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc

# use pyenv to install the desired python version
RUN pyenv install $PYTHON_VERSION && \
    pyenv local $PYTHON_VERSION && \
    pyenv global $PYTHON_VERSION

ENTRYPOINT ["/bin/bash"]
