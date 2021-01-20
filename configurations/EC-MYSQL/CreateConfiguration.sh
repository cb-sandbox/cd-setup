# Create EC-MYSQL configuration

MYSQL_CONFIG=$1
MYSQL_PW=$2
MYSQL_USER=root

printf "${MYSQL_PW}\n" |ectool runProcedure /plugins/EC-MYSQL/project \
	--procedureName CreateConfiguration \
	--actualParameter \
        config="${MYSQL_CONFIG}" \
        credential="${MYSQL_CONFIG}" \
	--credential "${MYSQL_CONFIG}"="${MYSQL_USER}"