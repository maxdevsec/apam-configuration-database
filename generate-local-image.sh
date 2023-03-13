#!/bin/bash

while getopts s:a:i:t: flag
do
    case "${flag}" in
        s) SA_PASSWORD=${OPTARG};;
        a) APP_USER_PASSWORD=${OPTARG};;
        i) IMAGE_NAME=${OPTARG};;
        t) IMAGE_TAG=${OPTARG};;
    esac
done

echo $IMAGE_TAG

echo "Building Image"

docker build -t mxinfo.config.dbtemp:latest .

echo "Running Image"

docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$SA_PASSWORD" -p 50001:1433 --name mxinfo.config.temp -d mxinfo.config.dbtemp:latest

echo "Initializing Database"

sleep 10

docker exec mxinfo.config.temp sh -c "/opt/scripts/initialize.sh '$SA_PASSWORD' '$APP_USER_PASSWORD'"

echo "Generating Final Image"

docker commit mxinfo.config.temp ${IMAGE_NAME}:${IMAGE_TAG}

echo "Tear down intermediate containers"

docker stop mxinfo.config.temp

docker rm mxinfo.config.temp

docker rmi mxinfo.config.dbtemp:latest


