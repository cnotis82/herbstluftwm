#!/usr/bin/env bash

closeallontag=(
    foreach C clients.
        substitute TAG tags.focus.name
        sprintf WINIDATTR '%c.winid' C substitute WINID WINIDATTR
        sprintf CTAGATTR '%c.tag' C  # the client's tag attribute
        and . compare CTAGATTR = TAG
            . close WINID
)
hc_rs "${closeallontag[@]}"
