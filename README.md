# README

## Pull official WSO2 image 

Pull image:

    docker pull wso2/wso2is:5.7.0

## Prepare and build image for identity server (IdP)

Place `server.p12` inside context build directory for this image (`images/wso2is/`). For simplicity, the password for this PKCS12 file (as, by default, everything in wso2is server) is assumed to be `wso2carbon`. 

Build image for service:

    docker-compose build idp

## Start container

Create a docker network (only 1st time):

    docker network create wso2_default

Create containers:

    docker-compose create

Start services:

    docker-compose start


