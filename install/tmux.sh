#!/usr/bin/env bash
# Stop if a command exits with bad return code
set -e
# Stop if a variable is used that has not been set
set -u

SCRIPT_DIR=$(dirname "$0")
source $SCRIPT_DIR/variables.sh

mkdir -p $BUILD_DIRECTORY
cd $BUILD_DIRECTORY

TMUX_VERSION=$(curl -s https://api.github.com/repos/tmux/tmux/releases/latest | jq -r .tag_name)

if command -v tmux &> /dev/null
then
    INSTALLED_TMUX_VERSION=$(tmux -V | cut -c 6-)
    if [ "$INSTALLED_TMUX_VERSION" == "$TMUX_VERSION" ]
    then
        echo "tmux is at the latest version"
    else
        echo "tmux is not at the latest version"
    fi
else
    wget "https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz"
    tar -xvf "tmux-${TMUX_VERSION}.tar.gz"
    rm "tmux-${TMUX_VERSION}.tar.gz"
    cd "tmux-${TMUX_VERSION}"
    # needed brew install pkg-config
    ./configure --enable-utf8proc
    make && sudo make install
fi

