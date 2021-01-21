# Create EC-Tomcat configuration
# TODO:
# - use IP instead of localhost

TOMCAT_CONFIG=$1
TOMCAT_PW=$2
TOMCAT_URL=$3
TOMCAT_USER=tomcat

printf "${TOMCAT_PW}\n" |ectool runProcedure /plugins/EC-Tomcat/project \
	--procedureName CreateConfiguration \
	--actualParameter \
        tomcat_home=/opt/tomcat/latest \
        tomcat_url="${TOMCAT_URL}" \
        tomcat_url="http://localhost:8080" \
        config="${TOMCAT_CONFIG}" \
        credential="${TOMCAT_CONFIG}" \
	--credential "${TOMCAT_CONFIG}"="${TOMCAT_USER}"