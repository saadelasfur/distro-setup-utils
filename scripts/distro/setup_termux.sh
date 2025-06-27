LOG "- Set up termux-specific settings"
LOG_STEP_IN

cd "$HOME"

# Set up storage
if [[ ! -d "storage" ]]; then
    LOG "- Set up storage"
    termux-setup-storage
fi

# Set up bashrc
LOG "- Set up bashrc"
{
    echo "clear"
    echo "cd /sdcard/Download"
} >> "$HOME/.bashrc"
LOG_STEP_OUT
