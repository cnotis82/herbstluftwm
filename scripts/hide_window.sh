#!/bin/sh
function tag() {
  herbstclient list_monitors | grep '\[FOCUS\]' | cut -d'"' -f2
}
 
tag=$(tag)
case "$@" in
  +1)   herbstclient dump "'$tag" || herbstclient add "'$tag"
        herbstclient move "'$tag"
        ;;
  -1)   if herbstclient dump "'$tag"; then
          herbstclient chain . lock . use "'$tag"
          winid=$(herbstclient attr clients.focus.winid)
          herbstclient chain . use $tag . bring $winid . unlock
        fi
        ;;
  0|*)  herbstclient dump "'$tag" && herbstclient merge_tag "'$tag" 
;;
esac