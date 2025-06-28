#!/usr/bin/env bash
#
# Copyright (C) 2025 saadelasfur
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# [
export HOME="$(echo ~)"
# export SRC_DIR="$(pwd)"
# Get SRC_DIR even if the script is not sourced from the root directory
export SRC_DIR="$(git rev-parse --show-toplevel)"
source "$SRC_DIR/scripts/utils/distro_utils.sh"
source "$SRC_DIR/configs/setup.sh"

PREPARE_SETUP()
{
    local OS_TYPE="$(GET_OS)"
    local CONFIGS_DIR="$SRC_DIR/configs/$OS_TYPE"

    if [[ ! -d "$CONFIGS_DIR" ]]; then
        LOGE "Unsupported OS: $OS_TYPE"
        exit 1
    fi

    source "$CONFIGS_DIR/config.sh"
    source "$CONFIGS_DIR/packages.sh"
}
# ]

set -e

VERIFY_ROOT
PREPARE_SETUP
unset -f PREPARE_SETUP

# Setup packages
LOG_STEP_IN true "Updating and installing packages"

[[ -n "$SUDO" ]] && ASK_SUDO
VERIFY_NETWORK
if UPDATE_PACKAGES &> /dev/null; then
    LOG "- Packages updated successfully"
else
    LOGE "- Failed to update packages"
    exit 1
fi

MISSING=()
for p in "${PACKAGES[@]}"; do
    if ! IS_PKG_INSTALLED "$p"; then
        MISSING+=("$p")
    fi
done
for p in "${MISSING[@]}"; do
    LOG "- Installing $p"
    if ! (INSTALL_PKG "$p" && IS_PKG_INSTALLED "$p") &> /dev/null; then
        LOGE "- Failed to install $p"
        exit 1
    fi
done
LOG_STEP_OUT

# Setup distro
if $CUSTOM_SETUP; then
    LOG_STEP_IN true "Set up distro-specific settings"

    if [[ -f "$SRC_DIR/scripts/distro/setup_$(GET_OS).sh" ]]; then
        . "$SRC_DIR/scripts/distro/setup_$(GET_OS).sh"
    else
        LOGW "No distro-specific setup found. Skipping..."
    fi
    LOG_STEP_OUT
fi

# Setup avbtool
if $AVBTOOL; then
    . "$SRC_DIR/scripts/tools/setup_avbtool.sh"
fi

# Setup magiskboot
if $MAGISKBOOT; then
    . "$SRC_DIR/scripts/tools/setup_magiskboot.sh"
fi
