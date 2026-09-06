#!/bin/bash

# NVIM
DOTFILES_DIR="$HOME/Projects/personal/configFiles"
NVIM_CONF_DIR="$HOME/.config/nvim/lua/config"

mkdir -p "$NVIM_CONF_DIR"

ln -sf "$DOTFILES_DIR/nvim/lua/config/options.lua" "$NVIM_CONF_DIR/options.lua"
ln -sf "$DOTFILES_DIR/nvim/lua/config/keymaps.lua" "$NVIM_CONF_DIR/keymaps.lua"

# BASH
cp .bash_aliases "$HOME/.bash_aliases"
[ -f .bash_secrets ] && cp .bash_secrets "$HOME/.bash_secrets"

HOOK='[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases'
if ! grep -qxF "$HOOK" "$HOME/.bashrc"; then
    echo -e "\n# User aliases hook\n$HOOK" >> "$HOME/.bashrc"
    echo "Added ~/.bash_aliases hook to ~/.bashrc"
else
    echo "Hook already present in ~/.bashrc"
fi
