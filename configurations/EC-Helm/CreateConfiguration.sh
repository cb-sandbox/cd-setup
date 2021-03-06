# Create EC-Helm configuration

HELM_CONFIG=$1

ectool runProcedure /plugins/EC-Helm/project \
  --procedureName CreateConfiguration \
  --actualParameter \
    config="${HELM_CONFIG}" \
    helmPath=/usr/sbin/helm \
    helmVersion=3 \
    checkConnection=0 \
    checkConnectionResource=0 \
    createKubeconfig=0 \
    debugLevel=0 \
    desc="" \
    kubectlExecutablePath="" \
    kubectlPath=/usr/local/bin/kubectl \
    options=""