#!/usr/bin/env bash
# Stop if a command exits with bad return code
set -e
# Stop if a variable is used that has not been set
set -u

SCRIPT_DIR=$(dirname "$0")
source $SCRIPT_DIR/variables.sh

mkdir -p $BUILD_DIRECTORY
cd $BUILD_DIRECTORY

if [ -d "neovim" ]; then
    echo "neovim already cloned"
else
    git clone https://github.com/neovim/neovim
fi

cd neovim && git fetch --tags --force && git checkout stable && make CMAKE_BUILD_TYPE=RelWithDebInfo && sudo make install 
