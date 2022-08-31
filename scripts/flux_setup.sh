#!/usr/bin/env bash

# kube_cluster=$(kubectl config current-context)
# if ! kubectl get ns flux ; then kubectl create ns flux ; fi

flux install

{
  export GITHUB_TOKEN=$(cat $HOME/.secrets/.git_token)
  export GITHUB_USER="vinay-nandipur"
  export GITHUB_REPO="local-gitops-poc"
} &> /dev/null 2>&1

flux bootstrap github \
    --context=docker-desktop \
    --owner=${GITHUB_USER} \
    --repository=${GITHUB_REPO} \
    --branch=main \
    --personal \
    --token-auth \
    --path=local-cluster
