#!/bin/bash -e

export RES_REPO="infra_repo"
export RES_REPO_UP=$(echo $RES_REPO | awk '{print toupper($0)}')
export RES_REPO_STATE=$(eval echo "$"$RES_REPO_UP"_STATE") #loc of git repo clone

arch_statefile() {
  TF_FOLDER=$1
  echo "Copying previous state file"
  echo "-----------------------------------"
  local previous_statefile_location="$JOB_PREVIOUS_STATE/$TF_FOLDER/terraform.tfstate"
  if [ -f "$previous_statefile_location" ]; then
    echo "statefile exists, copying"
    echo "-----------------------------------"
    cp -vr $previous_statefile_location "$RES_REPO_STATE/$TF_FOLDER"
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
