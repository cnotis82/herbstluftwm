from barpyrus import hlwm
from barpyrus import widgets as W
from barpyrus.core import Theme
from barpyrus import lemonbar
from barpyrus import conky
from barpyrus import trayer
import sys
# Copy this config to ~/.config/barpyrus/config.py

# set up a connection to herbstluftwm in order to get events
# and in order to call herbstclient commands
hc = hlwm.connect()

# get the geometry of the monitor
monitor = sys.argv[1] if len(sys.argv) >= 2 else 0
(x, y, monitor_w, monitor_h) = hc.monitor_rect(monitor)
height = 20 # height of the panel
width = 2560 # width of the panel
hc(['pad', str(monitor), str(height)]) # get space for the panel

# An example conky-section:
# icons

# first icon: 0 percent
# last icon: 100 percent
#conky_text = '%{F\\#ffb86c} %{F\\#989898}${texeci 600 /home/notis/.config/polybar/gmail/launch.py} '
conky_text = '%{+u}%{U\\#ffb86c}%{F\\#ffb86c} %{F\\#989898}${texeci 3600 /home/notis/.config/polybar/packages.sh}%{U-}%{-u} '
conky_text += "%{+u}%{U\\#ff79c6}%{F\\#ff79c6}  %{F\\#989898}${cpu}% - ${freq_g}Ghz %{U-}%{-u} "
conky_text += '%{+u}%{U\\#bd93f9}%{F\\#bd93f9} %{F\\#989898}${memperc}% %{U-}%{-u} '
conky_text += '%{+u}%{U\\#8be9fd}%{F\\#8be9fd} %{F\\#989898}${i8k_right_fan_rpm}%{U-}%{-u} '
conky_text += '%{+u}%{U\\#f1fa8c}%{F\\#f1fa8c} %{F\\#989898}${i8k_cpu_temp}°C '
conky_text += '%{F\\#6272a4}  %{F\\#989898}${exec sensors | grep temp1 | cut -c16-23 | head -n 1 } %{U-}%{-u} '
conky_text += '%{+u}%{U\\#6272a4}%{F\\#6272a4} %{F\\#989898}${wireless_link_qual_perc wlp3s0}% '
conky_text += '%{F\\#ff5555}  %{F\\#989898}${upspeedf enp2s0}K '
conky_text += '%{F\\#50fa7b}  %{F\\#989898}${downspeedf enp2s0}K %{U-}%{-u} '
conky_text += '%{+u}%{U\\#ff79c6}%{F\\#ff79c6}%{A:gsimplecal:}  %{F\\#989898}${fs_used_perc /}% %{U-}%{-u}%{A} '
conky_text += '%{+u}%{U\\#50fa7b}%{F\\#50fa7b} %{F\\#989898}${battery_percent}% %{U-}%{-u} '
conky_weather = '%{F\\#ffb86c} %{F\\#989898}${texeci 3600 /home/notis/.config/polybar/weather.sh} '
conky_sys = '%{+u}%{U\\#6272a4}%{F\\#6272a4} %{F\\#989898}${texeci 3600 /home/notis/.config/polybar/isrunning-openvpn.sh} %{U-}%{-u} '
conky_sys += '%{+u}%{U\\#ff5555}%{F\\#ff5555} %{F\\#989898}${texeci 3600 /home/notis/.config/polybar/isrunning-firewall.sh} %{U-}%{-u} '
conky_sys += '%{+u}%{U\\#ffb86c}%{F\\#ffb86c} %{F\\#989898}${kernel} %{U-}%{-u} '
conky_sys += '%{+u}%{U\\#50fa7b}%{F\\#50fa7b} %{F\\#989898}${uptime_short} %{U-}%{-u} '
#conky_sys += "%{A:pavucontrol:} Click Here %{A}"

# example options for the hlwm.HLWMLayoutSwitcher widget
xkblayouts = [
    'us us us'.split(' '),
    'gr gr gr'.split(' '),
]
#setxkbmap = 'setxkbmap -option compose:menu -option rctrl:nocaps'
setxkbmap = 'setxkbmap -layout us,gr -option grp:ctrl_shift_toggle'
#setxkbmap += ' -option compose:ralt -option compose:rctrl'

# you can define custom themes
grey_frame = Theme(bg = '#6272a4', fg = '#32302f', padding = (3,3))
green_frame = Theme(bg = '#50fa7b', fg = '#32302f', padding = (3,3))
orange_frame = Theme(bg = '#d79921', fg = '#32302f', padding = (3,3))
pink_frame = Theme(bg = '#ff79c6', fg = '#32302f', padding = (3,3))
purple_frame = Theme(bg = '#bd93f9', fg = '#32302f', padding = (3,3))

# Widget configuration:
bar = lemonbar.Lemonbar(geometry = (x,y,width,height))
bar.widget = W.ListLayout([
    W.RawLabel('%{l}'),
    hlwm.HLWMTags(hc, monitor, tag_renderer = hlwm.underlined_tags),
    hlwm.HLWMMonitorFocusLayout(hc, monitor,
           # this widget is shown on the focused monitor:
           green_frame(hlwm.HLWMLayout(hc)),
           # this widget is shown on all unfocused monitors:
           green_frame(hlwm.HLWMLayout(hc))),
     #hlwm.HLWMMonitorFocusLayout(hc, monitor,
     #       # this widget is shown on the focused monitor:
     #       grey_frame(hlwm.HLWMWindowTitle(hc)),
     #       # this widget is shown on all unfocused monitors:
     #       grey_frame(hlwm.HLWMWindowTitle(hc))
     #                                ),
     W.RawLabel('%{c}'),
     purple_frame(W.DateTime('%d. %B, %H:%M')),
     pink_frame(conky.ConkyWidget(text= conky_weather)),
         W.RawLabel('%{r}'),

    W.ShortLongLayout(
      W.RawLabel(' '),
      W.ListLayout([
      conky.ConkyWidget(text= conky_text)
      
      ])),
    
    # something like a tabbed widget with the tab labels '>' and '<'
    W.ShortLongLayout(
        W.RawLabel(' '),
        W.StackedLayout([
            hlwm.HLWMLayoutSwitcher(hc, xkblayouts, command = setxkbmap.split(' ')),
            W.RawLabel(' '),
        ])),
    W.ShortLongLayout(
      W.RawLabel(' '),
      W.ListLayout([
      conky.ConkyWidget(text= conky_sys)
      ])),
    
    #trayer.TrayerWidget()

])


