# YunoJuno Heroku Stack Images

Holds the Docker recipes for building YunoJuno's Heroku stack images, which we
use during development & testing. Production uses Heroku's buildpack system
because it means we lean on them for security updates to the underlying stack.

## Images

| Dockerfile             | Base             | repo/image:tag               |
|------------------------|------------------|------------------------------|
| `Dockerfile`           | heroku/heroku:20 | `yunojuno/heroku:3.9-latest` |

## CI

GitHub Actions runs our CI and automatically builds and pushes the generated image
on all pushes to master, and on a scheduled basis daily.

PRs also run the build, but just to check that it can succesfully built - the
resulting image does not result in a pushed image.
