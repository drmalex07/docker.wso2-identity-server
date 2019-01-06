# README

## Pull official WSO2 image 

Pull image:

    docker pull wso2/wso2is:5.7.0

## Build image

Place `server.p12` and `server-password` inside this directory (context build directory).

Copy `docker-compose.yml.example` to `docker-compose.yml` and adjust to your needs (server name and ports).

Build image for service:

    docker-compose build

## Start container

Create a docker network (only 1st time):

    docker network create wso2_default

Create container:

    docker-compose create

Start service:

    docker-compose start


