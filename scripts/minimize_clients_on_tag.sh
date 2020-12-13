#!/usr/bin/env bash

closeallontag=(
    foreach C clients.
        substitute TAG tags.focus.name
        sprintf CTAGATTR '%c.tag' C  # the client's tag attribute
        and . compare CTAGATTR = TAG
            . set_attr clients.focus.minimized true
            . remove
)
herbstclient "${closeallontag[@]}"
