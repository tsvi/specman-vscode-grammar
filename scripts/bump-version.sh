#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/bump-version.sh [-n|--dry-run] <patch|minor|major|prerelease|VERSION>
# Examples:
#   ./scripts/bump-version.sh patch        # 0.2.11 -> 0.2.12
#   ./scripts/bump-version.sh minor        # 0.2.11 -> 0.3.0
#   ./scripts/bump-version.sh major        # 0.2.11 -> 1.0.0
#   ./scripts/bump-version.sh prerelease   # 0.2.11 -> 0.2.12 (published as VS Code pre-release)
#   ./scripts/bump-version.sh 0.4.0        # explicit version
#   ./scripts/bump-version.sh -n patch     # dry run — show what would happen

DRY_RUN=false
if [[ "${1:-}" == "-n" || "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  shift
fi

BUMP="${1:?Usage: npm run release -- [-n|--dry-run] <patch|minor|major|prerelease|VERSION>}"

CURRENT_VERSION=$(node -p "require('./package.json').version")

# Parse current version components
if [[ "$CURRENT_VERSION" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  CUR_MAJOR="${BASH_REMATCH[1]}"
  CUR_MINOR="${BASH_REMATCH[2]}"
  CUR_PATCH="${BASH_REMATCH[3]}"
else
  echo "Error: cannot parse current version '$CURRENT_VERSION'"
  exit 1
fi

IS_PRERELEASE=false

case "$BUMP" in
  patch)
    VERSION="${CUR_MAJOR}.${CUR_MINOR}.$((CUR_PATCH + 1))"
    ;;
  minor)
    VERSION="${CUR_MAJOR}.$((CUR_MINOR + 1)).0"
    ;;
  major)
    VERSION="$((CUR_MAJOR + 1)).0.0"
    ;;
  prerelease)
    VERSION="${CUR_MAJOR}.${CUR_MINOR}.$((CUR_PATCH + 1))"
    IS_PRERELEASE=true
    ;;
  *)
    # Treat as an explicit version string
    VERSION="$BUMP"
    ;;
esac

# Validate version format (must be major.minor.patch, no pre-release suffix)
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: '$VERSION' is not a valid version (must be major.minor.patch)"
  echo "VS Code Marketplace does not support pre-release suffixes like -beta.1"
  echo "Use 'prerelease' bump type instead to publish as a VS Code pre-release."
  exit 1
fi

echo "Current version: $CURRENT_VERSION"
echo "New version:     $VERSION"
if [ "$IS_PRERELEASE" = true ]; then
  echo "Type:            pre-release"
fi
BRANCH="release/v${VERSION}"

PRERELEASE_LABEL=""
if [ "$IS_PRERELEASE" = true ]; then
  PRERELEASE_LABEL=",pre-release"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define all release steps (used for both dry-run and error recovery)
STEPS=(
  "git fetch origin main && git checkout -b '$BRANCH' origin/main"
  "npm version '$VERSION' --no-git-tag-version"
  "$SCRIPT_DIR/update-changelog.sh '$VERSION'"
  "git add package.json package-lock.json CHANGELOG.md && git commit -m 'Bump version to $VERSION'"
  "git push -u origin '$BRANCH'"
  "gh pr create --title 'Release v${VERSION}' --body 'Automated version bump to ${VERSION}.' --base main --label 'version-update${PRERELEASE_LABEL}'"
)

STEP_LABELS=(
  "Create branch '$BRANCH' from origin/main"
  "Bump version to $VERSION in package.json"
  "Update CHANGELOG.md with commits since last tag"
  "Commit changes"
  "Push branch '$BRANCH' to origin"
  "Open PR: \"Release v${VERSION}\" with labels: version-update${PRERELEASE_LABEL}"
)

if [ "$DRY_RUN" = true ]; then
  echo ""
  echo "Dry run — the following actions would be performed:"
  for i in "${!STEP_LABELS[@]}"; do
    echo "  $((i + 1)). ${STEP_LABELS[$i]}"
    echo "     $ ${STEPS[$i]}"
  done
  exit 0
fi

# Ensure working tree is clean
if ! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
  echo "Error: working tree is not clean. Commit or stash changes first."
  exit 1
fi

# --- Helper: print remaining steps on failure ---
fail() {
  local failed_step=$1
  echo ""
  echo "ERROR: Step $((failed_step + 1)) failed: ${STEP_LABELS[$failed_step]}"
  echo ""
  echo "To recover, run the remaining steps manually:"
  for ((i = failed_step; i < ${#STEPS[@]}; i++)); do
    echo "  $((i + 1)). ${STEP_LABELS[$i]}"
    echo "     $ ${STEPS[$i]}"
  done
  exit 1
}

# Execute each step
for i in "${!STEPS[@]}"; do
  echo "Step $((i + 1)): ${STEP_LABELS[$i]}"
  eval "${STEPS[$i]}" || fail "$i"
done

echo ""
echo "PR created for v${VERSION}. CI will validate and auto-merge."
