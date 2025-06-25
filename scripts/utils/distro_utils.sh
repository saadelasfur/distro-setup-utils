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
source "$SRC_DIR/scripts/utils/common_utils.sh"

# _IS_UBUNTU
# Checks if the operating system is Ubuntu.
_IS_UBUNTU()
{
    if grep -qi "Ubuntu" "/etc/os-release" 2> /dev/null; then
        return 0
    else
        return 1
    fi
}
# ]

# GET_ARCH
# Detects the system architecture and returns a standardized ABI string.
GET_ARCH()
{
    case "$(uname -m)" in
        arm64|aarch64)
            echo "arm64-v8a"
            ;;
        armhf|armv7l)
            echo "armeabi-v7a"
            ;;
        i386|i686)
            echo "x86"
            ;;
        amd64|x86_64)
            echo "x86_64"
            ;;
    esac
}

# GET_OS
# Detects the current operating system or environment by checking the kernel and distribution,
# returning a normalized operating system identifier.
GET_OS()
{
    case "$(uname -s)" in
        "Linux"*)
            if _IS_UBUNTU; then
                echo "ubuntu"
            else
                echo "unknown"
            fi
            ;;
        *)
            LOGE "- Unsupported operating system!"
            return 1
            ;;
    esac
}

# GET_PKG_MANAGER
# Returns the default package manager name based on the detected operating system.
GET_PKG_MANAGER()
{
    case "$(GET_OS)" in
        ubuntu)
            echo "apt"
            ;;
    esac
}

# INSTALL_PKG <package>
# Installs the specified package using the appropriate package manager for the detected operating system.
INSTALL_PKG()
{
    local PKG="$1"

    case "$(GET_PKG_MANAGER)" in
        apt)
            sudo apt install -y "$PKG"
            ;;
    esac
}

# IS_PKG_INSTALLED <package>
# Checks if the specified package is installed using the appropriate package manager.
IS_PKG_INSTALLED()
{
    local PKG="$1"

    case "$(GET_PKG_MANAGER)" in
        apt)
            dpkg -s "$PKG" &> /dev/null
            return $?
            ;;
    esac
}

# UPDATE_PACKAGES
# Updates the system packages using the appropriate package manager for the detected operating system.
UPDATE_PACKAGES()
{
    case "$(GET_OS)" in
        ubuntu)
            sudo apt update && sudo apt full-upgrade -y
            ;;
    esac
}
