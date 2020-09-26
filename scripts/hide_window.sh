#!/bin/sh
layouts="$HOME/.config/herbstluftwm/layouts"
tag=$(herbstclient attr tags.focus.name)
layout=$(herbstclient dump)
case "$@" in
  hide) herbstclient chain . add "'$tag" . move "'$tag" 
        ;;
  unhide) herbstclient chain . use "'$tag"
          winid=$(herbstclient attr clients.focus.winid)
          herbstclient chain . use "$tag" . bring $winid
        ;;
  use)   herbstclient use "'$tag"
        ;;
  all)  herbstclient chain . add "*$tag*" . load "*$tag*" "$layout" . load "$tag" "$(<"$layouts/"default"")"
		;;
  restore)  layout=$(herbstclient dump "*$tag*")
		herbstclient chain . load "$tag" "$layout" . merge_tag "*$tag*"
		;;
  0|*)  herbstclient load "$tag" "$layout" && herbstclient merge_tag "'$tag" 
;;
esac