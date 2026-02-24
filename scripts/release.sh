#!/usr/bin/env bash
set -euo pipefail

# Usage: ./scripts/release.sh [-n|--dry-run] <patch|minor|major|prerelease|VERSION>
# Examples:
#   ./scripts/release.sh patch        # 0.2.11 -> 0.2.12
#   ./scripts/release.sh minor        # 0.2.11 -> 0.3.0
#   ./scripts/release.sh major        # 0.2.11 -> 1.0.0
#   ./scripts/release.sh prerelease   # 0.2.11 -> 0.2.12 (published as VS Code pre-release)
#   ./scripts/release.sh 0.4.0        # explicit version
#   ./scripts/release.sh -n patch     # dry run — show what would happen

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

# Save the current branch/ref so we can return to it later
ORIGINAL_REF=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD)

# Check if working tree is dirty and offer to stash
DID_STASH=false
if ! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
  if [ "$DRY_RUN" = true ]; then
    echo ""
    echo "Working tree is dirty — would prompt to stash changes."
  else
    echo ""
    echo "Working tree is not clean."
    read -rp "Stash changes before proceeding? [Y/n] " answer
    case "${answer:-Y}" in
      [Yy]*)
        git stash push -u -m "release.sh: auto-stash before release v${VERSION}"
        DID_STASH=true
        echo "Changes stashed."
        ;;
      *)
        echo "Aborting. Commit or stash your changes manually first."
        exit 1
        ;;
    esac
  fi
fi

# Define all release steps (used for both dry-run and error recovery)
STEPS=(
  "git fetch origin main && git checkout -b '$BRANCH' origin/main"
  "npm version '$VERSION' --no-git-tag-version"
  "$SCRIPT_DIR/update-changelog.sh '$VERSION'"
  "git add package.json package-lock.json CHANGELOG.md && git commit -m 'Bump version to $VERSION'"
  "git push -u origin '$BRANCH'"
  "gh pr create --title 'Release v${VERSION}' --body 'Automated version bump to ${VERSION}.' --base main --label 'version-update${PRERELEASE_LABEL}'"
  "git checkout '$ORIGINAL_REF'"
  "git branch -D '$BRANCH'"
  "git push origin --delete '$BRANCH'"
)

STEP_LABELS=(
  "Create branch '$BRANCH' from origin/main"
  "Bump version to $VERSION in package.json"
  "Update CHANGELOG.md with commits since last tag"
  "Commit changes"
  "Push branch '$BRANCH' to origin"
  "Open PR: \"Release v${VERSION}\" with labels: version-update${PRERELEASE_LABEL}"
  "Switch back to original branch '$ORIGINAL_REF'"
  "Delete local branch '$BRANCH'"
  "Delete remote branch '$BRANCH'"
)

if [ "$DRY_RUN" = true ]; then
  echo ""
  echo "Dry run — the following actions would be performed:"
  for i in "${!STEP_LABELS[@]}"; do
    echo "  $((i + 1)). ${STEP_LABELS[$i]}"
    echo "     $ ${STEPS[$i]}"
  done
  if [ "$DID_STASH" = false ] && (! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]); then
    echo "  $((${#STEPS[@]} + 1)). Pop stashed changes"
    echo "     $ git stash pop"
  fi
  exit 0
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
  if [ "$DID_STASH" = true ]; then
    echo "  $((${#STEPS[@]} + 1)). Pop stashed changes"
    echo "     $ git stash pop"
  fi
  exit 1
}

# Execute each step
for i in "${!STEPS[@]}"; do
  echo "Step $((i + 1)): ${STEP_LABELS[$i]}"
  eval "${STEPS[$i]}" || fail "$i"
done

# Restore stashed changes
if [ "$DID_STASH" = true ]; then
  echo "Restoring stashed changes..."
  git stash pop
fi

echo ""
echo "PR created for v${VERSION}. CI will validate and auto-merge."
