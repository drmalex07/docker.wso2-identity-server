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

ENV SERVER_NAME="${SERVER_NAME}" SERVER_PORT="${SERVER_PORT}" 
ENV SERVER_KEYSTORE="${WSO2_SERVER_HOME}/repository/resources/security/wso2carbon.jks" CLIENT_KEYSTORE="${WSO2_SERVER_HOME}/repository/resources/security/client-truststore.jks"

RUN keytool -delete -alias wso2carbon -keystore ${SERVER_KEYSTORE} -storepass wso2carbon
RUN keytool -importkeystore -srckeystore server.p12 -srcstoretype PKCS12 -destkeystore ${SERVER_KEYSTORE} -srcstorepass wso2carbon -deststorepass wso2carbon -srcalias 1 -destalias wso2carbon -destkeypass wso2carbon
RUN keytool -importkeystore -srckeystore server.p12 -srcstoretype PKCS12 -destkeystore ${CLIENT_KEYSTORE} -srcstorepass wso2carbon -deststorepass wso2carbon -srcalias 1 -destalias localdomain -destkeypass wso2carbon

# Configure Tomcat connectors (catalina-server.xml)

ENV TOMCAT_CATALINA_CONFIG_FILE="${WSO2_SERVER_HOME}/repository/conf/tomcat/catalina-server.xml"

RUN xmlstarlet edit --inplace --insert "Server/Service/Connector[@port='9443']" -t attr -n proxyPort -v "${SERVER_PORT}" ${TOMCAT_CATALINA_CONFIG_FILE} && \
    xmlstarlet edit --inplace --insert "Server/Service/Connector[@port='9443']" -t attr -n proxyName -v "${SERVER_NAME}" ${TOMCAT_CATALINA_CONFIG_FILE} && \
    xmlstarlet edit --inplace --delete "Server/Service/Connector[@port='9443']/@clientAuth" ${TOMCAT_CATALINA_CONFIG_FILE} 
    
# Configure Carbon (carbon.xml)

ENV CARBON_CONFIG_FILE="${WSO2_SERVER_HOME}/repository/conf/carbon.xml"

RUN xmlstarlet edit --inplace -N c=http://wso2.org/projects/carbon/carbon.xml --update "c:Server/c:HostName" -v "${SERVER_NAME}" ${CARBON_CONFIG_FILE} && \
    xmlstarlet edit --inplace -N c=http://wso2.org/projects/carbon/carbon.xml --update "c:Server/c:MgtHostName" -v "${SERVER_NAME}" ${CARBON_CONFIG_FILE}

# Configure resident IdP 

ENV IDENTITY_CONFIG_FILE="${WSO2_SERVER_HOME}/repository/conf/identity/identity.xml"

RUN xmlstarlet edit --inplace -N c=http://wso2.org/projects/carbon/carbon.xml --update c:Server/c:SSOService/c:EntityId -v '${carbon.protocol}://${carbon.host}' ${IDENTITY_CONFIG_FILE}

# Configure dashboard application

RUN echo "{\"proxy\":{\"proxyHost\":\"${SERVER_NAME}\",\"proxyHTTPSPort\":\"${SERVER_PORT}\",\"proxyContextPath\":\"\",\"servicePath\":\"/services\"}}" > ${WSO2_SERVER_HOME}/repository/deployment/server/jaggeryapps/dashboard/conf/site.json
RUN echo "{\"proxy\":{\"proxyHost\":\"${SERVER_NAME}\",\"proxyHTTPSPort\":\"${SERVER_PORT}\",\"proxyContextPath\":\"\"},\"fido\":{\"appId\":\"\"}}" > ${WSO2_SERVER_HOME}/repository/deployment/server/jaggeryapps/portal/conf/site.json
