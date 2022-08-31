#!/usr/bin/env bash

PROD_CLUSTER_NAME=$1

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

tput setaf 6; echo "====================Installing|Upgrading HELM...===================="

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

helm_status=$(helm version 2>&1)

if [[ "$helm_status" == *"version.BuildInfo"* ]]
then
  tput setaf 2; echo "====================HELM Installation Completed!===================="
else
  tput setaf 1; echo "====================HELM Installation Failed!===================="
  exit 1
fi

{
  export GITHUB_TOKEN=$(cat $HOME/.secrets/.git_token)
  export GITHUB_USER="vinay-nandipur"
  export GITHUB_REPO="local-gitops-poc"
} &> /dev/null 2>&1

flux create helmrelease sonarqube-local-helmrelease \
  --source=GitRepository/helm-chart-sonarqube \
  --namespace=dpe-sonarqube \
  --service-account=dpe-sonarqube-gitops \
  --chart=charts/sonarqube \
  --interval=5m \
  --export > "$directory_path/../${PROD_CLUSTER_NAME}/helmrelease.yaml"

pushd $directory_path/../${PROD_CLUSTER_NAME} && \
rm -rf kustomization.yaml && \
kustomize init --autodetect
popd
