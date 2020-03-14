#!/bin/bash
set -e
set -o pipefail
TARGETBRANCH=$1

main() {
  echo "Current ref: ${GITHUB_REF}"
  BRANCH=${GITHUB_REF:11}
  echo "Current branch: ${BRANCH}"

  echo "Verify ${BRANCH} over ${TARGETBRANCH}"

  if [ "$BRANCH" == "$TARGETBRANCH" ]; then
    echo "No check of current branch needed."
    exit 0
  fi

  # Using git directly because the $GITHUB_EVENT_PATH file only shows commits in
  # most recent push.
  /usr/bin/git -c protocol.version=2 fetch --no-tags --prune --progress --no-recurse-submodules --depth=1 origin ${TARGETBRANCH}
  /usr/bin/git -c protocol.version=2 fetch --no-tags --prune --progress --no-recurse-submodules --shallow-exclude=${TARGETBRANCH} origin ${BRANCH}

  echo "/usr/bin/git log --no-merges origin/${TARGETBRANCH} ^origin/${BRANCH}"

  NOT_EMPTY_MERGES_LIST=`/usr/bin/git log --no-merges origin/${TARGETBRANCH} ^origin/${BRANCH}`
  NOT_EMPTY_MERGES_COUNT=`echo $NOT_EMPTY_MERGES_LIST | grep "commit" | wc -l || true`
  echo "Not included commits numbers: ${NOT_EMPTY_MERGES_COUNT}"

  if [ "$NOT_EMPTY_MERGES_COUNT" -gt "0" ]; then
    echo $NOT_EMPTY_MERGES_LIST
    echo "failing..."
    exit 1
  fi
}

main
