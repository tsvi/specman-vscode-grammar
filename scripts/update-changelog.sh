#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/update-changelog.sh <version>
# Generates a changelog entry for <version> from git commits since the last tag,
# and stamps the [Unreleased] section in CHANGELOG.md.

VERSION="${1:?Usage: $0 <version>}"
CHANGELOG="CHANGELOG.md"
DATE=$(date +%Y-%m-%d)
REPO_URL="https://github.com/tsvi/specman-vscode-grammar"

# Find the previous tag (latest by version sort)
PREV_TAG=$(git tag -l --sort=-v:refname | head -1 || echo "")

# Collect commit subjects since last tag, excluding merge commits and version bumps
if [ -n "$PREV_TAG" ]; then
  COMMITS=$(git log --format="- %s" "$PREV_TAG..HEAD" --no-merges | grep -v "^- [0-9]\+\.[0-9]\+\.[0-9]\+" | grep -v "^- Bump version" || true)
else
  COMMITS=$(git log --format="- %s" --no-merges || true)
fi

if [ -z "$COMMITS" ]; then
  COMMITS="- No notable changes"
fi

# Build the new version entry
NEW_ENTRY="## [$VERSION] - $DATE

$COMMITS"

# Build the new comparison link
if [ -n "$PREV_TAG" ]; then
  NEW_LINK="[$VERSION]: $REPO_URL/compare/$PREV_TAG...v$VERSION"
else
  NEW_LINK="[$VERSION]: $REPO_URL/releases/tag/v$VERSION"
fi

# Update CHANGELOG.md:
# 1. Replace [Unreleased] contents with blank, insert new version entry below it
# 2. Update the [Unreleased] comparison link
# 3. Add the new version comparison link

if [ ! -f "$CHANGELOG" ]; then
  echo "Error: $CHANGELOG not found"
  exit 1
fi

# Use awk to insert the new entry after the [Unreleased] section header
awk -v new_entry="$NEW_ENTRY" -v new_link="$NEW_LINK" -v version="$VERSION" -v repo_url="$REPO_URL" '
  # Track if we found and processed the Unreleased section
  BEGIN { found_unreleased=0; printed_entry=0; in_unreleased=0 }

  # Match the ## [Unreleased] line
  /^## \[Unreleased\]/ {
    print $0
    print ""
    print new_entry
    print ""
    found_unreleased=1
    in_unreleased=1
    printed_entry=1
    next
  }

  # Skip content between [Unreleased] and the next ## section
  in_unreleased && /^## \[/ {
    in_unreleased=0
    print $0
    next
  }
  in_unreleased { next }

  # Update the [Unreleased] comparison link
  /^\[Unreleased\]:/ {
    print "[Unreleased]: " repo_url "/compare/v" version "...HEAD"
    print new_link
    next
  }

  { print }
' "$CHANGELOG" > "${CHANGELOG}.tmp" && mv "${CHANGELOG}.tmp" "$CHANGELOG"

echo "Updated $CHANGELOG with entry for $VERSION"
