URL="$(GET_GITHUB_RELEASE_URL "topjohnwu/Magisk" "Magisk.*.apk")"
FILE="$(basename "$URL")"

LOG_STEP_IN true "Set up magiskboot"

cd "$HOME"
LOG "- Downloading $FILE"
curl -L -s -o "$FILE" "$URL"

LOG "- Extracting libmagiskboot.so"
unzip -q -j "$FILE" "lib/$(GET_ARCH)/libmagiskboot.so"
rm -f "$FILE"

LOG "- Installing magiskboot"
$SUDO mv -f "libmagiskboot.so" "$BINPATH/magiskboot"
$SUDO chmod +x "$BINPATH/magiskboot"

CHECK_EXEC "magiskboot"
LOG_STEP_OUT
