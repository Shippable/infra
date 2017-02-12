#!/bin/bash -e

export REPO_RESOURCE_NAME="infra_repo"
export RES_REPO="infra_repo"
export RES_REPO_UP=$(echo $RES_REPO | awk '{print toupper($0)}')
export RES_REPO_STATE=$(eval echo "$"$RES_REPO_UP"_STATE") #loc of git repo clone
export RES_REPO_META=$(eval echo "$"$RES_REPO_UP"_META") #loc of git repo clone

detectEnvChanges() {
  echo "Getting commit range for current change set for repo" $REPO_RESOURCE_NAME
  export COMMIT_RANGE=$(cat $RES_REPO_META/version.json | jq -r \
  '.version.propertyBag.shaData.beforeCommitSha + ".."+ .version.propertyBag.shaData.commitSha')
  echo "Commit Range is" $COMMIT_RANGE

  pushd $RES_REPO_STATE

  echo "detecting changes for this build"
  envs=`git diff --name-only $COMMIT_RANGE | sort -u | \
  awk 'BEGIN {FS="/"} {print $1}' | uniq`

  for env in $envs
  do
    if [ env!="/" ]; then
      echo "changed env is $env"
      ./$env/build.sh
    fi
  done
  popd
}

main() {
  detectEnvChanges
}

main
