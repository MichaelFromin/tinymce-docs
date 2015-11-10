#!/bin/bash

# exit on firs error
set -e

# vars
PWD=`pwd`
BUILDS_DIR="${PWD}/../builds"
DIST_DIR="${PWD}/../dist"
REFS_DIR="${PWD}/../refs"

# ensure dirs existence
mkdir -p $REFS_DIR
mkdir -p $BUILDS_DIR
mkdir -p $DIST_DIR

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

  if [[ $branch == "master" ]]; then
    basedir=""
  else
    basedir="/${branch}"
  fi

  echo " > checking out $branch"
  echo ""
  git checkout $branch
  echo ""

  current_head=$(git rev-parse HEAD)
  echo " > current HEAD at $current_head"

  last_head=$(cat $REFS_DIR/$branch 2>/dev/null || echo "NONE")
  echo " > last build HEAD at $last_head"

  build_not_found=""
  has_changes=""

  if [[ $current_head != $last_head ]]; then
    echo " > $branch has changes"
    has_changes=1
  fi

  if [[ ! -d "$BUILDS_DIR/$branch" ]]; then
    build_not_found=1
    echo " > $branch build not found"
  fi

  if [[ $has_changes || $build_not_found ]]; then
    echo " > building..."

    # api_version=$(cat .api-version)
    api_version=4.2.6
    echo ""
    echo " > pointing to API version $api_version"
    echo ""

    # checkout correct tinymce version and build it
    echo ""
    echo " > builidng tinymce $api_version"
    echo ""
    cd ../tinymce
    git checkout $api_version
    rm -rf node_modules && npm i
    grunt default

    # build API docs
    echo ""
    echo " > builidng tinymce docs $api_version"
    echo ""
    cd ../moxiedoc
    ./bin/moxiedoc ../tinymce/js/tinymce/classes -t tinymcenext
    unzip -o tmp/out.zip -d ../tinymce-docs
    rm tmp/out.zip

    # jekyll build
    echo ""
    echo " > builidng jekyll docs"
    echo ""
    cd ../tinymce-docs
    bundle install --no-cache --clean --deployment
    rm -rf $BUILDS_DIR/$branch
    echo "baseurl: \"/docs$basedir\"" > _config-prod.yml
    jekyll build --destination $BUILDS_DIR/$branch --config _config.yml,_config-prod.yml
    echo $current_head > "$REFS_DIR/$branch"
    echo ""
  else
    echo " > $branch build is up to date, skipping."
  fi
done

# loop through builds and delete obsolete ones
for build in `ls $BUILDS_DIR`; do
  branch_exists=$(git branch --list "$build")

  if [[ ! $branch_exists ]]; then
    echo ""
    echo " > branch $build has been removed from remote, deleting build..."
    rm -rf $BUILDS_DIR/$build
  fi
done

# create 1:1 bucket structure
rm -rf $DIST_DIR/docs
cp -R $BUILDS_DIR/master $DIST_DIR/docs

for build in `ls $BUILDS_DIR`; do
  [[ $build == "master" ]] && continue
  cp -R $BUILDS_DIR/$build $DIST_DIR/docs/$build
done

echo ""
echo " > done."
