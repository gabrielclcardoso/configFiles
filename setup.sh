#!/bin/bash

alacritty --version &> /dev/null
[[ $? -ne 0 ]] && echo "Alacritty not installed"
nvim --version &> /dev/null
[[ $? -ne 0 ]] && echo "nvim not installed"
tmux -V &> /dev/null
[[ $? -ne 0 ]] && echo "tmux not installed"

cp -r alacritty $HOME/.config
cp -r nvim $HOME/.config
cp font/* $HOME/.local/share/fonts
cp .bashrc $HOME
cp .tmux.conf $HOME
