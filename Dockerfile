# Dockerfile for yunojuno/heroku
#
# Read setup.sh for a better rundown.
#
# Images get tagged with the Python major version:
#
#    e.g yunojuno/heroku:3.12-latest

FROM heroku/heroku:24

LABEL maintainer="YunoJuno <code@yunojuno.com>"

ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

COPY setup.sh /tmp/setup.sh

USER root
RUN /tmp/setup.sh

USER heroku
