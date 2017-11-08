 #!/bin/bash

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}
monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi
# geometry has the format W H X Y
x=${geometry[0]}
y=${geometry[1]}
panel_width=${geometry[2]}
panel_height=16
_font="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"
#font="-*-WenQuanYi Bitmap Song-medium-*-*-*-12-*-*-*-*-*-*-*"
font="-*-terminesspowerline-medium-*-normal-*-12-*-*-*-*-*-*-*"
font2="-misc-fontawesome-medium-r-normal--0-0-0-12-p-0-iso10646-1"
bgcolor=$(hc get frame_border_normal_color)
selbg=$(hc get window_border_active_color)
selfg='#101010'
MPD="/home/notis/.config/herbstluftwm/mpd.xbm"
PACMAN="/home/notis/.config/herbstluftwm/pacman.xbm"
WIFI="/home/notis/.config/herbstluftwm/wifi.xbm"
CLOCK="/home/notis/.config/herbstluftwm/clock.xbm"
MEM="/home/notis/.config/herbstluftwm/mem.xbm"
VOL="/home/notis/.config/herbstluftwm/vol.xbm"
BAT="/home/notis/.config/herbstluftwm/bat.xbm"
KER="/home/notis/.config/herbstluftwm/kernel.xbm"
FAN="/home/notis/.config/herbstluftwm/fan.xbm"
TEMP="/home/notis/.config/herbstluftwm/temp.xbm"
WEATHER="/home/notis/.config/herbstluftwm/weather.xbm"
####
# Try to find textwidth binary.
# In e.g. Ubuntu, this is named dzen2-textwidth.
if which textwidth &> /dev/null ; then
    textwidth="textwidth";
elif which dzen2-textwidth &> /dev/null ; then
    textwidth="dzen2-textwidth";
else
    echo "This script requires the textwidth tool of the dzen2 project."
    exit 1
fi
####
# true if we are using the svn version of dzen2
# depending on version/distribution, this seems to have version strings like
# "dzen-" or "dzen-x.x.x-svn"
if dzen2 -v 2>&1 | head -n 1 | grep -q '^dzen-\([^,]*-svn\|\),'; then
    dzen2_svn="true"
else
    dzen2_svn=""
fi

if awk -Wv 2>/dev/null | head -1 | grep -q '^mawk'; then
    # mawk needs "-W interactive" to line-buffer stdout correctly
    # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=593504
    uniq_linebuffered() {
      awk -W interactive '$0 != l { print ; l=$0 ; fflush(); }' "$@"
    }
else
    # other awk versions (e.g. gawk) issue a warning with "-W interactive", so
    # we don't want to use it there.
    uniq_linebuffered() {
      awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
    }
fi

KERNEL=$(uname -r)

hc pad $monitor $panel_height

