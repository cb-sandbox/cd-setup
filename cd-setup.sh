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
echo "Creating EC-Kubernetes configuration"
configurations/EC-Kubernetes/CreateConfiguration.sh "$CLUSTER_ENDPOINT" "$CLUSTER_NAME"
echo "Creating tomcat_mysql_qa resource"
ectool createResource tomcat_mysql_qa
echo "Creating tomcat_mysql_uat resource"
ectool createResource tomcat_mysql_uat
echo "Creating tomcat_qa configuration"
configurations/EC-Tomcat/CreateConfiguration.sh tomcat_qa admin_pw_tbd http://tbd
echo "Creating tomcat_uat configuration"
configurations/EC-Tomcat/CreateConfiguration.sh tomcat_uat admin_pw_tbd http://tbd
echo "Creating mysql_qa configuration"
configurations/EC-MYSQL/CreateConfiguration.sh mysql_qa admin_pw_tbd
echo "Creating mysql_qa configuration"
configurations/EC-MYSQL/CreateConfiguration.sh mysql_uat admin_pw_tbd
