#!/bin/sh
layouts="$HOME/.config/herbstluftwm/layouts"
tag=$(hc_rs attr tags.focus.name)
layout=$(hc_rs dump)

case "$@" in
  hide) hc_rs chain . silent new_attr string clients.focus.my_layout "$layout" \
                           . silent new_attr string clients.focus.my_prev_tag "$tag" \
                           . add "'$tag" . move "'$tag"
        ;;
  unhide) hc_rs chain : use "'$tag" \
                             : substitute LAYOUT clients.focus.my_layout chain . remove_attr clients.focus.my_layout \
                               . remove_attr clients.focus.my_prev_tag \
                               . use "$tag" \
                               . load "$tag" LAYOUT \
                               . and , compare tags.by-name."'$tag".client_count = 0 , merge_tag "'$tag"
          ;;
  use)    hc_rs or : and . substitute PREVIOUSTAG clients.focus.my_prev_tag chain , compare clients.focus.tag = "$tag" , use PREVIOUSTAG \
                          : use "'$tag"
          ;;
  all)    layout=$(herbstclient dump)
          hc_rs chain . add "*$tag*" . load "*$tag*" "$layout" . load "$tag" "$(<"$layouts/"default"")"
          ;;
restore)  layout=$(herbstclient dump "*$tag*")
          hc_rs chain . load "$tag" "$layout" . merge_tag "*$tag*"
          ;;
esac
