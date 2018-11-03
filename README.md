# Heroku18 Image Builder

Dockerfile for building container for running Django applications on the
Heroku-18 stack.

## Use Case

This Dockerfile is used as a base build for python applications that run
on the Heroku-18 stack.

As an example, this is our project Dockerfile:

```
FROM yunojuno/heroku:latest

# add local project requirements
COPY Pipfile* ./
RUN  pipenv install --dev

VOLUME ["/app"]
WORKDIR /app
EXPOSE 5000

```
