#!/bin/sh
function swap_to() {
  swap_monitors=$(hc_rs get swap_monitors_to_get_tag)
  hc_rs set swap_monitors_to_get_tag 1
  if [[ $@ = 0 ]]; then
    hc_rs chain . lock . focus_monitor 1 . use $tag0 . focus_monitor 0 . use $tag1 . unlock
  else
    hc_rs chain . lock . focus_monitor 0 . use $tag1 . focus_monitor 1 . use $tag0 . unlock
  fi
  hc_rs set swap_monitors_to_get_tag $swap_monitors
}
 
direction=$@
focus=$(hc_rs list_monitors | grep '\[FOCUS\]' | cut -d: -f1)
tag0=$(hc_rs list_monitors | grep '^0:' | cut -d'"' -f2)
tag1=$(hc_rs list_monitors | grep '^1:' | cut -d'"' -f2)
if [[ $focus = $direction ]]; then
  [[ $focus = 0 ]] && swap_to 0 || swap_to 1
else
  [[ $focus = 0 ]] && swap_to 1 || swap_to 0
fi
