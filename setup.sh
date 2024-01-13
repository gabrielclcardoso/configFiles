#!/bin/bash

OS=$(uname)

alacritty --version &> /dev/null
[[ $? -ne 0 ]] && echo "Alacritty not installed"
nvim --version &> /dev/null
[[ $? -ne 0 ]] && echo "nvim not installed"
tmux -V &> /dev/null
[[ $? -ne 0 ]] && echo "tmux not installed"

cp -r alacritty $HOME/.config
cp -r nvim $HOME/.config
cp -r qtile $HOME/.config
if [[ "$OS" == "Linux"	]]
then
	cp font/* $HOME/.local/share/fonts/
else
	cp font/* $HOME/Library/Fonts/
fi
cp .bashrc $HOME
cp .bash_profile $HOME
cp .tmux.conf $HOME
cp -r .tmux $HOME
