#!/usr/bin/env bash
# Stop if a command exits with bad return code
set -e
# Stop if a variable is used that has not been set
set -u

SCRIPT_DIR=$(dirname "$0")
source $SCRIPT_DIR/variables.sh

if command -v rustc &> /dev/null
then
    rustup update
else
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

