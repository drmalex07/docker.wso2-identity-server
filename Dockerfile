FROM wso2/wso2is:5.7.0 as wso2

USER root

RUN apt-get update && apt-get install -y vim xmlstarlet

USER wso2carbon
WORKDIR /home/wso2carbon

ARG SERVER_NAME
ARG SERVER_PORT="443"

COPY server.p12 server-password ./

# Setup server keystore

ENV SERVER_NAME="${SERVER_NAME}" SERVER_PORT="${SERVER_PORT}" SERVER_KEYSTORE="${WSO2_SERVER_HOME}/repository/resources/security/wso2carbon.jks"

RUN keytool -delete -alias wso2carbon -keystore ${SERVER_KEYSTORE} -storepass wso2carbon
RUN keytool -importkeystore -srckeystore server.p12 -srcstoretype PKCS12 -destkeystore ${SERVER_KEYSTORE} -srcstorepass $(cat server-password) -deststorepass wso2carbon -srcalias 1 -destalias wso2carbon -destkeypass wso2carbon

# Configure Tomcat connectors (catalina-server.xml)

RUN xmlstarlet edit --inplace --insert "Server/Service/Connector[@port='9443']" -t attr -n proxyPort -v "${SERVER_PORT}" ${WSO2_SERVER_HOME}/repository/conf/tomcat/catalina-server.xml && \
    xmlstarlet edit --inplace --insert "Server/Service/Connector[@port='9443']" -t attr -n proxyName -v "${SERVER_NAME}" ${WSO2_SERVER_HOME}/repository/conf/tomcat/catalina-server.xml
    
# Configure Carbon (carbon.xml)

ENV CARBON_CONFIG_FILE="${WSO2_SERVER_HOME}/repository/conf/carbon.xml"

RUN xmlstarlet edit --inplace -N c=http://wso2.org/projects/carbon/carbon.xml --update "c:Server/c:HostName" -v "${SERVER_NAME}" ${CARBON_CONFIG_FILE} && \
    xmlstarlet edit --inplace -N c=http://wso2.org/projects/carbon/carbon.xml --update "c:Server/c:MgtHostName" -v "${SERVER_NAME}" ${CARBON_CONFIG_FILE}
