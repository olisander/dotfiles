#!/usr/bin/env bash
# Stop if a command exits with bad return code
set -e
# Stop if a variable is used that has not been set
set -u

SCRIPT_DIR=$(dirname "$0")
source $SCRIPT_DIR/variables.sh

$SCRIPT_DIR/rust.sh

NU_VERSION=$(cargo search nu | head -n 1 | sed -n 's/.*"\(.*\)".*/\1/p')

if command -v nu &> /dev/null
then
    INSTALLED_NU_VERSION=$(nu --version)
    if [ "$INSTALLED_NU_VERSION" == "$NU_VERSION" ]
    then
        echo "nu is at the latest version"
    else
        cargo install nu
    fi
else
    cargo install nu
fi
