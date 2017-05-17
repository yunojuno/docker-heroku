# heroku16-python

Dockerfile for building a container for running Heroku applications with a
specific python version.

## Use Case

This Dockerfile is used as a base build for python applications that run
on the Heroku16 stack. It reinstalls a specified version of Python (as
per the runtime.txt file).

The resulting image will be large (>1GB), because it includes all of the
build tools. The expectation is that the output image will be used as
the base for a specific project image which contains all of the project
requirements.

As an example, this is our project Dockerfile:

```
FROM yunojuno/heroku16:2.7.13

LABEL maintainer "YunoJuno <code@yunojuno.com>"

ADD requirements.txt /tmp

RUN pip install -r /tmp/requirements.txt

VOLUME ["/app"]
WORKDIR "/app"
EXPOSE 5000

ENTRYPOINT ["python", "manage.py"]
CMD ["runserver", "0.0.0.0:5000"]
```
