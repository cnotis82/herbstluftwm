sinid=$(wmctrl -l | rofi -modi run,drun,window -show-icons -lines 10 -padding 20 -width 50 -show window -sidebar-mode -columns 3 -font "Fantasque Sans Mono 10" -dmenu -i -p "bring" | cut -d" " -f1) && hc_rs bring "$winid"
