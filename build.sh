#!/bin/bash

# exit on firs error
set -e

# vars
SOURCE="."
DESTINATION="../dist"
JEKYLL_ENV="production"
REFS_PATH="../refs"

# ensure dirs existence
mkdir -p $REFS_PATH
mkdir -p $DESTINATION

# loop through remote branches
# and build all versions with changes
for branch in `git branch -r | grep origin/v`; do
  echo ""
  echo " > checking out $branch"

  branch=${branch##*/}
  git checkout $branch

  current_head=$(git rev-parse HEAD)
  echo " > current HEAD at $current_head"

  last_head=$(cat $REFS_PATH/$branch 2>/dev/null || echo "NONE")
  echo " > last build HEAD at $last_head"

  build_not_found=""
  has_changes=""

  if [[ $current_head != $last_head ]]; then
    echo " > $branch has changes"
    has_changes=1
  fi

  if [[ ! -d "$DESTINATION/$branch" ]]; then
    build_not_found=1
    echo " > $branch built not found"
  fi

  if [[ $has_changes || $build_not_found ]]; then
    echo " > building..."
    bundle install --no-cache --clean --deployment
    rm -rf $DESTINATION/$branch
    jekyll build --source $SOURCE --destination $DESTINATION/$branch
    echo $current_head > "$REFS_PATH/$branch"
  else
    echo " > $branch build is up to date, skipping."
  fi
done

# loop through builds and delete obsolete ones
for branch in `ls $DESTINATION`; do
  branch_exists=$(git branch --list "$branch")

  if [[ ! $branch_exists ]]; then
    echo ""
    echo " > branch $branch has been removed from remote, deleting build..."
    rm -rf $DESTINATION/$branch
  fi
done

echo ""
echo "done."
