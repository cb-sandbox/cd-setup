#!/usr/bin/env bash

# TODO
# [x] pass Tomcat and MySQL parameters
#	[x] IP addresses for resources
#	[x] passwords
#	[x] tomcat URLs
# [] Debug EC-Kubernetes
# [] Set /server/hostName when CEV-27062 is resolved
# [x] Open ACLs for /server Everyone

#TOMCAT_MYSQL_PW=LM9pB9Jz
TOMCAT_MYSQL_PW=flow

echo "Logging into cd.${BASE_DOMAIN}"
ectool --server "cd.${BASE_DOMAIN}" login admin "$CD_ADMIN_PASS"

echo "Opening up privileges for all users"
ectool evalDsl "aclEntry principalType: 'group', principalName: 'Everyone', objectType: 'server', systemObjectName: 'server', readPrivilege: 'allow',modifyPrivilege: 'allow', changePermissionsPrivilege: 'allow', executePrivilege: 'allow'"

# The following is blocked by https://cloudbees.atlassian.net/browse/CEV-27062, has to be done manually
#echo "Set CD server hostname"
#ectool setProperty /server/hostName "cd.${BASE_DOMAIN}"
echo "Set CD repository hostName"
ectool setProperty /repositories/Default/url "https://cd.${BASE_DOMAIN}:8200"

echo "Creating EC-Kubernetes configuration"
configurations/EC-Kubernetes/CreateConfiguration.sh "$CLUSTER_ENDPOINT" "$CLUSTER_NAME"

if [ "$TF_VAR_agent_enabled" ]; then
  echo "Adding Tomcat/MySQL QA resource"
  ectool createResource tomcat_mysql_qa --hostName $CD_AGENT_TOMCAT_QA_IP
  echo "Adding Tomcat/MySQL UAT resource"
  ectool createResource tomcat_mysql_uat --hostName $CD_AGENT_TOMCAT_UAT_IP

  echo "Installing EC-Tomcat"
  ectool installPlugin http://downloads.electric-cloud.com/plugins/EC-Tomcat/2.3.6.2020103102/EC-Tomcat.jar
  ectool promotePlugin EC-Tomcat-2.3.6.2020103102 --promoted 1
  echo "Creating tomcat_qa configuration"
  configurations/EC-Tomcat/CreateConfiguration.sh tomcat_qa $TOMCAT_MYSQL_PW "http://${CD_AGENT_TOMCAT_QA_IP}:8080"
  echo "Creating tomcat_uat configuration"
  configurations/EC-Tomcat/CreateConfiguration.sh tomcat_uat $TOMCAT_MYSQL_PW "http://${CD_AGENT_TOMCAT_UAT_IP}:8080"

  echo "Installing EC-MYSQL"
  ectool installPlugin http://downloads.electric-cloud.com/plugins/EC-MYSQL/2.0.13.2020102201/EC-MYSQL.jar
  ectool promotePlugin EC-MYSQL-2.0.13.2020102201 --promoted 1
  echo "Creating mysql_qa configuration"
  configurations/EC-MYSQL/CreateConfiguration.sh mysql_qa $TOMCAT_MYSQL_PW
  echo "Creating mysql_uat configuration"
  configurations/EC-MYSQL/CreateConfiguration.sh mysql_uat $TOMCAT_MYSQL_PW
  
  echo "Installing EC-Helm"
  ectool installPlugin http://downloads.electric-cloud.com/plugins/EC-Helm/1.1.1.2020101501/EC-Helm.jar
  ectool promotePlugin EC-Helm-1.1.1.2020101501 --promoted 1
  echo "Creating EC-Helm configuration"
  configurations/EC-Helm/CreateConfiguration.sh Helm
  
  ectool evalDsl --dslFile "dsl/Helm Deploy/Helm.groovy"
  ectool evalDsl --dslFile "dsl/Helm Deploy/HelmAppEnvModels.groovy"  --parameters "{\"base_domain\":\"${BASE_DOMAIN}\"}"
fi

if [ "$NEXUS_ENABLED" ]; then
  echo "Setting up Nexus"
  ectool installPlugin https://downloads.electric-cloud.com/plugins/EC-Nexus/1.1.1.2020123004/EC-Nexus.jar
  ectool promotePlugin EC-Nexus-1.1.1.2020123004 --promoted 1
  echo "Creating nexus configuration"
  configurations/EC-Nexus/CreateConfiguration.sh nexus "$NEXUS_TOKEN" https://nexus."$BASE_DOMAIN"
fi
