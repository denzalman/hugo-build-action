#!/bin/bash
set -e
set -o pipefail

if [[ -z "$TOKEN" ]]; then
	echo "TOKEN env variable is required."
	exit 1
fi

if [[ -z "$TARGET_REPO" ]]; then
	echo "TARGET_REPO env variable is requered."
	exit 1
fi

if [[ -z "$HUGO_VERSION" ]]; then
	HUGO_VERSION=0.59.1
    echo 'Hugo version set to '${HUGO_VERSION}
fi

echo 'Download Hugo v'${HUGO_VERSION}
curl -sSL https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz > /tmp/hugo.tar.gz && tar -f /tmp/hugo.tar.gz -xz

echo 'Generate Hugo static pages'
./hugo

echo 'Clone GitHub Pages repo '${TARGET_REPO}
OLD_VERSION_DIR=old_version_dir
TARGET_REPO_URL="https://${TOKEN}@github.com/${TARGET_REPO}.git"
git clone "${TARGET_REPO_URL}" "${OLD_VERSION_DIR}"

echo 'Move .git folder into new site folder'
cp -r ${OLD_VERSION_DIR}/.git public/

echo 'Commit and push the new site version'

if ! git config --get user.name; then
    git config --global user.name "${GITHUB_ACTOR}"
fi

if ! git config --get user.email; then
    git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
fi

cd public/

git add . && \
git commit -m "Published by Actions at $(date)" && \
git push origin master

echo 'Complete Github Action: '${GITHUB_ACTION}