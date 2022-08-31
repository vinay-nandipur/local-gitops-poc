#!/usr/bin/env bash

#!/usr/bin/env bash

get_script_dir () {
      SOURCE="${BASH_SOURCE[0]}"
      # While $SOURCE is a symlink, resolve it
      while [ -h "$SOURCE" ]; do
         DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
         SOURCE="$( readlink "$SOURCE" )"
         # If $SOURCE was a relative symlink (so no "/" as prefix, need to resolve it relative to the symlink base directory
         [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
      done
      DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
      echo "$DIR"
    }

directory_path="$(get_script_dir)"

# tput setaf 6; echo "====================Installing Kind Tool...===================="
#
# docker pull kindest/node:v1.24.2
#
# os_type=$(uname -a 2>&1)
#
# if [[ "$os_type" == *"Darwin"* ]]
# then
#   curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.14.0/kind-darwin-amd64
#   chmod +x ./kind
#   sudo mv ./kind /usr/local/bin/kind
# else
#   curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.14.0/kind-linux-amd64
#   chmod +x ./kind
#   sudo mv ./kind /usr/bin/kind
# fi

# kind_status=$(kind version 2>&1)
#
# if [[ "$kind_status" == *"darwin/amd64"* ]] || [[ "$kind_status" == *"linux/amd64"* ]]
# then
#   tput setaf 2; echo "====================Kind Tool Installation Completed!===================="
# else
#   tput setaf 1; echo "====================Kind Tool Installation Failed!===================="
#   exit 1
# fi
#
# tput setaf 6; echo "====================Creating Kind Kubernetes Cluster...===================="
#
# kind create cluster --config $directory_path/../configs/local-cluster.yml --image kindest/node:v1.24.3 --name local-cluster
#
# cluster_status=$(kind get clusters 2>&1)
#
# if [[ "$cluster_status" == *"No kind clusters found"* ]]
# then
#   tput setaf 1; echo "====================Kind Kubernetes Cluster Creation Failed!===================="
#   exit 1
# else
#   tput setaf 2; echo "====================Kind Kubernetes Cluster Creation Completed!===================="
# fi

tput setaf 6; echo "====================Installing HELM...===================="

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

helm_status=$(helm version 2>&1)

if [[ "$helm_status" == *"version.BuildInfo"* ]]
then
  tput setaf 2; echo "====================HELM Installation Completed!===================="
else
  tput setaf 1; echo "====================HELM Installation Failed!===================="
  exit 1
fi

kubectl config use-context docker-desktop
# kubectl config use-context kind-local-cluster
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl create namespace sonarqube
kubectl create namespace identity


# kubectl config set contexts.$(kubectl config current-context).namespace sonarqube
