#!/usr/bin/env bash

# Execute this (e.g. from your autostart) to obtain basic key chaining like it
# is known from other applications like screen.
#
# E.g. you can press Mod1-i 1 (i.e. first press Mod1-i and then press the
# 1-button) to switch to the first workspace
#
# The idea of this implementation is: If one presses the prefix (in this case
# Mod1-i) except the notification, nothing is really executed but new
# keybindings are added to execute the actually commands (like use_index 0) and
# to unbind the second key level (1..9 and 0) of this keychain. (If you would
# not unbind it, use_index 0 always would be executed when pressing the single
# 1-button).

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
Mod=Mod1

# Create the array of keysyms, the n'th entry will be used for the n'th
# keybinding
keys=( h j k l )

# Build the command to unbind the keys
unbind=(  )
for k in "${keys[@]}" Escape ; do
    unbind+=( , keyunbind "$k" )
done

# Add the actual bind, after that, no new processes are spawned when using that
# key chain. (Except the spawn notify-send of course, which can be deactivated
# by only deleting the appropriate line)
resizestep=0.05
hc keybind $Mod-p chain \
    '->' spawn notify-send "Mirror/Rotate frames (h,j,k,l)" \
    '->' keybind "${keys[0]}" mirror \
    '->' keybind "${keys[1]}" mirror vertical \
    '->' keybind "${keys[2]}" mirror both \
    '->' keybind "${keys[3]}" rotate \
    '->' keybind Escape       chain "${unbind[@]}" , spawn notify-send "Mirror/Rotate frame Mode exited"
