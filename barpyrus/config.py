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
conky_text = '%{F\\#ffb86c}  %{F\\#989898}${texeci 3600 /home/notis/.config/polybar/packages.sh} '
conky_text += '%{F\\#ffb86c}  %{F\\#989898}${cpu}% - ${freq_g}Ghz'
conky_text += '%{F\\#ffb86c}  %{F\\#989898}${memperc}% '
conky_text += '%{F\\#ffb86c}  %{F\\#989898}${i8k_right_fan_rpm} '
conky_text += '%{F\\#ffb86c}  %{F\\#989898}${i8k_cpu_temp}°C '
conky_text += '%{F\\#ffb86c}  %{F\\#989898}${exec sensors | grep temp1 | cut -c16-23 | head -n 1 }'
conky_text += '%{F\\#ffb86c}  %{F\\#989898}${wireless_link_qual_perc wlp3s0}% '
conky_text += '%{F\\#ffb86c}  %{F\\#989898}${upspeedf enp2s0}K '
conky_text += '%{F\\#ffb86c}  %{F\\#989898}${downspeedf enp2s0}K '
conky_text += '%{F\\#ffb86c}%{A1:gsimplecal:}  %{A} %{F\\#989898}${fs_used_perc /}% '
conky_text += '%{F\\#ffb86c}  %{F\\#989898}${battery_percent}% '
conky_weather = '%{F\\#ffb86c} %{F\\#989898}${texeci 3600 /home/notis/.config/polybar/weather.sh} '
conky_sys = '%{F\\#ffb86c}  %{F\\#989898}${texeci 3600 /home/notis/.config/polybar/isrunning-openvpn.sh} '
conky_sys += '%{F\\#ffb86c}  %{F\\#989898}${texeci 3600 /home/notis/.config/polybar/isrunning-firewall.sh}'
conky_sys += '%{F\\#ffb86c}  %{F\\#989898}${kernel} '
conky_sys += '%{F\\#ffb86c}  %{F\\#989898}${uptime_short} '

# example options for the hlwm.HLWMLayoutSwitcher widget
xkblayouts = [
    'us us us'.split(' '),
    'gr gr gr'.split(' '),
]
setxkbmap = 'setxkbmap -option compose:menu -option ctrl:nocaps'
#setxkbmap += 'layout us,gr -option grp:ctrl_shift_toggle'
#setxkbmap += ' -option compose:ralt -option compose:rctrl'

# you can define custom themes
grey_frame = Theme(bg = '#32302f', fg = '#ffb86c', padding = (3,3))
orange_frame = Theme(bg = '#ffb86c', fg = '#32302f', padding = (3,3))
pink_frame = Theme(bg = '#ff79c6', fg = '#32302f', padding = (3,3))
purple_frame = Theme(bg = '#bd93f9', fg = '#32302f', padding = (3,3))

# Widget configuration:
bar = lemonbar.Lemonbar(geometry = (x,y,width,height))
bar.widget = W.ListLayout([
    W.RawLabel('%{l}'),
    hlwm.HLWMTags(hc, monitor, tag_renderer = hlwm.underlined_tags),
    hlwm.HLWMMonitorFocusLayout(hc, monitor,
           # this widget is shown on the focused monitor:
           purple_frame(hlwm.HLWMLayout(hc)),
           # this widget is shown on all unfocused monitors:
           purple_frame(hlwm.HLWMLayout(hc))
                                    ),
     W.RawLabel('%{c}'),
     pink_frame(W.DateTime('%d. %B, %H:%M')),
     pink_frame(conky.ConkyWidget(text= conky_weather)),
     #hlwm.HLWMMonitorFocusLayout(hc, monitor,
     #       # this widget is shown on the focused monitor:
     #       pink_frame(hlwm.HLWMWindowTitle(hc)),
     #       # this widget is shown on all unfocused monitors:
     #       pink_frame(hlwm.HLWMWindowTitle(hc))
     #                                ),
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
    
    trayer.TrayerWidget()

])


