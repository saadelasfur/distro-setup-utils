#!/bin/bash

# [
abort()
{
    echo "$@"
    exit 1
}
# ]

git clone https://github.com/saadelasfur/distro-setup-utils.git || abort "Failed to clone repo"
cd distro-setup-utils
bash setup_distro.sh
