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
