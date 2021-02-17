# Create EC-Nexus configuration
# TODO:
# - use IP instead of localhost

SONARQUBE_CONFIG=$1
SONARQUBE_PW=$2
SONARQUBE_URL=$3
SONARQUBE_USER="admin"

printf "${SONARQUBE_PW}\n" | ectool runProcedure /plugins/EC-SonarQube/project \
  --procedureName CreateConfiguration \
  --actualParameter \
      host="${SONARQUBE_URL}" \
      port=443 \
      protocol="https" \
      config="${SONARQUBE_CONFIG}" \
      credential="${SONARQUBE_CONFIG}" \
      proxy_credential="${SONARQUBE_CONFIG}" \
      attemptConnection=false \
  --credential "${SONARQUBE_CONFIG}"="${SONARQUBE_USER}"
