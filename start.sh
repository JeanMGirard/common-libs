#!/usr/bin/env bash

# @file .config/scripts/start.sh
# @brief Ensures Task is installed and up-to-date and then runs `task start`
# @description
#   This script will ensure [Task](https://github.com/go-task/task) is up-to-date
#   and then run the `start` task which is generally a good entrypoint for any repository
#   that is using the Megabyte Labs templating/taskfile system. The `start` task will
#   ensure that the latest upstream changes are retrieved, that the project is
#   properly generated with them, and that all the development dependencies are installed.

set -eo pipefail


# @description Ensure .config/log is executable
find ./tools/scripts -maxdepth 2 -type f -iname "*.sh" -exec chmod +x {} \;
find ./bin -maxdepth 0 -type f -exec chmod +x {} \;


# source "$( dirname "${1}" )/tools/scripts/common.sh"

source "$( dirname "${1}" )/tools/scripts/install.sh"




# @description Ensures ~/.local/bin is in PATH
#ensureLocalPath
#
## @description Ensures base dependencies are installed
#if [[ "$OSTYPE" == 'darwin'* ]]; then
#  if ! type curl &> /dev/null && type brew &> /dev/null; then
#    brew install curl
#  else
#    logger error "Neither curl nor brew are installed. Install one of them manually and try again."
#  fi
#  if ! type git &> /dev/null; then
#    # shellcheck disable=SC2016
#    logger info 'Git is not present. A password may be required to run `sudo xcode-select --install`'
#    sudo xcode-select --install
#  fi
#elif [[ "$OSTYPE" == 'linux-gnu'* ]] || [[ "$OSTYPE" == 'linux-musl'* ]]; then
#  if ! type curl &> /dev/null || ! type git &> /dev/null || ! type gzip &> /dev/null; then
#    ensurePackageInstalled "curl"
#    ensurePackageInstalled "file"
#    ensurePackageInstalled "git"
#    ensurePackageInstalled "gzip"
#  fi
#fi
#
## @description Ensures Homebrew, Poetry, jq, and yq are installed
#if [[ "$OSTYPE" == 'darwin'* ]] || [[ "$OSTYPE" == 'linux-gnu'* ]] || [[ "$OSTYPE" == 'linux-musl'* ]]; then
#  if [ -z "$INIT_CWD" ]; then
#    if ! type brew &> /dev/null; then
#      if type sudo &> /dev/null && sudo -n true; then
#        echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#      else
#        logger warn "Homebrew is not installed. The script will attempt to install Homebrew and you might be prompted for your password."
#        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#      fi
#    fi
#    if [ -f "$HOME/.profile" ]; then
#      # shellcheck disable=SC1091
#      . "$HOME/.profile"
#    fi
#    if ! type poetry &> /dev/null; then
#      # shellcheck disable=SC2016
#      brew install poetry || logger info 'There may have been an issue installing `poetry` with `brew`'
#    fi
#    if ! type jq &> /dev/null; then
#      brew install jq
#    fi
#    if ! type yq &> /dev/null; then
#      brew install yq
#    fi
#  fi
#fi
#
## @description Attempts to pull the latest changes if the folder is a git repository
#if [ -d .git ] && [ 0 -gt 1 ] && type git &> /dev/null; then
#  HTTPS_VERSION="$(git remote get-url origin | sed 's/git@gitlab.com:/https:\/\/gitlab.com\//')"
#  git pull "$HTTPS_VERSION" master --ff-only
#  ROOT_DIR="$PWD"
#  if ls .modules/*/ > /dev/null 2>&1; then
#    for SUBMODULE_PATH in .modules/*/; do
#      cd "$SUBMODULE_PATH"
#      DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
#      git reset --hard HEAD
#      git checkout "$DEFAULT_BRANCH"
#      git pull origin "$DEFAULT_BRANCH" --ff-only || true
#    done
#    cd "$ROOT_DIR"
#    # shellcheck disable=SC2016
#    logger success 'Ensured submodules in the `.modules` folder are pointing to the master branch'
#  fi
#fi
#
## @description Ensures Task is installed and properly configured
#ensureTaskInstalled
#
## @description Run the start logic, if appropriate
#if [ -z "$CI" ] && [ -z "$INIT_CWD" ] && [ -f Taskfile.yml ]; then
#  # shellcheck disable=SC1091
#  . "$HOME/.profile"
#  if task donothing &> /dev/null; then
#    task start
#    # shellcheck disable=SC2016
#    logger info 'There may have been changes to your PATH variable. You may have to reload your terminal or run:\n\n`. "$HOME/.profile"`'
#  fi
#fi
