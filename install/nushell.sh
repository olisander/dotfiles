#!/usr/bin/env bash
# Stop if a command exits with bad return code
set -e
# Stop if a variable is used that has not been set
set -u

SCRIPT_DIR=$(dirname "$0")
source $SCRIPT_DIR/variables.sh

$SCRIPT_DIR/rust.sh

LATEST_NU_VERSION=$(curl -s https://api.github.com/repos/nushell/nushell/releases/latest | jq -r .tag_name)
INSTALLED_NU_VERSION=$(nu --version)

if command -v nu &> /dev/null
then
    if [ "$INSTALLED_NU_VERSION" == "$LATEST_NU_VERSION" ]
    then
        echo "nu is at the latest version"
    else
        cargo install nu
    fi
else
    cargo install nu
fi
