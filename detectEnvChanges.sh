#!/bin/bash -e

export REPO_RESOURCE_NAME="infra-repo"

detectEnvChanges() {
  echo "Getting commit range for current change set for repo" $REPO_RESOURCE_NAME
  export COMMIT_RANGE=$(cat /build/IN/$REPO_RESOURCE_NAME/version.json | jq -r \
  '.version.propertyBag.shaData.beforeCommitSha + ".."+ .version.propertyBag.shaData.commitSha')
  echo "Commit Range is" $COMMIT_RANGE

  pushd /build/IN/$REPO_RESOURCE_NAME/gitRepo

  echo "detecting changes for this build"
  envs=`git diff --name-only $COMMIT_RANGE | sort -u | \
  awk 'BEGIN {FS="/"} {print $1}' | uniq`

  ls -al
  for env in $envs
  do
    if [ env!="/" ]; then
      echo "changed env is $env"
      ls -al $env
    fi
  done
  popd
}

main() {
  detectEnvChanges
}

main
