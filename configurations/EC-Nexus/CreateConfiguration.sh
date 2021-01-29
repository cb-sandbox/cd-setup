# Create EC-Nexus configuration
# TODO:
# - use IP instead of localhost

NEXUS_CONFIG=$1
NEXUS_PW=$2
NEXUS_URL=$3
NEXUS_USER="admin"

printf "${NEXUS_PW}\n" | ectool runProcedure /plugins/EC-Nexus/project \
  --procedureName CreateConfiguration \
  --actualParameter \
      instance="${NEXUS_URL}" \
      config="${NEXUS_CONFIG}" \
      credential="${NEXUS_CONFIG}" \
  --credential "${NEXUS_CONFIG}"="${NEXUS_USER}"
