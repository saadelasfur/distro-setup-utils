CONFIG_FILE="$HOME/.gitconfig"

LOG_STEP_IN true "Set up gitconfig"

if [[ -f "$CONFIG_FILE" ]]; then
    LOGW "- Existing .gitconfig found, removing..."
    rm -f "$CONFIG_FILE"
fi

LOG "- Applying new git configuration"
git config --global core.editor "nano"
git config --global color.ui "true"
git config --global credential.helper store
LOG_STEP_OUT
