# Create EC-Helm configuration

HELM_CONFIG=$1

ectool runProcedure /plugins/EC-Helm/project \
  --procedureName CreateConfiguration \
  --actualParameter \
    config="${HELM_CONFIG}" \
    checkConnection=0 \
    checkConnectionResource= 0 \
    createKubeconfig=0 \
    debugLevel=0 \
    desc="" \
    helmPath=helm \
    helmVersion=3 \
    kubeconfigContent="" \
    kubectlPath=kubectl \
    options=""