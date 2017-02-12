#!/bin/bash -e

export RES_TMP_ST="tmp_fetch_state"
export RES_TMP_ST_UP=$(echo $RES_TMP_ST | awk '{print toupper($0)}')
export RES_TMP_ST_STATE=$(eval echo "$"$RES_TMP_ST_UP"_STATE") #loc of git repo clone

arch_statefile() {
  TF_FOLDER=$1
  echo "Copying previous state file"
  echo "-----------------------------------"
  cp -vr "$RES_TMP_ST_STATE/$TF_FOLDER/terraform.tfstate" /build/state/$TF_FOLDER
}

main() {
  echo "RES_TMP_ST_STATE : $RES_TMP_ST_STATE"

  arch_statefile alpha-saas
  arch_statefile alpha-server
  arch_statefile rc-saas
  arch_statefile rc-server
  arch_statefile prod-saas
}

main
