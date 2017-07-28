# MariaDB
A MariaDB server in an Alpine-based Docker image

[![Docker Pulls](https://img.shields.io/docker/pulls/reflectivecode/docker-mariadb.svg)](https://hub.docker.com/r/reflectivecode/docker-mariadb/)

## Quickstart

This sample starts a MariaDb server listening on port 3306 with a root password defined by the ${ROOT_PASSWORD} variable. Data is persisted on the host in the directory defined by the ${HOST_PATH_TO_DATA_DIRECTORY} variable.

```
docker pull reflectivecode/docker-mariadb

docker run -d \
    --name mariadb \
    -p 3306:3306 \
    -v ${HOST_PATH_TO_DATA_DIRECTORY}:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=${ROOT_PASSWORD} \
    reflectivecode/docker-mariadb
```
