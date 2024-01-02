An RStudio Server using Docker for Population Genetics
---

This project outlines using a Docker image to run RStudio server with common population genetics tools and packages included.  It is build from the [RStudio server image](https://hub.docker.com/r/rocker/rstudio/tags?page=1&ordering=last_updated) from the [Rocker Project](https://www.rocker-project.org/).

Currently the image contains the following tools:

- RStudio 4.3.2
- BLAST+
- ClustalW2
- ClustalO
- KaKs_Calculator

The image also contains the following R packages (among many standard ones):

- rmarkdown
- tidyverse
- devtools
- workflowr
- BiocManager
- orthologr

It is easy to add packages from RStudio Server in the container, preserved for future use in the same container as long as it's not removed.

This image is based on Dave Tang's work highlighted in his blog post [Running RStudio Server with Docker](https://davetang.org/muse/2021/04/24/running-rstudio-server-with-docker/).

## Prerequisites

- Docker for your platform

## Quickstart

To try this project on Apple silicon+macOS, use the following pre-built image (support for more architectures coming soon).

Run the following from a project folder to which you'd like access from the container.

```
docker run --name rstudio_server -d -p 8888:8787 -v $PWD:/home/rstudio -e PASSWORD=password  -t rheartpython/rstudio-pop-genetics
```

Log in to RStudio (at [http://localhost:8888/](http://localhost:8888/)) with username "rstudio" and password "password" and start having fun.

To build or modify and build your own image, keep reading.

## Build Image

The following instructions are for _building_ on Apple silicon (tested on an M3).

Replace `<username>` with a local name of your choosing or your Dockerhub username if pushing to Dockerhub.

Run the following to build for Apple silicon.

```
docker build --platform=linux/arm64 --rm=true -t <username>/rstudio-pop-genetics:arm64 .
```

Run the following commands to build cross-platform (linux amd64, linux arm64 and darwin amd64), pushing to a container registry, an image that can be run on an amd64 Linux machine, Apple silicon or Intel-based Mac.

```
docker login
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 --rm=true -t <username>/rstudio-pop-genetics --push .
```

## Run Image as a Container

The local folder where the `docker run` command is run will be shared with the container. Replace `<username>` with a local name or your Dockerhub username if you have pushed to Dockerhub.

Run the following command in your local folder of choice (usually where your project files reside) to start the container on Apple silicon (arm64) platforms.

```
docker run --name rstudio_server -d -p 8888:8787 -v $PWD:/home/rstudio -e PASSWORD=password  -t <username>/rstudio-pop-genetics
```

Log in to RStudio (at [http://localhost:8888/](http://localhost:8888/)) with username "rstudio" and password "password" and start having fun.


## Stop Container and Clean Up

To stop the container (this will keep the state of packages and files):

```
docker stop rstudio_server
```

To remove the container from Docker (note, this will **not** save any installed packages, however the host files loaded into RStudio will be preserved in their latest state as long as the volume was mounted/shared):

```
docker rm rstudio_server
```

## Restart the Server

To start a bash session for the running container:
```
docker exec -it rstudio_server /bin/bash
```

In the bash session:
```
service rstudio-server restart
exit
```

## Additional Links

- [Multi-platform images](https://docs.docker.com/build/building/multi-platform/)
- [Faster Multi-Platform Builds: Dockerfile Cross-Compilation Guide](https://www.docker.com/blog/faster-multi-platform-builds-dockerfile-cross-compilation-guide/)
- [The `orthologr` install guide](https://drostlab.github.io/orthologr/articles/Install.html)
