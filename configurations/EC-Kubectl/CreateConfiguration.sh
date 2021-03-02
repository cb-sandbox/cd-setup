# Create EC-Helm configuration

KUBECTL_CONFIG=$1

printf "\n" |ectool runProcedure /plugins/EC-Kubectl/project \
  --procedureName CreateConfiguration \
  --actualParameter \
    config="${KUBECTL_CONFIG}" \
    kubectlPath=/usr/local/bin/kubectl \
    additionalOptionsForKubectl= \
    desc= \
    kubeconfigCluster= \
    kubeconfigContext= \
    kubeconfigPath= \
    kubeconfigSource=kubeconfigDefault \
    kubeconfigUser= \
    logLevel=INFO \
    credential="${KUBECTL_CONFIG}" \
  --credential "${KUBECTL_CONFIG}"=""
  