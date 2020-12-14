#!/bin/sh
tag=$(herbstclient attr tags.focus.name)
layout=$(herbstclient dump)
minimizeallontag=(
    foreach C clients.
        substitute TAG tags.focus.name
        sprintf CTAGATTR '%c.tag' C  # the client's tag attribute
        and . compare CTAGATTR = TAG
            . set_attr clients.focus.minimized true
            . remove
)
restoreallontag=(
    foreach C clients.
        substitute TAG tags.focus.name
        sprintf WINIDATTR '%c.winid' C substitute WINID WINIDATTR
        sprintf CTAGATTR '%c.tag' C  # the client's tag attribute
        and . compare CTAGATTR = TAG
            . jumpto WINID
)
case "$@" in
    all) herbstclient "${minimizeallontag[@]}"
        ;;
  restore) herbstclient "${restoreallontag[@]}"
      ;;
esac