{
    ### Event generator ###
    # based on different input data (mpc, date, hlwm hooks, ...) this generates events, formed like this:
    #   <eventname>\t<data> [...]
    # e.g.
    #   date    ^fg(#efefef)18:33^fg(#909090), 2013-10-^fg(#efefef)29

    #mpc idleloop player &
    while true ; do
        # "date" output is checked once a second, but an event is only
        # generated if the output changed compared to the previous run.
        #date +$'date\t^fg(#efefef)%H:%M^fg(#909090), %Y-%m-^fg(#efefef)%d'
	date +$'update\t^fg(#efefef)%H^fg(#909090), %Y-%m-^fg(#efefef)%d'
	sleep 60 || break
    done > >(uniq_linebuffered) &
    
    while true ; do
        # "date" output is checked once a second, but an event is only
        # generated if the output changed compared to the previous run.
        date +$'date\t^fg(#efefef)%H:%M^fg(#909090), %Y-%m-^fg(#efefef)%d'
	sleep 1 || break
    done > >(uniq_linebuffered) &
    childpid=$!
    hc --idle
    kill $childpid
} 2> /dev/null | {
    IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
    visible=true
    date=""
    windowtitle=""
    while true ; do

        ### Output ###
        # This part prints dzen data based on the _previous_ data handling run,
        # and then waits for the next event to happen.

        bordercolor="#26221C"
        separator="^bg()^fg($selbg)|"
        # draw tags
        for i in "${tags[@]}" ; do
            case ${i:0:1} in
                '#')
                    echo -n "^bg($selbg)^fg($selfg)"
                    ;;
                '+')
                    echo -n "^bg(#9CA668)^fg(#141414)"
                    ;;
                ':')
                    echo -n "^bg()^fg(#ffffff)"
                    ;;
                '!')
                    echo -n "^bg(#FF0675)^fg(#141414)"
                    ;;
                *)
                    echo -n "^bg()^fg(#ababab)"
                    ;;
            esac
             # If tag is not empty, show it.
            
            if [ ! -z "$dzen2_svn" ] ; then
                if [[ "${i:0:1}" != '.' ]]; then
                    # clickable tags if using SVN dzen
                    echo -n "^ca(1,\"${herbstclient_command[@]:-herbstclient}\" "
                    echo -n "focus_monitor \"$monitor\" && "
                    echo -n "\"${herbstclient_command[@]:-herbstclient}\" "
                    #echo -n "use \"${i:1}\") ${i:1} ^ca()"
		    echo -n "use \"${i:1}\") ^fn(FontAwesome:size=9)${i:1}^fn() ^ca()"
                fi
            else
                # non-clickable tags if using older dzen
                echo -n " ${i:1} "
            fi
            
        done
        echo -n "$separator"
        echo -n "^bg()^fg() ${windowtitle//^/^^}"
        #echo -n "$separator" 
	#small adjustments
	#cpu_idle=$(mpstat | grep "all" | cut -c 92-)
	cpu_load=$(ps aux | awk {'sum+=$3;print sum/4'} | tail -n 1)
	mem_total=$(free | awk 'FNR == 2 {print $2}')
	mem_used=$(free | awk 'FNR == 2 {print $3}')
	mem_value=$[$mem_used * 100 / $mem_total]
	
	wifi=$(grep wlp6s0 /proc/net/wireless | awk '{ print int($3 * 100 / 70) }')
       	bat=`cat /sys/class/power_supply/BAT0/capacity`
        #batstat=`cat /sys/class/power_supply/BAT1/status`
        #if (($batstat=='Charging'))
        #then
         #   batico="^i(/usr/share/icons/stlarch_icons/ac10.xbm)"
        #else
         #   batico="^i(/usr/share/icons/stlarch_icons/batt5full.xbm)"
        #fi
        #bat="^fg($xicon)$batico ^fg($xtitle)bat ^fg($xfg)$bat^fg($xext)%"
	#Vol
	vol=$(amixer -c 0 get Master | tail -n 1 | cut -d '[' -f 2 | sed 's/%.*//g' | sed -n 1p)
	mpc_current=$(mpc current)
	#echo -n "Uptime: $uptime_val"
        right=""
        
        right="$separator^fg(#FFF000)^i($MPD)^fg(#efefef)$mpc_current $separator^fg(#00FFFF) ^i($KER)^fg(#efefef) $KERNEL $separator^fg(#FF0000) ^i($FAN) ^fg(#efefef)$cpu_load% $separator^fg(#FF0000) ^i($TEMP) ^fg(#efefef)$cpu_temp C $separator^fg(#0000FF) ^i($FAN) ^fg(#efefef)$cpu_fan $separator^fg(#00FF00) ^i($MEM) ^fg(#efefef)$mem_value% $separator^fg(#800080) ^i($PACMAN) ^fg(#efefef)$packages $separator^fg(#FFA500) ^i($WIFI)^fg(#efefef) $wifi% $separator^fg(#00FFFF) ^i($WEATHER) ^fg(#efefef)$WEATHER_TEMP C $separator^fg(#ADD8E6) ^i($VOL) ^fg(#efefef)$vol% $separator^fg(#800000) ^i($BAT)^fg(#efefef) $bat% $separator^bg() $date $separator"
        right_text_only=$(echo -n "$right" | sed 's.\^[^(]*([^)]*)..g')
        # get width of right aligned text.. and add some space..
        width=$($textwidth "$_font" "$right_text_only    ")
        echo -n "^pa($(($panel_width - $width-85)))$right"
        echo

        ### Data handling ###
        # This part handles the events generated in the event loop, and sets
        # internal variables based on them. The event and its arguments are
        # read into the array cmd, then action is taken depending on the event
        # name.
        # "Special" events (quit_panel/togglehidepanel/reload) are also handled
        # here.

        # wait for next event
        IFS=$'\t' read -ra cmd || break
        # find out event origin
        case "${cmd[0]}" in
            tag*)
                #echo "resetting tags" >&2
                IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
                ;;
            date)
                #echo "resetting date" >&2
                date="${cmd[@]:1}"
		cpu_temp=$(sensors | grep "CPU" | cut -b 18-19)
		cpu_fan=$(sensors | grep "fan2" | cut -b 16-19)
		

                ;;
	   update)
		update="${cmd[@]:1}"
		WEATHER_URL="http://api.openweathermap.org/data/2.5/weather?id=264371&appid=f35dbde3a568267aa14b89a30f45a290&units=metric"
		WEATHER_INFO=$(wget -qO- "${WEATHER_URL}")
		#WEATHER_MAIN=$(echo "${WEATHER_INFO}" | grep -o -e '\"main\":\"[a-Z]*\"' | awk -F ':' '{print $2}' | tr -d '"')
		WEATHER_TEMP=$(echo "${WEATHER_INFO}" | grep -o -e '\"temp\":\-\?[0-9]*' | awk -F ':' '{print $2}' | tr -d '"')
		packages=$(checkupdates | wc -l)
		;;
            quit_panel)
                exit
                ;;
            togglehidepanel)
                currentmonidx=$(hc list_monitors | sed -n '/\[FOCUS\]$/s/:.*//p')
                if [ "${cmd[1]}" -ne "$monitor" ] ; then
                    continue
                fi
                if [ "${cmd[1]}" = "current" ] && [ "$currentmonidx" -ne "$monitor" ] ; then
                    continue
                fi
                echo "^togglehide()"
                if $visible ; then
                    visible=false
                    hc pad $monitor 0
                else
                    visible=true
                    hc pad $monitor $panel_height
                fi
                ;;
            reload)
                exit
                ;;
            focus_changed|window_title_changed)
                windowtitle="${cmd[@]:2}"
                
                ;;
            #player)
             #   ;;
        esac
    done

    ### dzen2 ###
    # After the data is gathered and processed, the output of the previous block
    # gets piped to dzen2.

} 2> /dev/null | dzen2 -w $panel_width -x $x -y $y -fn "$font" -h $panel_height \
    -e 'button3=' \
    -ta l -bg "$bgcolor" -fg '#efefef'

#sleep 2
#stalonetray

