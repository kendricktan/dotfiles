#!/bin/bash

xrandr --output eDP-1-1 --off
xrandr --output DP-1-2-3 --auto
xrandr --output DP-1-2-3 --rotate normal
xrandr --output DP-1-2-1 --auto
xrandr --output DP-1-2-1 --rotate left
xrandr --output DP-1-2-1 --right-of DP-1-2-3

feh --bg-center ~/Pictures/Wallpapers/background007.jpg
