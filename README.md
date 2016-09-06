
----
## Percona Server Dockerfile


This repository contains **Dockerfile** of [Percona Server](http://www.percona.com/software/percona-server) for [Docker](https://www.docker.com/)'s automated build.


### Base Docker Image

* [dockerfile/ubuntu](http://dockerfile.github.io/#/ubuntu)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Download [automated build](https://hub.docker.com/r/renothing/docker-mysql57/) from public [Docker Hub Registry](https://registry.hub.docker.com/): `docker pull renothing/docker-mysql57`

   (alternatively, you can build an image from Dockerfile: `docker build -t="renothing/docker-mysql57" github.com/renothing/docker-mysql57`)
   default innodb_buffer_pool_size=4g, please specify it before running
   default root password is "admin" if you didn't specify, please change it letter

### Usage

#### Run `mysqld-safe`

    docker run -dit --env POOLSIZE=4g --env PASS=yourrootpassword --name mysql -p 3306:3306 renothing/docker-mysql57

#### Run `mysql`

    docker run -it --rm --link mysql:mysql renothing/docker-mysql57 bash -c 'mysql -uroot -p$password'
