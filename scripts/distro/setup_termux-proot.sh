TERMUX_HOME="/data/data/com.termux/files/home"

LOG "- Set up proot-specific settings"
LOG_STEP_IN

# Set up bashrc
LOG "- Set up bashrc"
rm -f "$TERMUX_HOME/.bashrc"
{
    echo "clear"
    echo "./${FS}.sh"
} >> "$TERMUX_HOME/.bashrc"

# Add user
LOG "- Adding user \"${USER}\""
adduser ${USER}
sed -i "/root\tALL=(ALL:ALL) ALL/a ${USER}\tALL=(ALL:ALL) ALL" "$TERMUX_HOME/${FS}-fs/etc/sudoers"
echo "su - ${USER}" >> "$TERMUX_HOME/${FS}-fs/root/.bashrc"
LOG_STEP_OUT
