#!/bin/bash
sudo apt-get install zsh curl i3 xbindkeys xbacklight git vim vlc fonts-hack-ttf terminology screenfetch scrot feh cmake build-essential python-dev python3-dev vim-python-jedi python3-pip haskell-platform rofi zathura xclip perl rxvt-unicode-256color libpam0g-dev

# zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# i3
mkdir -p ~/.i3/
cp i3/* ~/.i3/

# Xresources
cp Xresources/Xresources ~/.Xresources

# vim settings
cp vim/vimrc ~/.vimrc

# udev rules for trackpoint
sudo cp udev/99_trackpoint.rules /etc/udev/rules.d/99_trackpoint.rules

# shell
cp zsh/zshrc ~/.zshrc
source ~/.zshrc

# Font decrease increase and
# copy + paste for rxvt-unicode
sudo cp ./perl-lib/* /usr/lib/urxvt/perl/

# Haskell
curl -sSL https://get.haskellstack.org/ | sh # Stack
stack update
stack upgrade
stack setup
stack install ghc-mod

# Setup wallpaper
mkdir -p ~/Pictures/Wallpapers
curl -o ~/Pictures/Wallpapers/biscat.jpg http://i.imgur.com/AdBOtzJ.jpg 

# bindkeys - volume, brightness, screenshot etc
mkdir -p ~/Pictures/prtsc
cp xbindkeys/xbindkeysrc ~/.xbindkeysrc

sudo cp scripts/brightness_ctrl.sh /usr/bin/brightness_ctrl.sh
sudo chmod root:root /usr/bin/brightness_ctrl.sh
sudo chmod u+rwx /usr/bin/brightness_ctrl.sh
sudo chmod go-w+rx /usr/bin/brightness_ctrl.sh
sudo echo "=====> Please append below line to your /etc/sudoers for brightness to work"
sudo echo "$USER ALL=(root) NOPASSWD: /usr/bin/brightness_ctrl.sh"

