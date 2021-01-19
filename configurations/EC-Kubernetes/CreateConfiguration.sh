KUBE_ENDPOINT=$1
KUBE_CLUSTER=$2

KUBE_USER="api-user"
kubectl create serviceaccount $KUBE_USER
kubectl create clusterrolebinding root-cluster-admin-binding --clusterrole=cluster-admin --serviceaccount=default:${KUBE_USER}
KUBE_SECRET=$(kubectl get serviceaccount $KUBE_USER -o yaml | grep ${KUBE_USER}-token | cut -d" " -f 3)
echo SECRET = $SECRET
KUBE_TOKEN=$(kubectl get secret $KUBE_SECRET -o yaml | grep token: | cut -d" " -f 4| base64 --decode)
echo KUBE_TOKEN = $KUBE_TOKEN
KUBE_CONFIG="${KUBE_CLUSTER}"
echo KUBE_CONFIG = $KUBE_CONFIG
printf "${KUBE_TOKEN}\n" |ectool runProcedure /plugins/EC-Kubernetes/project \
	--procedureName CreateConfiguration \
	--actualParameter \
        clusterEndpoint="https://${KUBE_ENDPOINT}" \
        kubernetesVersion="1.15" \
        testConnection="false" \
        config="${KUBE_CONFIG}" \
        credential="${KUBE_CONFIG}" \
	--credential "${KUBE_CONFIG}"="${KUBE_USER}"