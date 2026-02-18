#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/bump-version.sh [-n|--dry-run] <patch|minor|major|beta|VERSION>
# Examples:
#   ./scripts/bump-version.sh patch        # 0.2.11 -> 0.2.12
#   ./scripts/bump-version.sh minor        # 0.2.11 -> 0.3.0
#   ./scripts/bump-version.sh major        # 0.2.11 -> 1.0.0
#   ./scripts/bump-version.sh beta         # 0.2.11 -> 0.2.12-beta.1, or 0.2.12-beta.1 -> 0.2.12-beta.2
#   ./scripts/bump-version.sh 0.4.0-rc.1   # explicit version
#   ./scripts/bump-version.sh -n patch     # dry run — show what would happen

DRY_RUN=false
if [[ "${1:-}" == "-n" || "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  shift
fi

BUMP="${1:?Usage: npm run release -- [-n|--dry-run] <patch|minor|major|beta|VERSION>}"

CURRENT_VERSION=$(node -p "require('./package.json').version")

# Parse current version components
if [[ "$CURRENT_VERSION" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)(-([a-zA-Z]+)\.([0-9]+))?$ ]]; then
  CUR_MAJOR="${BASH_REMATCH[1]}"
  CUR_MINOR="${BASH_REMATCH[2]}"
  CUR_PATCH="${BASH_REMATCH[3]}"
  CUR_PRE_TAG="${BASH_REMATCH[5]}"
  CUR_PRE_NUM="${BASH_REMATCH[6]}"
else
  echo "Error: cannot parse current version '$CURRENT_VERSION'"
  exit 1
fi

case "$BUMP" in
  patch)
    # If currently a pre-release, drop the pre-release suffix (release it)
    if [[ -n "$CUR_PRE_TAG" ]]; then
      VERSION="${CUR_MAJOR}.${CUR_MINOR}.${CUR_PATCH}"
    else
      VERSION="${CUR_MAJOR}.${CUR_MINOR}.$((CUR_PATCH + 1))"
    fi
    ;;
  minor)
    VERSION="${CUR_MAJOR}.$((CUR_MINOR + 1)).0"
    ;;
  major)
    VERSION="$((CUR_MAJOR + 1)).0.0"
    ;;
  beta)
    if [[ "$CUR_PRE_TAG" == "beta" ]]; then
      # Already a beta — increment the beta number
      VERSION="${CUR_MAJOR}.${CUR_MINOR}.${CUR_PATCH}-beta.$((CUR_PRE_NUM + 1))"
    else
      # Start a new beta on the next patch
      VERSION="${CUR_MAJOR}.${CUR_MINOR}.$((CUR_PATCH + 1))-beta.1"
    fi
    ;;
  *)
    # Treat as an explicit version string
    VERSION="$BUMP"
    ;;
esac

# Validate semver-ish format
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?$ ]]; then
  echo "Error: '$VERSION' is not a valid semver version"
  exit 1
fi

echo "Current version: $CURRENT_VERSION"
echo "New version:     $VERSION"
BRANCH="release/v${VERSION}"

PRERELEASE_LABEL=""
if [[ "$VERSION" == *-* ]]; then
  PRERELEASE_LABEL=",pre-release"
fi

if [ "$DRY_RUN" = true ]; then
  echo ""
  echo "Dry run — the following actions would be performed:"
  echo "  1. Create branch '$BRANCH' from origin/main"
  echo "  2. Run: npm version $VERSION --no-git-tag-version"
  echo "  3. Commit: \"Bump version to $VERSION\""
  echo "  4. Push branch '$BRANCH' to origin"
  echo "  5. Open PR: \"Release v${VERSION}\" with labels: version-update${PRERELEASE_LABEL}"
  exit 0
fi

# Ensure working tree is clean
if ! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
  echo "Error: working tree is not clean. Commit or stash changes first."
  exit 1
fi

# Create branch from latest main
git fetch origin main
git checkout -b "$BRANCH" origin/main

# Bump the version in package.json using npm (no git tag)
npm version "$VERSION" --no-git-tag-version

# Commit and push
git add package.json package-lock.json
git commit -m "Bump version to $VERSION"
git push -u origin "$BRANCH"

# Open a PR with the version-update label
gh pr create \
  --title "Release v${VERSION}" \
  --body "Automated version bump to \`${VERSION}\`." \
  --base main \
  --label "version-update${PRERELEASE_LABEL}"

echo ""
echo "PR created for v${VERSION}. CI will validate and auto-merge."
