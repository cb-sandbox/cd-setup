# Create EC-JIRA configuration

JIRA_CONFIG=$1
JIRA_USER=$2
JIRA_PW=$3
JIRA_URL=$4

printf "${JIRA_PW}\n" | ectool runProcedure /plugins/EC-JIRA/project \
  --procedureName CreateConfiguration \
  --actualParameter \
      config="${JIRA_CONFIG}" \
      credential="${JIRA_CONFIG}" \
      checkConnection=false \
      url="${JIRA_URL}" \
      auth="basic" \
  --credential "${JIRA_CONFIG}"="${JIRA_USER}"
