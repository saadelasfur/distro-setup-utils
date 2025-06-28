LOG_STEP_IN true "Set up samfirm"

cd "$HOME"
LOG "- Cloning into \"./samfirm\""
git clone https://github.com/DavidArsene/samfirm.js.git ./samfirm &> /dev/null

cd samfirm
LOG "- Building samfirm"
{
    npm install --silent
    npm run --silent build
} &> /dev/null

LOG "- Installing samfirm"
$SUDO mv -f "dist/index.js" "$BINPATH/samfirm"
$SUDO chmod +x "$BINPATH/samfirm"

cd "$HOME"
rm -rf samfirm

CHECK_EXEC "samfirm"
LOG_STEP_OUT
