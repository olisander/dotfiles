#!/usr/bin/env bash
# Stop if a command exits with bad return code
set -e
# Stop if a variable is used that has not been set
set -u

DOTFILES_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

BUILD_DIRECTORY="$HOME/build"
