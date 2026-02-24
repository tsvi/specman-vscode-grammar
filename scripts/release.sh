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

# Define release steps (used for both dry-run and error recovery)
STEPS=(
  "git fetch origin main && git checkout -b '$BRANCH' origin/main"
  "npm version '$VERSION' --no-git-tag-version"
  "$SCRIPT_DIR/update-changelog.sh '$VERSION'"
  "git add package.json package-lock.json CHANGELOG.md && git commit -m 'Bump version to $VERSION'"
  "git push -u origin '$BRANCH'"
  "gh pr create --title 'Release v${VERSION}' --body 'Automated version bump to ${VERSION}.' --base main --label 'version-update${PRERELEASE_LABEL}'"
  "git checkout '$ORIGINAL_REF'"
)

STEP_LABELS=(
  "Create branch '$BRANCH' from origin/main"
  "Bump version to $VERSION in package.json"
  "Update CHANGELOG.md with commits since last tag"
  "Commit changes"
  "Push branch '$BRANCH' to origin"
  "Open PR: \"Release v${VERSION}\" with labels: version-update${PRERELEASE_LABEL}"
  "Switch back to original branch '$ORIGINAL_REF'"
)

# Cleanup steps run after the PR is merged
CLEANUP_STEPS=(
  "git branch -D '$BRANCH'"
  "git push origin --delete '$BRANCH'"
)

CLEANUP_LABELS=(
  "Delete local branch '$BRANCH'"
  "Delete remote branch '$BRANCH'"
)

if [ "$DRY_RUN" = true ]; then
  echo ""
  echo "Dry run — the following actions would be performed:"
  step_num=1
  for i in "${!STEP_LABELS[@]}"; do
    echo "  ${step_num}. ${STEP_LABELS[$i]}"
    echo "     $ ${STEPS[$i]}"
    ((step_num++))
  done
  echo "  ${step_num}. Wait for PR to be merged"
  echo "     $ gh pr view '$BRANCH' --json state --jq .state  (poll every 10s)"
  ((step_num++))
  for i in "${!CLEANUP_LABELS[@]}"; do
    echo "  ${step_num}. ${CLEANUP_LABELS[$i]}"
    echo "     $ ${CLEANUP_STEPS[$i]}"
    ((step_num++))
  done
  if [ "$DID_STASH" = false ] && (! git diff --quiet || ! git diff --cached --quiet || [[ -n "$(git ls-files --others --exclude-standard)" ]]); then
    echo "  ${step_num}. Pop stashed changes"
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
  local next=$(( ${#STEPS[@]} + 1 ))
  echo "  ${next}. Wait for PR to be merged, then:"
  for ((i = 0; i < ${#CLEANUP_STEPS[@]}; i++)); do
    echo "  $((next + 1 + i)). ${CLEANUP_LABELS[$i]}"
    echo "     $ ${CLEANUP_STEPS[$i]}"
  done
  if [ "$DID_STASH" = true ]; then
    echo "  $((next + 1 + ${#CLEANUP_STEPS[@]})). Pop stashed changes"
    echo "     $ git stash pop"
  fi
  exit 1
}

# Execute release steps
for i in "${!STEPS[@]}"; do
  echo "Step $((i + 1)): ${STEP_LABELS[$i]}"
  eval "${STEPS[$i]}" || fail "$i"
done

# Restore stashed changes (we're back on the original branch now)
if [ "$DID_STASH" = true ]; then
  echo "Restoring stashed changes..."
  git stash pop
fi

echo ""
echo "PR created for v${VERSION}."
echo "Waiting for PR to be merged..."

# Poll until the PR is merged (or closed without merge)
POLL_INTERVAL=10
while true; do
  PR_STATE=$(gh pr view "$BRANCH" --json state --jq .state 2>/dev/null || echo "UNKNOWN")
  case "$PR_STATE" in
    MERGED)
      echo "PR merged!"
      break
      ;;
    CLOSED)
      echo "PR was closed without merging. Skipping branch cleanup."
      echo "To delete branches manually:"
      for i in "${!CLEANUP_STEPS[@]}"; do
        echo "  $ ${CLEANUP_STEPS[$i]}"
      done
      exit 0
      ;;
    *)
      printf "  PR state: %s — checking again in %ds...\r" "$PR_STATE" "$POLL_INTERVAL"
      sleep "$POLL_INTERVAL"
      ;;
  esac
done

# Cleanup: delete release branch locally and remotely
for i in "${!CLEANUP_STEPS[@]}"; do
  echo "Cleanup: ${CLEANUP_LABELS[$i]}"
  eval "${CLEANUP_STEPS[$i]}" || echo "  Warning: cleanup step failed (non-fatal)"
done

echo ""
echo "Release v${VERSION} complete. Branch '$BRANCH' cleaned up."
