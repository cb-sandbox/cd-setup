#!/usr/bin/env bash

# TODO
# [] pass Tomcat and MySQL parameters
#	[] IP addresses for resources
#	[] passwords
#	[] tomcat URLs
# [] Debug EC-Kubernetes

#TOMCAT_MYSQL_PW=LM9pB9Jz
TOMCAT_MYSQL_PW=flow

echo "Logging into cd.${BASE_DOMAIN}"
ectool --server "cd.${BASE_DOMAIN}" login admin "$CD_ADMIN_PASS"

echo "Set CD server hostname"
ectool setProperty /server/hostName "cd.${BASE_DOMAIN}"
echo "Set CD repository hostName"
ectool setProperty /repositories/Default/url "https://cd.${BASE_DOMAIN}:8200"

echo "Adding Tomcat/MySQL QA resource"
ectool createResource tomcat_mysql_qa --hostName $CD_AGENT_TOMCAT_QA_IP
echo "Adding Tomcat/MySQL UAT resource"
ectool createResource tomcat_mysql_uat --hostName $CD_AGENT_TOMCAT_UAT_IP

echo "Creating EC-Kubernetes configuration"
configurations/EC-Kubernetes/CreateConfiguration.sh "$CLUSTER_ENDPOINT" "$CLUSTER_NAME"
echo "Creating tomcat_qa configuration"
configurations/EC-Tomcat/CreateConfiguration.sh tomcat_qa $TOMCAT_MYSQL_PW "http://${CD_AGENT_TOMCAT_QA_IP}"
echo "Creating tomcat_uat configuration"
configurations/EC-Tomcat/CreateConfiguration.sh tomcat_uat $TOMCAT_MYSQL_PW "http://${CD_AGENT_TOMCAT_UAT_IP}"
echo "Creating mysql_qa configuration"
configurations/EC-MYSQL/CreateConfiguration.sh mysql_qa $TOMCAT_MYSQL_PW
echo "Creating mysql_qa configuration"
configurations/EC-MYSQL/CreateConfiguration.sh mysql_uat $TOMCAT_MYSQL_PW
