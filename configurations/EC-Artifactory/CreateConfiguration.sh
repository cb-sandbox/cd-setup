# Create EC-Nexus configuration
# TODO:
# - use IP instead of localhost

ARTIFACTORY_CONFIG=$1
ARTIFACTORY_PW=$2
ARTIFACTORY_URL=$3
ARTIFACTORY_USER="admin"

printf "${ARTIFACTORY_PW}\n" | ectool runProcedure /plugins/EC-Artifactory/project \
  --procedureName CreateConfiguration \
  --actualParameter \
      instance="${ARTIFACTORY_URL}" \
      config="${ARTIFACTORY_CONFIG}" \
      credential="${ARTIFACTORY_CONFIG}" \
      proxy_credential="${ARTIFACTORY_CONFIG}" \
      checkConnection=0 \
      debugLevel=0 \
  --credential "${ARTIFACTORY_CONFIG}"="${ARTIFACTORY_USER}"
