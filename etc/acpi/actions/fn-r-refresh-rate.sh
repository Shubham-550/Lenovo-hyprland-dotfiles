#!/bin/bash

#for apply to fn+r will need to debug this issue: https://github.com/johnfanv2/LenovoLegionLinux/issues/67

#Display variable (Display name, refresh rate, resolution) change depeding of your panel or preference

laptop_screen=eDP-1 #in X this change with your vbios (clevo vbios is DP-4)
resolution=1920x1080

max_hz=165
min_hz=60

#Enviroment Variable (Check DE) #More DE open a Pull Request [not ask for support do it yourself]
HYPRLAND_CHECK=$(env | grep XDG_CURRENT_DESKTOP=Hyprland)
SWAY_CHECK=$(env | grep XDG_CURRENT_DESKTOP=Sway)
KDE_CHECK=$(env | grep XDG_CURRENT_DESKTOP=KDE)
GNOME_CHECK=$(env | grep XDG_CURRENT_DESKTOP=GNOME)
cache_mode=$(cat .cache_mode)

cache_file_write () {
    if [[ $cache_mode = LOW ]]; then
        echo HI > .cache_mode
        hz_set=$max_hz
        kde_val=1
    elif [[ $cache_mode = HI ]]; then
        echo LOW > .cache_mode
        hz_set=$min_hz
        kde_val=0
    else 
        echo HI > .cache_mode
        hz_set=$max_hz
        kde_val=1
    fi
}

#NOTE: ONLY WORKS ON HYBRID eDP-1IN DGPU MODE ONLY GET THE 165Hz

kde_command () {
# command from this issue: https://github.com/johnfanv2/LenovoLegionLinux/issues/67
    kscreen-doctor output.$laptop_screen.mode.$kde_val
}

gnome_command () {
    gnome-monitor-config set -Lp -M $laptop_screen -m $resolution@$hz_set
}

wlroots_command () {
    wlr-randr --output $laptop_screen --mode 1920x1080@${hz_set}Hz
}

x_command () {
    xrandr --output $laptop_screen --rate $hz_set
}
#Write mode to cache file
cache_file_write

#Run command for desktop enviroment
if [ $KDE_CHECK ]; then
    kde_command #need tester
elif [ $GNOME_CHECK ]; then
    gnome_command #need tester
elif [[ $SWAY_CHECK ]] || [[ $HYPRLAND_CHECK ]] ; then
    wlroots_command
else 
    x_command #test in i3
fi
