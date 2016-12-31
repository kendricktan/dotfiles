#!/bin/bash
sudo apt-get install zsh curl i3 xbindkeys xbacklight git vim vlc fonts-hack-ttf terminology screenfetch scrot feh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

cp i3/* ~/.i3/
cp vim/vimrc ~/.vimrc
cp xbindkeys/xbindkeysrc ~/.xbindkeysrc
cp zsh/zshrc ~/.zshrc
