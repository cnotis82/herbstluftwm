#!/bin/sh
tag=$(herbstclient attr tags.focus.name)
layout=$(herbstclient dump)
minimizeallontag=(
    foreach C clients.
        substitute TAG tags.focus.name
        sprintf CTAGATTR '%c.tag' C  # the client's tag attribute
        and . compare CTAGATTR = TAG
            . chain : substitute COUNTER my_minimized_counter new_attr uint clients.focus.my_minimized_age COUNTER
                    : set_attr my_minimized_counter $(($(herbstclient substitute COUNTER my_minimized_counter echo C)+1)) \
            . set_attr clients.focus.minimized true
            . remove
)
restoreallontag=(
    foreach C clients.
        substitute TAG tags.focus.name
        sprintf WINIDATTR '%c.winid' C substitute WINID WINIDATTR
        sprintf CTAGATTR '%c.tag' C  # the client's tag attribute
        sprintf AGEATTR '%c.my_minimized_age' C substitute AGEATT AGEATTR
        and . compare CTAGATTR = TAG
            . jumpto WINID
            . remove_attr AGEATTR
)
case "$@" in
    all) herbstclient "${minimizeallontag[@]}"
        ;;
  restore) herbstclient "${restoreallontag[@]}"
      ;;
esac
