# YunoJuno Heroku Stack Images

Holds the Docker recipes for building YunoJuno's Heroku stack images, which we
use during development & testing. Production uses Heroku's buildpack system
because it means we lean on them for security updates to the underlying stack.

## Images

| Dockerfile             | repo/image:tag       |
|------------------------|----------------------|
| `heroku-18/Dockerfile` | `yunojuno/heroku:18` |
| `heroku-20/Dockerfile` | `yunojuno/heroku:20` |
