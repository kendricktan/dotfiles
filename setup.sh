#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y \
    xmonad xmobar xbacklight
    git neovim curl thunar
    vlc termite zsh feh keepass2

# zsh
cp zsh/zshrc $HOME/.zshrc
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# XMonad
mkdir -p $HOME/.xmonad
cp xmonad/xmonad.hs $HOME/.xmonad/xmonad.hs

# XMobar
cp xmonad/.xmobarrc $HOME/.xmobarrc

# z - Jump Around
wget https://raw.githubusercontent.com/rupa/z/master/z.sh -O $HOME/.z.sh
chmod +x $HOME/.z.sh

# Wallpaper
mkdir -p $HOME/Pictures/Background
wget https://i.imgur.com/c6lgoWv.jpg -O $HOME/Pictures/Background/background.jpg
