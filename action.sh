#!/bin/bash

set -e
set -o pipefail

if [[ -n "$TOKEN" ]]; then
	GITHUB_TOKEN=$TOKEN
fi

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "Set the TOKEN env variable."
	exit 1
fi

if [[ -z "$TARGET_REPO" ]]; then
	echo "Set the TARGET_REPO env variable."
	exit 1
fi

if [[ -z "$HUGO_VERSION" ]]; then
	HUGO_VERSION=0.59.1
    echo 'Hugo version set to '$HUGO_VERSION
fi

echo 'Downloading Hugo v$HUGO_VERSION'
curl -sSL https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz > /tmp/hugo.tar.gz && tar -f /tmp/hugo.tar.gz -xz

echo 'Building the site static pages'
./hugo

echo 'Clone GitHub Pages repo '${TARGET_REPO}
OLD_VERSION_DIR=old_version_dir
#rm -fr "${OLD_VERSION_DIR}"
TARGET_REPO_URL="https://${GITHUB_TOKEN}@github.com/${TARGET_REPO}.git"
git clone "${TARGET_REPO_URL}" "${OLD_VERSION_DIR}"

echo 'Rewrite old files with the new version'
#cp -r public/* ${OLD_VERSION_DIR}/
cp -r ${OLD_VERSION_DIR}/.git public/

echo 'Commit and push the new version'
(
    if git config --get user.name; then
        git config --global user.name "${GITHUB_ACTOR}"
    fi

    if ! git config --get user.email; then
        git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
    fi

    # cd "${OLD_VERSION_DIR}"
    cd public/

    # if git diff --exit-code; then
    #     echo "There is nothing to commit, so aborting"
    #     exit 0
    # fi

    # Now add all the changes and commit and push
    git add . && \
    git commit -m "Published by Actions at $(date)" && \
    git push origin master
)

echo 'Complete: '${date}
echo 'Github Action: '${GITHUB_ACTION}