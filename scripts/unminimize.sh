
#!/bin/bash

# A script allowing to minimize and un-minimize clients in a LIFO way
# (last minimized client will be un-minimized first).
# 
# `chmod +x unminimize.sh` then call `./unminimize.sh`.


Mod=${Mod:-Mod1}
Minimizekey=Shift-m
Unminimizekey=Ctrl-comma
SCRIPT_PATH="$HOME/.config/herbstluftwm/unminimize.sh"

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}


# 
# initialize minimize and unminimize shortcuts
#
init() {

   # initialize a global minimization counter
   hc silent new_attr uint my_minimized_counter 1

   # minimize current window
   hc keybind $Mod-$Minimizekey spawn $SCRIPT_PATH minimize

   # unminimize last window of a tag
   hc keybind $Mod-$Unminimizekey mktemp string LASTCLIENTATT mktemp uint LASTAGEATT chain \
     . set_attr LASTAGEATT 0 \
     . foreach CLIENT clients. and \
       , sprintf MINATT "%c.minimized" CLIENT \
           compare MINATT "=" "true" \
       , sprintf TAGATT "%c.tag" CLIENT substitute FOCUS "tags.focus.name" \
           compare TAGATT "=" FOCUS \
       , sprintf AGEATT "%c.my_minimized_age" CLIENT and \
         : substitute LASTAGE LASTAGEATT \
             compare AGEATT 'gt' LASTAGE \
         : substitute AGE AGEATT \
             set_attr LASTAGEATT AGE \
       , set_attr LASTCLIENTATT CLIENT \
     . and \
       , compare LASTCLIENTATT "!=" "" \
       , substitute CLIENT LASTCLIENTATT chain \
         : sprintf MINATT "%c.minimized" CLIENT \
             set_attr MINATT false \
         : sprintf AGEATT "%c.my_minimized_age" CLIENT \
             remove_attr AGEATT \

}


# 
# minimize focused client
#
minimize() {

   hc and \
     . substitute C my_minimized_counter new_attr uint clients.focus.my_minimized_age C \
     . set_attr my_minimized_counter $(($(herbstclient substitute C my_minimized_counter echo C)+1)) \
     . set_attr clients.focus.minimized true \

}


if [ "$1" = "minimize" ] ; then minimize ; else init ; fi
  
