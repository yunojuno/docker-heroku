FROM heroku/heroku:20

LABEL maintainer "YunoJuno <code@yunojuno.com>"

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

COPY setup.sh /tmp/setup.sh
COPY runtime.txt /tmp/runtime.txt

RUN /tmp/setup.sh
