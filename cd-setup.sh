#!/usr/bin/env bash

# TODO
# [] pass Tomcat and MySQL parameters
#	[] IP addresses for resources
#	[] passwords
#	[] tomcat URLs
# [] Debug EC-Kubernetes

echo "Logging into cd.${BASE_DOMAIN}"
ectool --server "cd.${BASE_DOMAIN}" login admin "$CD_ADMIN_PASS"

echo "Set CD server hostname"
ectool setProperty /server/hostName "cd.${BASE_DOMAIN}"

echo "Adding Tomcat/MySQL QA resource"
ectool createResource tomcat_mysql_qa --hostName $CD_AGENT_TOMCAT_QA_IP
echo "Adding Tomcat/MySQL UAT resource"
ectool createResource tomcat_mysql_uat --hostName $CD_AGENT_TOMCAT_UAT_IP

echo "Creating EC-Kubernetes configuration"
configurations/EC-Kubernetes/CreateConfiguration.sh "$CLUSTER_ENDPOINT" "$CLUSTER_NAME"
echo "Creating tomcat_qa configuration"
configurations/EC-Tomcat/CreateConfiguration.sh tomcat_qa a8iu7zB1nBdP_tbd "http://${CD_AGENT_TOMCAT_QA_IP}"
echo "Creating tomcat_uat configuration"
configurations/EC-Tomcat/CreateConfiguration.sh tomcat_uat a8iu7zB1nBdP_tbd "http://${CD_AGENT_TOMCAT_UAT_IP}"
echo "Creating mysql_qa configuration"
configurations/EC-MYSQL/CreateConfiguration.sh mysql_qa a8iu7zB1nBdP
echo "Creating mysql_qa configuration"
configurations/EC-MYSQL/CreateConfiguration.sh mysql_uat a8iu7zB1nBdP
