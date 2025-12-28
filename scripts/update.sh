#!/bin/bash

# If any command fails, exit immediately
set -e

REPO_NAME="pol-rivero/github-desktop-plus"
FLATPAK_NAME="io.github.pol_rivero.github-desktop-plus"

REPO_URL="https://github.com/$REPO_NAME.git"
YAML_FILE="$FLATPAK_NAME.yaml"
SCRIPTS_DIR="$(dirname "$(realpath "$0")")"
REPO_ROOT="$(dirname "$SCRIPTS_DIR")"

# 0. Check if version has changed
pattern="\s*APP_VERSION: ([0-9.]+)"
OLD_VERSION=$(sed -nE "s/$pattern/\1/p" "$YAML_FILE")
echo "OLD version: $OLD_VERSION"

TAG_NAME=$(curl -s "https://api.github.com/repos/$REPO_NAME/releases/latest" | jq -r .tag_name)
VERSION="${TAG_NAME#v}"
echo "NEW version: $VERSION"

if [ "$OLD_VERSION" = "$VERSION" ]; then
  echo "Versions are the same. No update needed."
  exit 0
fi

PR_COUNT=$(curl -s "https://api.github.com/repos/flathub/$FLATPAK_NAME/pulls?state=open" | jq length)
if [ "$PR_COUNT" -gt 0 ]; then
  echo "There are open pull requests. Skipping update."
  exit 0
fi

echo "Versions differ. Updating to $TAG_NAME"

cd "$REPO_ROOT"

# 1. Get the hash of the specified tag
rm -rf github-desktop-plus
git clone --depth 1 --branch "$TAG_NAME" $REPO_URL github-desktop-plus
COMMIT_HASH=$(git -C github-desktop-plus rev-parse HEAD)

# 2. Generate 'generated-sources.json'
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
./generate-sources

# 3. Update flatpak yaml
# url: <url>
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

# Cleanup
rm $YAML_FILE.bak
rm -rf github-desktop-plus
rm -rf .venv

# The only files that should be committed are $YAML_FILE and generated-sources.json
git status

if [ -n "$GITHUB_ENV" ]; then
  echo "update_tag_name=$TAG_NAME" >> "$GITHUB_ENV"
fi
