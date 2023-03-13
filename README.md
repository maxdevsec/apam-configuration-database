# mxinfo.Configuration.Database

mxinfo configuration management database schema project.

## Build the database Docker image locally

```
./generate-local-image.sh -s <sa password> -a <app user login password> -i <image name> -t <docker image tag>
```

## Running the database locally

The docker-compose file can be used to run the database. The image may need to be updated when testing a new database version.

```
docker-compose up -d
```
