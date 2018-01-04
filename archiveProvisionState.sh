#!/bin/bash -e

export PROV_CONTEXT=$1
export PROV_ENV=$2
export TF_FOLDER="$PROV_CONTEXT-$PROV_ENV"
export RES_STATE=$PROV_CONTEXT"_"$PROV_ENV"_state"

export RES_REPO="infra_repo"
export RES_REPO_UP=$(echo $RES_REPO | awk '{print toupper($0)}')
export RES_REPO_STATE=$(eval echo "$"$RES_REPO_UP"_STATE") #loc of git repo clone

test_context() {
  echo "PROV_CONTEXT=$PROV_CONTEXT"
  echo "PROV_ENV=$PROV_ENV"
  echo "RES_REPO=$RES_REPO"
  echo "TF_FOLDER=$TF_FOLDER"
  echo "RES_STATE=$RES_STATE"

  echo "RES_REPO_UP=$RES_REPO_UP"
  echo "RES_REPO_STATE=$RES_REPO_STATE"
}

arch_statefile() {
  pushd "$RES_REPO_STATE/$TF_FOLDER"
  if [ -f "terraform.tfstate" ]; then
    echo "new state file exists, copying"
    echo "-----------------------------------"
    cp -vr terraform.tfstate /build/state
#    shipctl copy_file_to_resource_state terraform.tfstate $RES_STATE
  else
    # this is a safety measure, if this existed, the above if itself would have
    # yielded a state file
    local prev_state_loc="$JOB_PREVIOUS_STATE/terraform.tfstate"
    if [ -f "$prev_state_loc" ]; then
      echo "previous state file exists, copying $prev_state_loc"
      echo "-----------------------------------"
      cp -vr $prev_state_loc /build/state
#      shipctl copy_file_to_resource_state $prev_state_loc $RES_STATE
    else
      echo "No previous state file exists at $prev_state_loc, skip copying"
      echo "-----------------------------------"
    fi
  fi
  popd
}

main() {
  test_context
  arch_statefile
}

main
