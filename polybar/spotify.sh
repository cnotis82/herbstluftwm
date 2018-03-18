#!/bin/bash

#spotifyon=$(ps -e | grep spotify)

#if [ -z "${spotifyon/ //}" ]; then
#	echo " off "
#else
#	artist=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|egrep -A 2 "artist"|egrep -v "artist"|egrep -v "array"|cut -b 27-|cut -d '"' -f 1|egrep -v ^$`
#	title=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|egrep -A 1 "title"|egrep -v "title"|cut -b 44-|cut -d '"' -f 1|egrep -v ^$`
#	echo "" $artist "-" $title
#fi

if [ "$(playerctl status)" = "Playing" ]; then
  title=`exec playerctl metadata xesam:title`
  artist=`exec playerctl metadata xesam:artist`
  echo "𝄞$title - $artist"
else
  echo "off"
fi