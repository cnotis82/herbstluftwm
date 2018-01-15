#!/bin/bash

PACKAGE_ARCH=$(checkupdates | wc -l)

#PACKAGE_AUR=$(packer --quickcheck | wc -l)

#PACKAGE_TOTAL=

echo "${PACKAGE_ARCH}"

notify-send "There are ${PACKAGE_ARCH} official updates!"

exit 0
