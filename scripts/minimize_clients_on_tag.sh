#!/bin/sh
tag=$(herbstclient attr tags.focus.name)
layout=$(herbstclient dump)
closeallontag=(
    foreach C clients.
        substitute TAG tags.focus.name
        sprintf CTAGATTR '%c.tag' C  # the client's tag attribute
        and . compare CTAGATTR = TAG
            . set_attr clients.focus.minimized true
            . remove
)
case "$@" in
  all)  layout=$(herbstclient dump)
        herbstclient silent new_attr string tags.focus.my_minimize_layout "$layout" 
        herbstclient "${closeallontag[@]}"
        ;;
  restore)  herbstclient substitute LAYOUT tags.focus.my_minimize_layout chain . remove_attr tags.focus.my_minimize_layout . load "$tag" LAYOUT
          ;;
esac
