#!/usr/bin/env bash
# Stop if a command exits with bad return code
set -e
# Stop if a variable is used that has not been set
set -u

SCRIPT_DIR=$(dirname "$0")
source $SCRIPT_DIR/variables.sh

mkdir -p $BUILD_DIRECTORY
cd $BUILD_DIRECTORY

if [ -d "alacritty" ]; then
    echo "alacritty already cloned"
else
    git clone https://github.com/alacritty/alacritty.git
fi
cd alacritty
git pull

$SCRIPT_DIR/rust.sh
make app
cp -r target/release/osx/Alacritty.app /Applications/
