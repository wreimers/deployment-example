# deployment-example

## development kickstart

this cleans, builds, and runs the dev container.
it mounts the repo root at /app and starts flask's built-in server.

```
make
```

## useful make targets

`make run` - default target; cleans, builds, and runs a dev container locally

`make clean` - removes local dev image and container

`make shell` - shell into the local dev container

`make run_prod` - cleans, builds, and runs a prod container locally

`make clean` - removes local prod image and container

`make shell_prod` - shell into the local prod container

## one dangerous make target

**WARNING**: *this will delete **ALL** of the docker objects on your host*

```
make nuke
```
