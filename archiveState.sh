#!/bin/bash -e

export RES_REPO="infra_repo"
export RES_REPO_UP=$(echo $RES_REPO | awk '{print toupper($0)}')
export RES_REPO_STATE=$(eval echo "$"$RES_REPO_UP"_STATE") #loc of git repo clone

arch_statefile() {
  TF_FOLDER=$1
  mkdir -p /build/state/$TF_FOLDER

  pushd "$RES_REPO_STATE/$TF_FOLDER"
  local state_loc="terraform.tfstate"
  if [ -f "$state_loc" ]; then
    echo "new state file exists, copying"
    echo "-----------------------------------"
    cp -vr terraform.tfstate /build/state/$TF_FOLDER/
  else
    ls -al $JOB_PREVIOUS_STATE/$TF_FOLDER
    local previous_statefile_location="$JOB_PREVIOUS_STATE/$TF_FOLDER/terraform.tfstate"
    if [ -f "$previous_statefile_location" ]; then
      echo "previous state file exists, copying"
      echo "-----------------------------------"
      cp -vr $previous_statefile_location /build/state/$TF_FOLDER/
    else
      echo "no previous state file exists. adding tmp file"
      echo "-----------------------------------"
      #this is to guarantee folder existence
      touch /build/state/$TF_FOLDER/tmp.txt
    fi
  fi
  popd
}

main() {
  arch_statefile alpha-saas
  arch_statefile alpha-server
  arch_statefile rc-saas
  arch_statefile rc-server
  arch_statefile prod-saas
}

main
