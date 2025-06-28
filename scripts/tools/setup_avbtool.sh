URL="$(GET_GITHUB_RELEASE_URL "nmeum/android-tools" "android-tools.*.tar.xz")"
FILE="$(basename "$URL")"

LOG_STEP_IN true "Set up avbtool"

cd "$HOME"
LOG "- Downloading $FILE"
curl -L -s -o "$FILE" "$URL"

LOG "- Extracting avbtool.py"
tar --strip-components=3 -xf "$FILE" "$(tar -tf "$FILE" | grep "avbtool.py")"
rm -f "$FILE"

LOG "- Installing avbtool"
_IS_TERMUX && termux-fix-shebang "avbtool.py"
$SUDO mv -f avbtool.py "$BINPATH/avbtool"
$SUDO chmod +x "$BINPATH/avbtool"

CHECK_EXEC "avbtool"
LOG_STEP_OUT
