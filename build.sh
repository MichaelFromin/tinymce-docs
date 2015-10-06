#!/bin/bash

# exit on firs error
set -e

# vars
DESTINATION="../dist"
JEKYLL_ENV="production"
REFS_PATH="../refs"

# ensure dir existence
mkdir -p $REFS_PATH

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

  if [[ $current_head != $last_head ]]; then
    echo " > $branch has changes, building..."
    bundle install --no-cache --clean --deployment
    rm -rf $DESTINATION/$branch
    jekyll build --destination $DESTINATION/$branch
    echo $current_head > "$REFS_PATH/$branch"
  else
    echo " > $branch is up to date, skipping build"
  fi

done

echo ""
echo "done."
