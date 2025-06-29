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
source "$SRC_DIR/scripts/utils/log_utils.sh"
# ]

# https://github.com/salvogiangri/UN1CA/blob/9709f2557a63a27530ca6b2b0e7f9d007233a063/scripts/extract_fw.sh#L118-L124
# ASK_SUDO
# Ensures the script has sudo privileges, prompting the user if necessary.
ASK_SUDO()
{
    if ! sudo -n -v &> /dev/null; then
        LOGW "Asking user for sudo password"
        if ! sudo -v 2> /dev/null; then
            LOGE "Failed to grant root permissions"
            exit 1
        fi
    fi
}

# ASK_USER <prompt>
# Prompts the user for a yes/no response and returns true if the answer is affirmative.
ASK_USER()
{
    local PROMPT="! $1 [y/n] "
    local ANSWER=""

    _SET_INDENT
    read -rp "$PROMPT" ANSWER

    [[ "$ANSWER" =~ ^[Yy]$ ]]
}

# CHECK_EXEC <executable>
# Verifies that a given executable is available in the system PATH.
CHECK_EXEC()
{
    local EXEC="$1"

    LOG_STEP_IN "- Checking for $EXEC installation"

    if ! command -v "$EXEC" &> /dev/null; then
        LOGE "- $EXEC is not installed or not in PATH"
        LOGE "- Installation failed"
        exit 1
    else
        LOG "- $EXEC is installed successfully"
    fi
    LOG_STEP_OUT
}

# GET_GITHUB_RELEASE_URL <repo> <filename>
# Fetches the latest release URL for a specific file from a GitHub repository.
GET_GITHUB_RELEASE_URL()
{
    local REPO="$1"
    local FILENAME="$2"
    local URL

    URL="$(curl -s "https://api.github.com/repos/$REPO/releases/latest" \
        | jq -r ".assets[] | .browser_download_url" \
        | grep "$FILENAME")"

    echo "$URL"
}

# VERIFY_NETWORK
# Checks for an active internet connection; exits if no connection is found.
VERIFY_NETWORK()
{
    if ! ping -c 1 google.com &> /dev/null; then
        LOGE "- No internet connection detected"
        exit 1
    fi
}

# VERIFY_ROOT
# Ensures the script is not run as root; exits with error if it is.
VERIFY_ROOT()
{
    if [[ "$EUID" -eq 0 ]]; then
        LOGE "- This script should not be run as root"
        exit 1
    fi
}
