# byoc
Buld Your Own Container

## Requirements

Non root account on a Linux system or [WLS2](https://docs.microsoft.com/en-us/windows/wsl/wsl2-install) (Windows)


The [udocker](https://github.com/indigo-dc/udocker) tool must be installed .

## Install
In order to use this repository, run:
```sh
git clone https://github.com/CCSGroupInternational/byoc
cd byoc
```

## Build Base Image Creation

In order to create reproducible images a build base image is created with all the required base build development libraries and tools. This also avoids the need to install development libraries into the build host system.

The build image is based on [Ubuntu's 18.04 base image](http://cdimage.ubuntu.com/ubuntu-base/releases/18.04/release/).

In order to create & import this image into udocker run:
```sh
scripts/mk-build-base-img.sh
```
