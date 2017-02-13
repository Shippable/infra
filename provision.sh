#!/bin/bash -e

export TF_INSALL_LOCATION=/opt
export TF_VERSION=0.7.7

export PROV_CONTEXT=$1
export PROV_ENV=$2
export TF_FOLDER="$PROV_CONTEXT-$PROV_ENV"

export RES_REPO="infra_repo"
export RES_AWS_CREDS=$PROV_CONTEXT"_aws_access"
export RES_AWS_PEM=$PROV_CONTEXT"_aws_pem"
export KEY_FILE_NAME=$PROV_CONTEXT"-us-east-1.pem"
export TMP_STATE_LOC="infra_prov"

export RES_REPO_UP=$(echo $RES_REPO | awk '{print toupper($0)}')
export RES_REPO_STATE=$(eval echo "$"$RES_REPO_UP"_STATE")

export RES_AWS_PEM_UP=$(echo $RES_AWS_PEM | awk '{print toupper($0)}')
export RES_AWS_PEM_META=$(eval echo "$"$RES_AWS_PEM_UP"_META")

export RES_AWS_CREDS_UP=$(echo $RES_AWS_CREDS | awk '{print toupper($0)}')
export RES_AWS_CREDS_META=$(eval echo "$"$RES_AWS_CREDS_UP"_META")

export TMP_STATE_LOC_UP=$(echo $TMP_STATE_LOC | awk '{print toupper($0)}')
export TMP_STATE_LOC_STATE=$(eval echo "$"$TMP_STATE_LOC_UP"_STATE")

test_context() {
  echo "PROV_CONTEXT=$PROV_CONTEXT"
  echo "PROV_ENV=$PROV_ENV"
  echo "RES_REPO=$RES_REPO"
  echo "RES_AWS_CREDS=$RES_AWS_CREDS"
  echo "RES_AWS_PEM=$RES_AWS_PEM"
  echo "KEY_FILE_NAME=$KEY_FILE_NAME"
  echo "TF_FOLDER=$TF_FOLDER"
  echo "TMP_STATE_LOC=$TMP_STATE_LOC"

  echo "RES_REPO_UP=$RES_REPO_UP"
  echo "RES_REPO_STATE=$RES_REPO_STATE"
  echo "RES_AWS_PEM_UP=$RES_AWS_PEM_UP"
  echo "RES_AWS_PEM_META=$RES_AWS_PEM_META"
  echo "RES_AWS_CREDS_UP=$RES_AWS_CREDS_UP"
  echo "RES_AWS_CREDS_META=$RES_AWS_CREDS_META"
  echo "TMP_STATE_LOC_UP=$TMP_STATE_LOC_UP"
  echo "TMP_STATE_LOC_STATE=$TMP_STATE_LOC_STATE"
}

tmp_restore_state(){
  pushd "$TMP_STATE_LOC_STATE/$TF_FOLDER"
  cp -vr terraform.tfstate "$RES_REPO_STATE/$TF_FOLDER"
}

restore_state(){
  echo "Copying previous state file"
  echo "-----------------------------------"

  pushd $JOB_PREVIOUS_STATE
  if [ -f "terraform.tfstate" ]; then
    echo "Previous state file exists, copying"
    echo "-----------------------------------"
    cp -vr terraform.tfstate "$RES_REPO_STATE/$TF_FOLDER"
  else
    echo "No previous state file exists, skipping"
    echo "-----------------------------------"
  fi
  popd
}

install_terraform() {
  pushd $TF_INSALL_LOCATION
  echo "Fetching terraform"
  echo "-----------------------------------"

  rm -rf $TF_INSALL_LOCATION/terraform
  mkdir -p $TF_INSALL_LOCATION/terraform

  wget -q https://releases.hashicorp.com/terraform/$TF_VERSION/terraform_"$TF_VERSION"_linux_386.zip
  apt-get install unzip
  unzip -o terraform_"$TF_VERSION"_linux_386.zip -d $TF_INSALL_LOCATION/terraform
  export PATH=$PATH:$TF_INSALL_LOCATION/terraform
  echo "downloaded terraform successfully"
  echo "-----------------------------------"
  
  local tf_version=$(terraform version)
  echo "Terraform version: $tf_version"
  popd
}

create_pemfile() {
 pushd "$RES_REPO_STATE/$TF_FOLDER"
 echo "Extracting AWS PEM"
 echo "-----------------------------------"
 cat "$RES_AWS_PEM_META/integration.json"  | jq -r '.key' > $KEY_FILE_NAME
 chmod 600 $KEY_FILE_NAME
 echo "Completed Extracting AWS PEM"
 echo "-----------------------------------"
 popd
}

destroy_changes() {
  pushd "$RES_REPO_STATE/$TF_FOLDER"
  echo "-----------------------------------"
  echo "destroy changes"
  echo "-----------------------------------"
  terraform destroy -force -var-file="$RES_AWS_CREDS_META/integration.env"
  popd
}

apply_changes() {
  pushd "$RES_REPO_STATE/$TF_FOLDER"
  echo "-----------------------------------"
  ps -eaf | grep ssh
  which ssh-agent

  echo "planning changes"
  echo "-----------------------------------"
  terraform plan -var-file="$RES_AWS_CREDS_META/integration.env"
  echo "apply changes"
  echo "-----------------------------------"
  #terraform apply -var-file="$RES_AWS_CREDS_META/integration.env"
  popd
}

main() {
  eval `ssh-agent -s`
  test_context
  tmp_restore_state
  restore_state
  install_terraform
  create_pemfile
  #destroy_changes
  apply_changes
}

main
