#!/usr/bin/env bash
# Stop if a command exits with bad return code
set -e
# Stop if a variable is used that has not been set
set -u

SCRIPT_DIR=$(dirname "$0")
source $SCRIPT_DIR/variables.sh

$SCRIPT_DIR/rust.sh

mkdir -p $BUILD_DIRECTORY
cd $BUILD_DIRECTORY

if [ -d "alacritty" ]; then
    echo "alacritty already cloned"
else
    git clone https://github.com/alacritty/alacritty.git
fi

LATEST_ALACRITTY_TAG=$(curl -s https://api.github.com/repos/alacritty/alacritty/releases/latest | jq -r .tag_name)
cd alacritty && git fetch --tags --force && git checkout $LATEST_ALACRITTY_TAG

INSTALLED_ALACRITTY_VERSION=$(alacritty --version | awk '{print $2}')
LATEST_ALACRITTY_VERSION=$(echo $LATEST_ALACRITTY_TAG | cut -c 2-)

if command -v alacritty &> /dev/null
then
    if [ "$INSTALLED_ALACRITTY_VERSION" == "$LATEST_ALACRITTY_VERSION" ]
    then
        echo "alacritty is at the latest version"
        exit 0
    else
        make app
        cp -r target/release/osx/Alacritty.app /Applications/
        cp -r target/release/alacritty  /usr/local/bin/  
    fi
else
    make app
    cp -r target/release/osx/Alacritty.app /Applications/
    cp -r target/release/alacritty  /usr/local/bin/  
fi

