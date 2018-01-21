#!/bin/bash

PACKAGE_ARCH=$(checkupdates | wc -l)

PACKAGE_AUR=$(cower -u | wc -l)

PACKAGE_TOTAL=$(($PACKAGE_ARCH + $PACKAGE_AUR))

echo "${PACKAGE_TOTAL}"

notify-send "There are ${PACKAGE_ARCH} official updates and ${PACKAGE_AUR} aur updates!"

exit 0
