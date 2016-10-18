#!/bin/bash -e

export REPO_RESOURCE_NAME="infra-repo"

detectEnvChanges() {
  echo "Getting commit range for current change set for repo" $REPO_RESOURCE_NAME
  export COMMIT_RANGE=$(cat /build/IN/$REPO_RESOURCE_NAME/version.json | jq -r \
  '.version.propertyBag.shaData.beforeCommitSha + ".."+ .version.propertyBag.shaData.commitSha')
  echo "Commit Range is" $COMMIT_RANGE

  echo "detecting changes for this build"
  envs=`git diff --name-only $COMMIT_RANGE | sort -u | \
  awk 'BEGIN {FS="/"} {print $1}' | uniq`

  for env in $envs
  do
    ls -al /build/IN/$REPO_RESOURCE_NAME/gitRepo/$env
  done
}

main() {
  detectEnvChanges
}

main
