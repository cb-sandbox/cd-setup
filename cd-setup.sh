#!/usr/bin/env bash

# TODO
# [] Debug EC-Kubernetes ssl issue

TOMCAT_MYSQL_PW=flow

if [ "$CD_ENABLED" ]; then
  echo "CloudBees CD server setup"

  echo "Logging into cd.${BASE_DOMAIN}"
  ectool --server "cd.${BASE_DOMAIN}" login admin "$CD_ADMIN_PASS"

  echo "Opening up privileges for all users"
  ectool evalDsl "aclEntry principalType: 'group', principalName: 'Everyone', objectType: 'server', systemObjectName: 'server', readPrivilege: 'allow',modifyPrivilege: 'allow', changePermissionsPrivilege: 'allow', executePrivilege: 'allow'"

  echo "Set CD server hostname"
  ectool setProperty /server/settings/ipAddress "cd.${BASE_DOMAIN}"
  echo "Set CD repository URL"
  echo "Delete default repository"
  ectool deleteRepository default
  ectool getRepositories
  sleep 5
  echo "Recreate default repository with correct URL"
  ectool createRepository default --description "Created through automation" --repositoryDisabled false --url "https://cd.${BASE_DOMAIN}:8200" --zoneName default
  ectool getRepositories
  
  ectool importLicenseData license.xml
  ectool importLicenseData sda_license.xml
  
  # echo "Installing EC-Helm"
  # ectool installPlugin https://downloads.electric-cloud.com/plugins/EC-Helm/1.1.1.2020101501/EC-Helm.jar
  # ectool promotePlugin EC-Helm-1.1.1.2020101501 --promoted 1
  echo "Creating EC-Helm configuration"
  configurations/EC-Helm/CreateConfiguration.sh Helm

  # No longer needed because of new microservice modeling
  # ectool evalDsl --dslFile "dsl/Helm Deploy/Helm.groovy"
  # ectool evalDsl --dslFile "dsl/Helm Deploy/HelmAppEnvModels.groovy" --parameters "{\"base_domain\":\"${BASE_DOMAIN}\"}"

  echo "Creating EC-Kubernetes configuration"
  configurations/EC-Kubernetes/CreateConfiguration.sh "$CLUSTER_ENDPOINT" "$CLUSTER_NAME"

  if [ "$TF_VAR_agent_enabled" ]; then
    echo "CloudBees CD VM agent setup"

    echo "Adding Tomcat/MySQL QA resource"
    ectool createResource tomcat_mysql_qa --hostName $CD_AGENT_TOMCAT_QA_IP
    echo "Adding Tomcat/MySQL UAT resource"
    ectool createResource tomcat_mysql_uat --hostName $CD_AGENT_TOMCAT_UAT_IP

    echo "Installing EC-Tomcat"
    ectool installPlugin https://downloads.electric-cloud.com/plugins/EC-Tomcat/2.3.6.2020103102/EC-Tomcat.jar
    ectool promotePlugin EC-Tomcat-2.3.6.2020103102 --promoted 1
    echo "Creating tomcat_qa configuration"
    configurations/EC-Tomcat/CreateConfiguration.sh tomcat_qa $TOMCAT_MYSQL_PW "http://${CD_AGENT_TOMCAT_QA_IP}:8080"
    echo "Creating tomcat_uat configuration"
    configurations/EC-Tomcat/CreateConfiguration.sh tomcat_uat $TOMCAT_MYSQL_PW "http://${CD_AGENT_TOMCAT_UAT_IP}:8080"

    echo "Installing EC-MYSQL"
    ectool installPlugin https://downloads.electric-cloud.com/plugins/EC-MYSQL/2.0.13.2020102201/EC-MYSQL.jar
    ectool promotePlugin EC-MYSQL-2.0.13.2020102201 --promoted 1
    echo "Creating mysql_qa configuration"
    configurations/EC-MYSQL/CreateConfiguration.sh mysql_qa $TOMCAT_MYSQL_PW
    echo "Creating mysql_uat configuration"
    configurations/EC-MYSQL/CreateConfiguration.sh mysql_uat $TOMCAT_MYSQL_PW

  fi

  if [ "$NEXUS_ENABLED" ]; then
    echo "Setting up Nexus"
    ectool installPlugin https://downloads.electric-cloud.com/plugins/EC-Nexus/1.1.1.2020123004/EC-Nexus.jar
    ectool promotePlugin EC-Nexus-1.1.1.2020123004 --promoted 1
    echo "Creating nexus configuration"
    configurations/EC-Nexus/CreateConfiguration.sh nexus "$NEXUS_TOKEN" https://nexus."$BASE_DOMAIN"
  fi

  if [ "$ARTIFACTORY_ENABLED" ]; then
    echo "Setting up Artifactory"
    ectool installPlugin https://downloads.electric-cloud.com/plugins/EC-Artifactory/1.5.1.2020123001/EC-Artifactory.jar
    ectool promotePlugin EC-Artifactory-1.5.1.2020123001 --promoted 1
    echo "Creating Artifactory configuration"
    configurations/EC-Artifactory/CreateConfiguration.sh artifactory "$ARTIFACTORY_TOKEN" https://artifactory."$BASE_DOMAIN"
  fi

  if [ "$SONARQUBE_ENABLED" ]; then
    echo "Setting up SonarQube"
    ectool installPlugin https://downloads.cloudbees.com/cloudbees-cd/plugins/EC-SonarQube/1.4.2.2020123001/EC-SonarQube.jar
    ectool promotePlugin EC-SonarQube-1.4.2.2020123001 --promoted 1
    echo "Creating SonarQube configuration"
    configurations/EC-SonarQube/CreateConfiguration.sh sonar "$SONARQUBE_TOKEN" sonar."$BASE_DOMAIN"
  fi

  if [ "$FM_ENABLED" ]; then
    echo "Setting up CB Feature Management"
    ectool installPlugin https://downloads.cloudbees.com/cloudbees-cd/plugins/EC-FeatureFlags/1.0.2.2020092301/EC-FeatureFlags.jar
    ectool promotePlugin EC-FeatureFlags-1.0.2.2020092301 --promoted 1
    echo "Creating CB Feature Management configuration"
    configurations/EC-FeatureFlags/CreateConfiguration.sh cbfm "$FM_TOKEN"
  fi

  if [ "$JIRA_ENABLED" ]; then
    echo "Setting up Jira"
    ectool installPlugin https://downloads.cloudbees.com/cloudbees-cd/plugins/EC-JIRA/1.8.1.2020123021/EC-JIRA.jar
    ectool promotePlugin EC-JIRA-1.8.1.2020123021 --promoted 1
    echo "Creating Jira configuration"
    configurations/EC-JIRA/CreateConfiguration.sh Jira "$JIRA_USER" "$JIRA_TOKEN" "$JIRA_URL"
  fi
fi
