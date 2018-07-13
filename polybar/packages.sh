#!/bin/bash

PACKAGE_SYNC=$(sudo pacman -Syy)
PACKAGE_ARCH=$(sudo pacman -Qu | wc -l)
PACKAGE_AUR=$(cower -u | wc -l)

PACKAGE_TOTAL=$(($PACKAGE_ARCH + $PACKAGE_AUR))

echo "${PACKAGE_TOTAL}"

notify-send "There are ${PACKAGE_ARCH} official updates and ${PACKAGE_AUR} aur updates!"

if [ ${PACKAGE_ARCH} -gt 0 ]; then
	PACKAGE_LIST=$(sudo pacman -Qu)
	notify-send "ARCH packages:" \
	"${PACKAGE_LIST}"
fi
if [ $PACKAGE_AUR -gt 0 ]; then
	PACKAGE_AUR_LIST=$(cower -u)
	notify-send "AUR packages:" \
	"${PACKAGE_AUR_LIST}"
fi
exit 0
