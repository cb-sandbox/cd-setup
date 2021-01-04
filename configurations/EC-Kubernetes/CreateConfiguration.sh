export KUBE_ENDPOINT=TBD

export KUBE_USER="api-test-user"
kubectl create serviceaccount $KUBE_USER
kubectl create clusterrolebinding root-cluster-admin-binding --clusterrole=cluster-admin --serviceaccount=default:${KUBE_USER}
export KUBE_SECRET=$(kubectl get serviceaccount $KUBE_USER -o yaml | grep ${KUBE_USER}-token | cut -d" " -f 3)
export KUBE_TOKEN=$(kubectl get secret $KUBE_SECRET -o yaml | grep token: | cut -d" " -f 4| base64 --decode)
export KUBE_CONFIG=$KUBE_ENDPOINT
printf "${KUBE_TOKEN}\n" |ectool runProcedure /plugins/EC-Kubernetes/project \
	--procedureName CreateConfiguration \
	--actualParameter \
        clusterEndpoint="${KUBE_ENDPOINT}" \
        kubernetesVersion="1.15" \
        testConnection="true" \
        config="${KUBE_CONFIG}" \
        credential="${KUBE_CONFIG}" \
	--credential "${KUBE_CONFIG}"="${KUBE_USER}"