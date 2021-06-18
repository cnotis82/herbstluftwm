#!/usr/bin/bash

LO=`ls -C ~/.config/herbstluftwm/layouts/`

SEL=`zenity --list --title="Choose a Layout" --column="Layouts" $LO`

cat ~/.config/herbstluftwm/layouts/$SEL | bash