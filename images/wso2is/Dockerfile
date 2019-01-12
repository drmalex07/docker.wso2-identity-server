# vim: set syntax=dockerfile:

FROM wso2/wso2is:5.7.0 as wso2

USER root

RUN apt-get update && apt-get install -y vim xmlstarlet unzip

USER wso2carbon
WORKDIR /home/wso2carbon

ARG SERVER_NAME
ARG SERVER_PORT="443"

COPY server.p12 ./

# Setup server keystore

ENV SERVER_NAME="${SERVER_NAME}" SERVER_PORT="${SERVER_PORT}" SERVER_KEYSTORE="${WSO2_SERVER_HOME}/repository/resources/security/wso2carbon.jks"

RUN keytool -delete -alias wso2carbon -keystore ${SERVER_KEYSTORE} -storepass wso2carbon
RUN keytool -importkeystore -srckeystore server.p12 -srcstoretype PKCS12 -destkeystore ${SERVER_KEYSTORE} -srcstorepass wso2carbon -deststorepass wso2carbon -srcalias 1 -destalias wso2carbon -destkeypass wso2carbon

# Configure Tomcat connectors (catalina-server.xml)

ENV TOMCAT_CATALINA_CONFIG_FILE="${WSO2_SERVER_HOME}/repository/conf/tomcat/catalina-server.xml"

RUN xmlstarlet edit --inplace --insert "Server/Service/Connector[@port='9443']" -t attr -n proxyPort -v "${SERVER_PORT}" ${TOMCAT_CATALINA_CONFIG_FILE} && \
    xmlstarlet edit --inplace --insert "Server/Service/Connector[@port='9443']" -t attr -n proxyName -v "${SERVER_NAME}" ${TOMCAT_CATALINA_CONFIG_FILE} && \
    xmlstarlet edit --inplace --delete "Server/Service/Connector[@port='9443']/@clientAuth" ${TOMCAT_CATALINA_CONFIG_FILE} 
    
# Configure Carbon (carbon.xml)

ENV CARBON_CONFIG_FILE="${WSO2_SERVER_HOME}/repository/conf/carbon.xml"

RUN xmlstarlet edit --inplace -N c=http://wso2.org/projects/carbon/carbon.xml --update "c:Server/c:HostName" -v "${SERVER_NAME}" ${CARBON_CONFIG_FILE} && \
    xmlstarlet edit --inplace -N c=http://wso2.org/projects/carbon/carbon.xml --update "c:Server/c:MgtHostName" -v "${SERVER_NAME}" ${CARBON_CONFIG_FILE}

# Configure primary datasource

ENV DATABASE="database"
ENV USER_MGT_CONFIG_FILE="${WSO2_SERVER_HOME}/repository/conf/user-mgt.xml" DATASOURCE_CONFIG_FILE="${WSO2_SERVER_HOME}/repository/conf/datasources/master-datasources.xml" 

ADD  --chown=wso2carbon:wso2 http://jdbc.postgresql.org/download/postgresql-42.2.5.jar ${WSO2_SERVER_HOME}/repository/components/lib/

COPY --chown=wso2carbon:wso2 conf/datasources/master-datasources.xml ${DATASOURCE_CONFIG_FILE}
RUN  xmlstarlet edit --inplace --update "datasources-configuration/datasources/datasource/name[text()='WSO2_CARBON_DB']/parent::datasource/definition/configuration/url" -v "jdbc:postgresql://${DATABASE}/wso2carbon"  ${DATASOURCE_CONFIG_FILE}

COPY --chown=wso2carbon:wso2 conf/user-mgt.xml ${USER_MGT_CONFIG_FILE}
