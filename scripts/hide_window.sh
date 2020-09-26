#!/bin/sh
layouts="$HOME/.config/herbstluftwm/layouts"
tag=$(herbstclient attr tags.focus.name)
layout=$(herbstclient dump)

case "$@" in
  hide) herbstclient chain . silent new_attr string clients.focus.my_layout "$layout" \
						   . add "'$tag" . move "'$tag" 
        ;;
  unhide) herbstclient chain . use "'$tag"
          layout=$(herbstclient attr clients.focus.my_layout)
          herbstclient chain . remove_attr clients.focus.my_layout \
          					 . use "$tag" \
          					 . load "$tag" "$layout" \
          					 . and , compare tags.by-name."'$tag".client_count = 0 , merge_tag "'$tag"
          ;;
  use)    herbstclient use "'$tag"
          ;;
  all)    layout=$(herbstclient dump)
		  herbstclient chain . add "*$tag*" . load "*$tag*" "$layout" . load "$tag" "$(<"$layouts/"default"")"
		  ;;
restore)  layout=$(herbstclient dump "*$tag*")
		  herbstclient chain . load "$tag" "$layout" . merge_tag "*$tag*"
		  ;;
esac