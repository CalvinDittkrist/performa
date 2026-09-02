# Read by EVERY zsh instance, before .zprofile and .zshrc.
#
# Why this file exists:
# On macOS lazygit looks for its config in "~/Library/Application Support/lazygit"
# by default. It only checks ~/.config/lazygit when XDG_CONFIG_HOME is set.
#
# $HOME/.config is the standard value for that variable anyway, so nothing changes
# for any other program - it just makes lazygit find its config.
#
# Verify with:  lazygit --print-config-dir
export XDG_CONFIG_HOME="$HOME/.config"
