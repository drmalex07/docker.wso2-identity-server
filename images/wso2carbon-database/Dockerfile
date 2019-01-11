# vim: set syntax=dockerfile:

FROM wso2/wso2is:5.7.0 as wso2is

FROM postgres:9.6 as postgres

ENV WSO2IS_WSO2_SERVER_HOME=/home/wso2carbon/wso2is-5.7.0


COPY --from=wso2is ${WSO2IS_WSO2_SERVER_HOME}/dbscripts/postgresql.sql /root/scripts/2-1-schema-users.sql 
COPY --from=wso2is ${WSO2IS_WSO2_SERVER_HOME}/dbscripts/identity/postgresql.sql /root/scripts/2-2-schema-identity.sql 
COPY --from=wso2is ${WSO2IS_WSO2_SERVER_HOME}/dbscripts/identity/stored-procedures/postgre/postgresql.sql /root/scripts/2-2-1-schema-identity-procedures.sql 
COPY --from=wso2is ${WSO2IS_WSO2_SERVER_HOME}/dbscripts/identity/uma/postgresql.sql /root/scripts/2-2-2-schema-identity-uma.sql 
COPY --from=wso2is ${WSO2IS_WSO2_SERVER_HOME}/dbscripts/consent/postgresql.sql /root/scripts/2-3-schema-consent.sql

COPY create-database.sql /docker-entrypoint-initdb.d/1-create-database.sql 
RUN  printf "\\c wso2carbon wso2carbon\n\n" > /docker-entrypoint-initdb.d/2-define-schema.sql
RUN  ls -1 /root/scripts/* | sort | xargs cat >> /docker-entrypoint-initdb.d/2-define-schema.sql

