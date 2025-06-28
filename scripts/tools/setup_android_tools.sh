URL="$(GET_GITHUB_RELEASE_URL "saadelasfur/build_tools" "unica-tools.*.tar")"
FILE="$(basename "$URL")"
PATH="$(echo -n "$PATH" | tr ":" "\n" | sed "/tools\/bin/d" | paste -sd ":")"
TOOLS_DIR="$HOME/tools"

LOG_STEP_IN true "Set up android tools"

[[ -d "$TOOLS_DIR" ]] && rm -rf "$TOOLS_DIR"
cd "$HOME"
LOG "- Downloading $FILE"
curl -L -s -o "$FILE" "$URL"

LOG "- Extracting tools"
tar -xf "$HOME/$FILE" -C "$HOME"
rm -f "$HOME/$FILE"

if [[ "$(GET_ARCH)" != "x86_64" ]]; then
    LOGW "- Architecture is not \"x86_64\""
    LOGW "- Removing unsupported tools..."

    TOOLS_TO_DELETE=(
        "adb" "append2simg" "avbtool" "e2fsdroid" "samfirm" "venv"
        "ext2simg" "fastboot" "fec" "gki" "mkuserimg_mke2fs.py"
        "img2simg" "lpadd" "lpdump" "lpflash" "lpmake"
        "lpunpack" "make_f2fs" "mkbootfs" "mkbootimg" "mkdtboimg" "mke2fs"
        "mke2fs.android" "mke2fs.conf" "mkf2fsuserimg" "mkuserimg_mke2fs"
        "repack_bootimg" "simg2img" "sload_f2fs" "unpack_bootimg" "zipalign"
        "dump.erofs" "extract.erofs" "fsck.erofs" "fuse.erofs" "mkfs.erofs"
        "blockimgdiff.py" "common.py" "images.py" "img2sdat" "rangelib.py" "sparse_img.py"
    )

    for TOOL in "${TOOLS_TO_DELETE[@]}"; do
        if [[ "$TOOL" == "venv" ]]; then
            rm -rf "$TOOLS_DIR/$TOOL"
        else
            rm -rf "$TOOLS_DIR/bin/$TOOL"
        fi
    done
fi

LOG "- Updating PATH in .bashrc"
sed -i "/PATH/d" "$HOME/.bashrc"
echo "export PATH=$TOOLS_DIR/bin:$PATH" >> "$HOME/.bashrc"
LOG_STEP_OUT
