# README

## Pull official WSO2 image 

Pull image:

    docker pull wso2/wso2is:5.7.0

## Prepare data for database server

Place `postgres-password` inside `secrets` directory. For `postgres` user inside container to be able to read it:

    sudo chown $(id -u):999 secrets/postgres-password

Build image for service:

    docker-compose build database

## Prepare and build image for identity server (IdP)

Place `server.p12` inside context build directory for this image (`images/wso2is/`). For simplicity, the password for this PKCS12 file (as, by default, everything in wso2is server) is assumed to be `wso2carbon`. 

Build image for service:

    docker-compose build idp

## Start service

Create a docker network (only 1st time):

    docker network create wso2_default

Create containers:

    docker-compose create

Start services:

    docker-compose start

## Post-install

There are several post-install steps to be taken (using Carbon Web UI). The basic ones:

1. Configure which claims of the local claim dialect (`http://wso2.org/claims`) are enabled in a user's profile.
    
2. Add roles. A role must have the `login` permission for allowing a user of this role to login.
    
3. Add users and assign roles to them. For each user, the profile must be edited to provide values for basic attributes (mapping to basic claims). 
    
4. Configure resident (i.e. local) identity provider (the one providing the SAML, OAuth2 authentication endpoints). Make sure that the `entityID` of the SAML endpoint is a valid `https://` URL (may need an update for default values to persist in identity database!).
    
5. Configure service providers (SPs). The basic configuration points are requested claims (defined in local dialect) and supported dialects. If multiple dialects are supported (the local one is always supported) then a user attribute will be sent in all dialects.

