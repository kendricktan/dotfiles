#!/bin/bash
sudo apt-get install zsh curl i3 xbindkeys xbacklight git vim vlc fonts-hack-ttf terminology screenfetch scrot feh cmake build-essential python-dev python3-dev vim-python-jedi python3-pip

sudo pip3 install virtualenvwrapper virtualenv

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# i3
mkdir -p ~/.i3/
cp i3/* ~/.i3/

# vim plugins + YouCompleteMe
cp vim/vimrc ~/.vimrc

# bindkeys - volume, brightness etc
cp xbindkeys/xbindkeysrc ~/.xbindkeysrc

# shell
cp zsh/zshrc ~/.zshrc
