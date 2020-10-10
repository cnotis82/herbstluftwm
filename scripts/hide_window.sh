#!/bin/sh
layouts="$HOME/.config/herbstluftwm/layouts"
tag=$(herbstclient attr tags.focus.name)
layout=$(herbstclient dump)

case "$@" in
  hide) herbstclient chain . silent new_attr string clients.focus.my_layout "$layout" \
                           . silent new_attr string clients.focus.my_prev_tag "$tag" \
						   . add "'$tag" . move "'$tag" 
        ;;
  unhide) herbstclient chain : use "'$tag" \
							 : substitute LAYOUT clients.focus.my_layout chain . remove_attr clients.focus.my_layout \
                                . remove_attr clients.focus.my_prev_tag \
          					 	. use "$tag" \
          					 	. load "$tag" LAYOUT \
          					 	. and , compare tags.by-name."'$tag".client_count = 0 , merge_tag "'$tag"
          ;;
  use)    herbstclient or : and . substitute PREVIOUSTAG clients.focus.my_prev_tag chain , compare clients.focus.tag = "$tag" , use PREVIOUSTAG \
                          : use "'$tag"  
          ;;
  all)    layout=$(herbstclient dump)
		  herbstclient chain . add "*$tag*" . load "*$tag*" "$layout" . load "$tag" "$(<"$layouts/"default"")"
		  ;;
restore)  layout=$(herbstclient dump "*$tag*")
		  herbstclient chain . load "$tag" "$layout" . merge_tag "*$tag*"
		  ;;
esac
