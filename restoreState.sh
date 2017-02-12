#!/bin/bash -e

export REPO_RESOURCE_NAME="infra-repo"

arch_statefile() {
  TF_FOLDER=$1
  echo "Copying previous state file"
  echo "-----------------------------------"
  local previous_statefile_location="$JOB_PREVIOUS_STATE/$TF_FOLDER/terraform.tfstate"
  if [ -f "$previous_statefile_location" ]; then
    echo "statefile exists, copying"
    echo "-----------------------------------"
    cp -vr previous_statefile_location /build/IN/$REPO_RESOURCE_NAME/gitRepo/$TF_FOLDER
  else
    echo "no previous statefile exists"
    echo "-----------------------------------"
  fi
}

main() {
  arch_statefile alpha-saas
  arch_statefile alpha-server
  arch_statefile rc-saas
  arch_statefile rc-server
  arch_statefile prod-saas
}

main
