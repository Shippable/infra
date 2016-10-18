#!/bin/bash -e

export TF_INSALL_LOCATION=/opt
export TF_VERSION=0.7.7
export REPO_RESOURCE_NAME="infra-repo"
export RES_AWS_CREDS="aws-alpha-access"
export RES_AWS_PEM="aws-alpha-pem"
export KEY_FILE_NAME="alpha-us-east-1.pem"
export TF_FOLDER="alpha-saas"

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
 pushd /build/IN/$REPO_RESOURCE_NAME/gitRepo/$TF_FOLDER
 echo "Extracting AWS PEM"
 echo "-----------------------------------"
 cat /build/IN/$RES_AWS_PEM/integration.json  | jq -r '.key' > $KEY_FILE_NAME
 chmod 600 $KEY_FILE_NAME
 echo "Completed Extracting AWS PEM"
 echo "-----------------------------------"
 popd
}

destroy_changes() {
  pushd /build/IN/$REPO_RESOURCE_NAME/gitRepo/$TF_FOLDER
  echo "-----------------------------------"
  echo "destroy changes"
  echo "-----------------------------------"
  terraform destroy -force -var-file=/build/IN/$RES_AWS_CREDS/integration.env
  popd
}

apply_changes() {
  pushd /build/IN/$REPO_RESOURCE_NAME/gitRepo/$TF_FOLDER
  echo "-----------------------------------"
  ps -eaf | grep ssh
  ls -al ~/.ssh/
  which ssh-agent

  echo "planning changes"
  echo "-----------------------------------"
  terraform plan -var-file=/build/IN/$RES_AWS_CREDS/integration.env
  echo "apply changes"
  echo "-----------------------------------"
  terraform apply -var-file=/build/IN/$RES_AWS_CREDS/integration.env
  popd
}

main() {
  eval `ssh-agent -s`
  install_terraform
  create_pemfile
  #destroy_changes
  #apply_changes
  touch /build/IN/$REPO_RESOURCE_NAME/gitRepo/$TF_FOLDER/terraform.tfstate
}

main
