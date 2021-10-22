#!/usr/bin/bash

LAY=`herbstclient dump`
ENT=`echo "herbstclient load '$LAY'"` 

FI=`zenity --entry --title="Save the current Layout" --text="Enter name of new Layout:" --entry-text "NewLayout"`

echo "$ENT" > ~/.config/herbstluftwm/layouts/$FI 
