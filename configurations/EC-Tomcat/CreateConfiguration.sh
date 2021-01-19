# Create EC-Tomcat configuration

TOMCAT_CONFIG=$1
TOMCAT_PW=$2
TOMCAT_URL=$3
TOMCAT_USER=admin

printf "${TOMCAT_PW}\n" |ectool runProcedure /plugins/EC-Tomcat/project \
	--procedureName CreateConfiguration \
	--actualParameter \
        tomcat_home=/opt/bitnami/tomcat \
        tomcat_url="${TOMCAT_URL}" \
        config="${TOMCAT_CONFIG}" \
        credential="${TOMCAT_CONFIG}" \
	--credential "${TOMCAT_CONFIG}"="${TOMCAT_USER}"