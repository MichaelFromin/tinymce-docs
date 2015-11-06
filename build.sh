#!/bin/bash

# exit on firs error
set -e

# vars
DESTINATION="../dist"
REFS_PATH="../refs"
INDEX_TPL=$(cat index.html)

# ensure dirs existence
mkdir -p $REFS_PATH
mkdir -p $DESTINATION

# based on env filter out branches to build
if [[ $JEKYLL_ENV == "production" ]]; then
  branch_filter="origin/v"
else
  branch_filter="origin/"
fi

# loop through remote branches
# and build all versions with changes
for branch in `git branch -r | sed 1d | grep $branch_filter`; do
  branch=$(echo $branch | sed s/origin\\///)

  [[ $branch == "build" ]] && continue

  echo ""

  if [[ $branch == *"/"* ]]; then
    echo " > branch name \"$branch\" contains a slash, skipping..."
    continue
  fi

  echo " > checking out $branch"
  echo ""
  git checkout $branch
  echo ""

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

    # api_version=$(cat .api-version)
    api_version=4.2.6
    echo ""
    echo " > pointing to API version $api_version"
    echo ""

    # checkout correct tinymce version and build it
    # echo ""
    # echo " > builidng tinymce $api_version"
    # echo ""
    # cd ../tinymce
    # git checkout $api_version
    # rm -rf node_modules && npm i
    # grunt default

    # build API docs
    # echo ""
    # echo " > builidng tinymce docs $api_version"
    # echo ""
    # cd ../moxiedoc
    # ./bin/moxiedoc ../tinymce/js/tinymce/classes -t tinymcenext
    # unzip -o tmp/out.zip -d ../tinymce-docs/api
    # rm tmp/out.zip

    # jekyll build
    echo ""
    echo " > builidng jekyll docs"
    echo ""
    cd ../tinymce-docs
    bundle install --no-cache --clean --deployment
    rm -rf $DESTINATION/$branch
    echo "baseurl: \"/docs/$branch\"" > _config-prod.yml
    jekyll build --destination $DESTINATION/$branch --config _config.yml,_config-prod.yml
    echo $current_head > "$REFS_PATH/$branch"
    echo ""
  else
    echo " > $branch build is up to date, skipping."
  fi
done

# loop through builds and delete obsolete ones
for build in `ls $DESTINATION`; do
  branch_exists=$(git branch --list "$build")

  if [[ ! $branch_exists ]]; then
    echo ""
    echo " > branch $build has been removed from remote, deleting build..."
    rm -rf $DESTINATION/$build
  fi
done

echo ""
echo " > done."
