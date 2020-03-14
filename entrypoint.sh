#!/bin/bash
set -e
set -o pipefail
TARGETBRANCH=$1

main() {
  BRANCH=${GITHUB_REF}

  echo "Verify ${BRANCH} over $1"

  if [ "$BRANCH" == "$TARGETBRANCH" ]; then
    echo "No check of current branch needed."
    exit 0
  fi

  echo "/usr/bin/git log --no-merges ${TARGETBRANCH} ^${BRANCH}"

  NOT_EMPTY_MERGES_LIST=`/usr/bin/git log --no-merges ${TARGETBRANCH} ^${BRANCH}`
  NOT_EMPTY_MERGES_COUNT=`echo $NOT_EMPTY_MERGES_LIST | grep "commit" | wc -l || true`
  echo "Not included commits numbers: ${NOT_EMPTY_MERGES_COUNT}"

  if [ "$NOT_EMPTY_MERGES_COUNT" -gt "0" ]; then
    echo $NOT_EMPTY_MERGES_LIST
    echo "failing..."
    exit 1
  fi
}

main