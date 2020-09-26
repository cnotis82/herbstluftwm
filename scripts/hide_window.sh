#!/bin/sh

tag=$(herbstclient attr tags.focus.name)
case "$@" in
  +1)   herbstclient dump "'$tag" || herbstclient add "'$tag"
        herbstclient move "'$tag"
        ;;
  -1)   if herbstclient dump "'$tag"; then
          #herbstclient lock
          herbstclient chain . use "'$tag"
          winid=$(herbstclient attr clients.focus.winid)
          herbstclient chain . use "$tag" . bring $winid
          #herbstclient unlock
        fi
        ;;
  -2)   if herbstclient dump "'$tag"; then
          #herbstclient lock
          herbstclient use "'$tag"
        fi
        ;;
  0|*)  herbstclient dump "'$tag" && herbstclient merge_tag "'$tag" 
;;
esac