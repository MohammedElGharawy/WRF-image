# ticket-44596

## Overview

This repository provides a Dockerfile for building WRF (Weather Research and Forecasting) and WPS (WRF Preprocessing System) on an Ubuntu base. The Docker container is created using Podman and can be converted into a Singularity image by saving it as a tar using Podman.

## Prerequisites

Before proceeding, ensure that you have the following installed:

- [Podman](https://podman.io/)
- [Singularity](https://sylabs.io/singularity/)

## Building the Container

To build the Docker container, use the following command:

```shell
podman build -t wps .
```

## Converting to a Singularity Image

After successfully building the container, you can convert it into a Singularity image by saving it as a tar file:

```shell
podman save wps -o image.tar
```

Once you have the tar file, you can build a Singularity image using the following command:

```shell
singularity build --fakeroot IMG.sif docker-archive://image.tar
```

## Usage

To use the generated Singularity image, execute the following command:

```shell
singularity run IMG.sif
```
## Acknowledgments

We would like to acknowledge the developers of WRF and WPS for their invaluable contributions.
