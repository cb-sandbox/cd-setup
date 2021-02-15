# Create EC-FeatureFlags configuration

FM_CONFIG=$1
FM_PASS=$2
FM_USER="admin"

printf "${FM_PASS}\n" | ectool runProcedure /plugins/EC-FeatureFlags/project \
  --procedureName CreateConfiguration \
  --actualParameter \
      config="${FM_CONFIG}" \
      credential="${FM_CONFIG}" \
      checkConnection=false \
  --credential "${FM_CONFIG}"="${FM_USER}"
