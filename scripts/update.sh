#!/bin/bash

# If any command fails, exit immediately
set -e

REPO_URL="https://github.com/pol-rivero/github-desktop-plus.git"
YAML_FILE="io.github.pol_rivero.github-desktop-plus.yaml"
SCRIPTS_DIR="$(dirname "$(realpath "$0")")"
REPO_ROOT="$(dirname "$SCRIPTS_DIR")"

VERSION="$1"
if [ -z "$VERSION" ]; then
  echo "Usage: $0 <version>"
  exit 1
fi
if ! [[ "$VERSION" =~ ^v?[0-9]+\.[0-9]+\.[0-9]+(\.[0-9]+)?$ ]]; then
  echo "Error: Version must be in the format X.Y.Z or X.Y.Z.W (with optional 'v' prefix)"
  exit 1
fi

# Remove 'v' prefix if present
VERSION="${VERSION#v}"
TAG_NAME="v$VERSION"

cd "$REPO_ROOT"

# 0. Create or switch to branch
BRANCH_NAME="update-$VERSION"
if git rev-parse --verify "$BRANCH_NAME" >/dev/null 2>&1; then
  git checkout "$BRANCH_NAME"
else
  git checkout -b "$BRANCH_NAME"
fi

# 1. Get the hash of the specified tag
rm -rf github-desktop-plus
git clone --depth 1 --branch "$TAG_NAME" $REPO_URL github-desktop-plus
COMMIT_HASH=$(git -C github-desktop-plus rev-parse HEAD)

# 2. Generate 'generated-sources.json'
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
./generate-sources

# 3. Update flatpak yaml
# url: https://github.com/pol-rivero/github-desktop-plus.git
# tag: vX.Y.Z.W
# commit: <hash>
escaped_url=$(echo "$REPO_URL" | sed 's/[.[\*^$]/\\&/g')
pattern="(\s*url: $escaped_url\n\s*tag: )v[0-9.]+\n(\s*commit: )[a-f0-9]+"
replacement="\1$TAG_NAME\n\2$COMMIT_HASH"
sed -E -i.bak -z "s|$pattern|$replacement|" $YAML_FILE

# APP_VERSION: X.Y.Z.W
pattern="(\s*APP_VERSION: )[0-9.]+"
replacement="\1$VERSION"
sed -E -i.bak "s|$pattern|$replacement|" $YAML_FILE

# 4. Commit changes
git add $YAML_FILE generated-sources.json
git commit -m "Update to version $VERSION"
git push --set-upstream origin "$BRANCH_NAME"

# N. Cleanup
rm $YAML_FILE.bak
rm -rf github-desktop-plus
rm -rf .venv
