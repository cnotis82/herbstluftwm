#!/usr/bin/env bash
ID=$(xdotool getactivewindow)
DIMS=$(xwininfo -id $ID)
HEIGHT=$(echo $DIMS | grep Height |sed 's/.*Height: \([0-9]*\).*/\1/g')
WIDTH=$(echo $DIMS | grep Width |sed 's/.*Width: \([0-9]*\).*/\1/g')

[ $1 = "+x" ] && xdotool windowsize $ID $((WIDTH+32)) $HEIGHT
[ $1 = "-x" ] && xdotool windowsize $ID $((WIDTH-32)) $HEIGHT
[ $1 = "+y" ] && xdotool windowsize $ID $WIDTH $((HEIGHT+32))
[ $1 = "-y" ] && xdotool windowsize $ID $WIDTH $((HEIGHT-32))