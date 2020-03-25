#!/usr/bin/env bash

frequency=${10:-1}
colors="f92672 fd971f f4bf75 a6e22e a1efe4 ae81ff cc6633 f92672 fd971f f4bf75 a6e22e a1efe4 
ae81ff cc6633"
orig="$(herbstclient get_attr theme.active.color)"

function bling() {
    for i in $colors; do
        herbstclient attr theme.active.color "#$i"
        sleep $frequency
    done

    herbstclient attr theme.active.color $orig
}
bling
