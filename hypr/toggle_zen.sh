#!/usr/bin/zsh

#####################
#       CONST       #
#####################
NORMAL_IN=12
NORMAL_OUT=16
NORMAL_BORDER=3
NORMAL_OPACITY=0.89

ZEN_IN=8
ZEN_OUT=3
ZEN_BORDER=2
ZEN_OPACITY=1

STATE=$(/usr/bin/hyprctl getoption general:gaps_in | grep int | sed 's/^.*: //') 

if [[ $STATE = $NORMAL_IN ]]; then
  # toggle to zen
  hyprctl --batch "keyword general:gaps_in             $ZEN_IN;"
  hyprctl --batch "keyword general:gaps_out            $ZEN_OUT;"
  hyprctl --batch "keyword general:border_size         $ZEN_BORDER;"
  hyprctl --batch "keyword decoration:active_opacity   $ZEN_OPACITY;"
  hyprctl --batch "keyword decoration:inactive_opacity $ZEN_OPACITY;"
  hyprctl --batch "keyword decoration:blur no;"
  killall -9 waybar
else
  # toggle to normal
  hyprctl --batch "keyword general:gaps_in             $NORMAL_IN;"
  hyprctl --batch "keyword general:gaps_out            $NORMAL_OUT;"
  hyprctl --batch "keyword general:border_size         $NORMAL_BORDER;"
  hyprctl --batch "keyword decoration:active_opacity   $NORMAL_OPACITY;"
  hyprctl --batch "keyword decoration:inactive_opacity $NORMAL_OPACITY;"
  hyprctl --batch "keyword decoration:blur yes;"
  waybar & disown
fi

