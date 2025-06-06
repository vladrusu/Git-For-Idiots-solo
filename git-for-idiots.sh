#!/bin/bash
# =====================================================================
#  Git-For-Idiots (solo) - The only Git commands you'll ever need.
# =====================================================================

# Internal safety function.
_check_if_git_repo() {
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "❌ Error: This is not a Git project folder."
    echo "💡 To start a new project here, run: create \"my-project-name\""
    echo "💡 To copy an existing project, run: mirror \"<repository-url>\""
    return 1
  fi
  return 0
}

# --- Core Commands ---

# Lists all available commands with explanations.
all() {
    echo "--- Git-For-Idiots (solo) Commands ---"
    echo
    echo "  Basic Commands:"
    echo "    create \"name\"   - Creates a private GitHub project for this folder, saving files as v1."
    echo "    push \"message\"  - Saves current changes to GitHub as a new version (v2, v3, etc.)."
    echo "    rollback v[#]   - Reverts the project to how it was in a previous version."
    echo "    versions        - Shows all saved versions of your project."
    echo
    echo "  Extra Commands:"
    echo "    mirror \"url\"    - Creates your own private copy of any GitHub project."
    echo "    remove-git      - Deletes all version history from this folder (your files are safe)."
    echo "    all             - Shows this list of commands."
}

# Create a new repo and automatically save as v1. (IMPROVED AND MORE ROBUST)
create() {
  if [ -z "$1" ]; then echo "Usage: create \"project-name\""; return 1; fi
  
  # Initialize git locally if it's not already a repo
  if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "Initializing new Git project with a 'main' branch..."; git init -b main
  fi
  
  # Create an initial commit if one doesn't exist
  if ! git rev-parse --verify HEAD > /dev/null 2>&1; then
    echo "No versions found. Creating initial version v1...";
    git add .; git commit --allow-empty -m "release: v1"; git tag -a "v1" -m "release: v1"
  fi

  echo "Creating private GitHub project '$1'..."
  # STEP 1: Create the repo on GitHub but DO NOT push immediately.
  # The --source=. flag automatically sets up the remote URL for you.
  if ! gh repo create "$1" --private --source=. -y; then
      echo "❌ Error: Failed to create repository on GitHub."
      echo "A project with this name might already exist, or there could be an issue with your GitHub CLI authentication."
      return 1
  fi

  echo "Syncing your local project with GitHub..."
  # STEP 2: Push the code in a separate, more reliable step.
  # The '--set-upstream' flag links your local 'main' branch to the remote one for future pushes.
  if git push --set-upstream origin main --tags; then
    # Dynamically get the logged-in user's name for the URL
    GITHUB_USER=$(gh api user -q .login)
    echo "✅ Success! Project '$1' is live on GitHub as v1."
    echo "🔗 URL: https://github.com/$GITHUB_USER/$1"
  else
    echo "❌ Error: The GitHub project was created, but your files could not be uploaded."
    echo "💡 Please check your internet connection and try running: push \"Initial commit\""
  fi
}

# Push changes with an automatic version tag and optional message.
push() {
  _check_if_git_repo || return 1
  git add .
  if git diff --cached --quiet; then
    latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "not versioned yet")
    echo "Repository at $latest_tag. No changes to save. Everything is up to date."
    return 0
  fi
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0")
  new_version=$(( ${latest_tag#v} + 1 )); new_tag="v$new_version"
  COMMIT_MSG=$([ -z "$*" ] && echo "release: $new_tag" || echo "$new_tag: $*")
  echo "Saving and pushing as version $new_tag..."
  git commit -m "$COMMIT_MSG"; git tag -a "$new_tag" -m "$COMMIT_MSG"
  if command git push origin "$CURRENT_BRANCH" --tags; then
    echo "✅ Success! Your new version is: $new_tag"
  else
    echo "❌ Push failed. Check your internet connection."
  fi
}

# Rollback by creating a NEW version.
rollback() {
  _check_if_git_repo || return 1
  if [ -z "$1" ]; then echo "Usage: rollback <version_to_go_back_to> (e.g., rollback v5)"; return 1; fi
  TARGET_TAG="$1"
  if ! git rev-parse --verify "$TARGET_TAG" > /dev/null 2>&1; then
    echo "❌ Error: Version '$TARGET_TAG' does not exist."; return 1
  fi
  ORIGINAL_HEAD=$(git rev-parse HEAD)
  echo "Going back to the state of '$TARGET_TAG'..."
  git reset --hard "$TARGET_TAG" > /dev/null 2>&1
  git reset --soft "$ORIGINAL_HEAD" > /dev/null 2>&1
  latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0")
  new_version=$(( ${latest_tag#v} + 1 )); new_tag="v$new_version"
  COMMIT_MSG="revert: State restored to $TARGET_TAG (as new version $new_tag)"
  echo "Creating new version '$new_tag' to save the reverted state..."
  git commit -m "$COMMIT_MSG"; git tag -a "$new_tag" -m "$COMMIT_MSG"
  if command git push origin main --tags; then
    echo "✅ Rollback complete. Created new version $new_tag reflecting the old state."
  else
    echo "❌ Rollback failed. Check your internet connection."
  fi
}

# Show all available versions (Clean, Formatted & Zsh-Safe).
versions() {
  _check_if_git_repo || return 1
  echo "--- Available Versions (Newest First) ---"
  noglob git for-each-ref --sort=-creatordate --format='%(if)%(HEAD)%(then)*%(else) %(end) %(color:yellow)%-10(refname:short)%(color:reset) | %(color:blue)%(creatordate:iso)%(color:reset) | %(contents:subject)' refs/tags
}

# The SAFE mirror command. Now works for private repos.
mirror() {
  if [ -z "$1" ]; then echo "Usage: mirror <full-repository-url>"; return 1; fi
  SOURCE_URL=$1
  if [[ "$SOURCE_URL" != *"http"* && "$SOURCE_URL" != *"git@"* ]]; then
      echo "❌ Error: '$SOURCE_URL' does not look like a valid repository URL."; return 1
  fi
  NEW_REPO_NAME=$(basename -s .git "$SOURCE_URL")-mirror
  echo "Creating new private project '$NEW_REPO_NAME' on GitHub..."
  if ! gh repo create "$NEW_REPO_NAME" --private -y; then
      echo "❌ Error: Failed to create project on GitHub. It might already exist."; return 1
  fi
  echo "Copying content..."
  if git clone --bare "$SOURCE_URL" "temp-mirror-dir"; then
    cd "temp-mirror-dir"; command git push --mirror "https://github.com/$(gh api user -q .login)/$NEW_REPO_NAME.git"; cd ..
    rm -rf "temp-mirror-dir"
    echo "✅ Success! Copied '$SOURCE_URL' to your new private project '$NEW_REPO_NAME'."
    echo "👉 To start working on it, run: git clone git@github.com:$(gh api user -q .login)/$NEW_REPO_NAME.git"
  else
    echo "❌ Error: Failed to copy from source URL '$SOURCE_URL'. Please check the URL and your permissions."
    gh repo delete "$NEW_REPO_NAME" --yes
    return 1
  fi
}

# Remove all Git information from the current folder.
remove-git() {
    if [ ! -d ".git" ]; then echo "This is not a Git project. Nothing to remove."; return 0; fi
    echo "🚨 WARNING! This will permanently delete all version history from this folder."
    echo -n "Are you sure? (y/n) "
    read REPLY
    if [[ $REPLY =~ ^[Yy]$ ]]; then rm -rf .git; echo "✅ Git version history has been removed."; else echo "Removal cancelled."; fi
}
