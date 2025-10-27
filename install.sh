#!/bin/bash
#
# Installer for "Git-For-Idiots (solo)"
# This script will automatically check dependencies, handle login,
# and configure the shell for the user.

# --- Configuration ---
# This URL now correctly points to YOUR repository.
REPO_URL="https://raw.githubusercontent.com/vladrusu/Git-For-Idiots-solo/main/git-for-idiots.sh"
INSTALL_DIR="$HOME/.git-for-idiots"
SCRIPT_PATH="$INSTALL_DIR/git-for-idiots.sh"

# --- Helper Functions with Colors ---
c_red() { echo -e "\033[0;31m$*\033[0m"; }
c_green() { echo -e "\033[0;32m$*\033[0m"; }
c_yellow() { echo -e "\033[0;33m$*\033[0m"; }
c_bold_yellow() { echo -e "\033[1;33m$*\033[0m"; }

# --- Installation Logic ---

check_dependencies() {
  echo "1. Checking for required tools (git and gh)..."
  if ! command -v git &> /dev/null; then
    c_red "❌ Error: 'git' is not installed."
    c_yellow "💡 Please install Git first. On macOS: 'brew install git'. On Debian/Ubuntu: 'sudo apt install git'."
    exit 1
  fi
  if ! command -v gh &> /dev/null; then
    c_red "❌ Error: GitHub CLI 'gh' is not installed."
    c_yellow "💡 This tool needs the official GitHub command line. On macOS: 'brew install gh'."
    c_yellow "   For other systems, see: https://github.com/cli/cli#installation"
    exit 1
  fi
  c_green "✅ Tools are installed."
}

check_gh_auth() {
  echo "2. Checking if you are logged into GitHub..."
  if ! gh auth status &> /dev/null; then
    c_yellow "⚠️ You are not logged into GitHub."
    echo "I will now open a web browser to log you in. It's easy!"
    echo "When asked, choose 'HTTPS' as your preferred protocol for Git operations."
    if ! gh auth login --web -p https -h github.com; then
      c_red "❌ GitHub login failed. Please run the installer again."
      exit 1
    fi
  fi
  c_green "✅ You are logged into GitHub."
}

download_script() {
  echo "3. Installing the Git-For-Idiots commands..."
  mkdir -p "$INSTALL_DIR"
  if curl -fsSL "$REPO_URL" -o "$SCRIPT_PATH"; then
    chmod +x "$SCRIPT_PATH"
    c_green "✅ Commands installed."
  else
    c_red "❌ Failed to download the script from $REPO_URL"
    c_red "Please check the URL and your internet connection."
    exit 1
  fi
}

update_shell_profile() {
  echo "4. Setting up your terminal..."
  local shell_profile
  if [[ "$SHELL" == *"/zsh" ]]; then
    shell_profile="$HOME/.zshrc"
  elif [[ "$SHELL" == *"/bash" ]]; then
    shell_profile="$HOME/.bashrc"
  else
    c_yellow "⚠️ Could not automatically set up your shell."
    return
  fi

  local source_line="source \"$SCRIPT_PATH\""
  local comment="# Load Git-For-Idiots (solo) commands"
  if ! grep -qF "$source_line" "$shell_profile"; then
    echo -e "\n$comment\n$source_line" >> "$shell_profile"
    c_green "✅ Terminal is configured."
  else
    c_green "✅ Terminal was already configured. All good."
  fi
}

# --- Main Execution ---
main() {
  echo "--- Git-For-Idiots (solo) Installer ---"
  check_dependencies || exit 1
  check_gh_auth || exit 1
  download_script || exit 1
  update_shell_profile

  echo ""
  c_green "🎉 All done! The commands are installed."
  echo ""
  c_bold_yellow "------------------- FINAL STEP -------------------"
  c_bold_yellow "|                                                  |"
  c_bold_yellow "|  Close this terminal window and open a new one.  |"
  c_bold_yellow "|                                                  |"
  c_bold_yellow "|          That's it! You're ready to go.          |"
  c_bold_yellow "----------------------------------------------------"
  echo ""
  c_green "In the new terminal, type 'all' to see your new commands."
  echo ""
}

main
