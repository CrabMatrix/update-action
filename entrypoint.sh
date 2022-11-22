#!/bin/bash
cd ${GITHUB_WORKSPACE}/${source}

patch=$(git show --pretty=format:%s -s HEAD | grep -o "#patch")
minor=$(git show --pretty=format:%s -s HEAD | grep -o "#minor")
major=$(git show --pretty=format:%s -s HEAD | grep -o "#major")
commit=$(git show --pretty=format:%H -s HEAD)
old=$(semver $(toml get --toml-path=Cargo.toml package.version))
prev_tag_commit=$(git rev-list -n 1 v$old)
echo "prev tag commit " $prev_tag_commit
echo "current commit " $commit
if [ $prev_tag_commit = $commit ]; then
    echo "this commit has already been bumped"
    exit 1;
fi
if [ ! -z "$major" ]; then
    new=$(semver -i major $(toml get --toml-path=Cargo.toml package.version))
elif [ ! -z "$minor" ]; then
    new=$(semver -i minor $(toml get --toml-path=Cargo.toml package.version))
elif [ ! -z "$patch" ]; then 
    new=$(semver -i patch $(toml get --toml-path=Cargo.toml package.version))
else
    new=$(semver -i patch $(toml get --toml-path=Cargo.toml package.version))
fi

if [ $new != $old ]; then
    toml set --toml-path=Cargo.toml package.version $new
fi

echo "::set-output name=old_version::$old"
echo "::set-output name=old_version_with_v::v$old"
echo "::set-output name=new_version::$new"
echo "::set-output name=new_version_with_v::v$new"
