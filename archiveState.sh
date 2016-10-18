#!/bin/bash -e

export REPO_RESOURCE_NAME="infra-repo"

arch_statefile() {
  TF_FOLDER=$1
  pushd "/build/IN/$REPO_RESOURCE_NAME/gitRepo/$TF_FOLDER"
  local state_loc="terraform.tfstate"
  if [ -f "$state_loc" ]; then
    echo "new state file exists, copying"
    echo "-----------------------------------"
    cp -vr terraform.tfstate /build/state/$TF_FOLDER/
  else
    local previous_statefile_location="/build/previousState/$TF_FOLDER/terraform.tfstate"
    if [ -f "$previous_statefile_location" ]; then
      echo "previous state file exists, copying"
      echo "-----------------------------------"
      cp -vr previousState/$TF_FOLDER/terraform.tfstate /build/state/$TF_FOLDER/
    else
      echo "no previous state file exists. adding tmp file"
      echo "-----------------------------------"
      #this is to guarantee folder existence
      mkdir -p /build/state/$TF_FOLDER && touch /build/state/$TF_FOLDER/tmp.txt
    fi
  fi
  popd
}

main() {
  arch_statefile alpha-saas
  arch_statefile alpha-server
  arch_statefile rc-saas
  arch_statefile rc-server
}

main
