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
conky_text = '%{F\\#d79921} %{F\\#989898}${texeci 600 /home/notis/.config/polybar/gmail/launch.py} '
conky_text += '%{F\\#d79921}  %{F\\#989898}${texeci 3600 /home/notis/.config/polybar/packages.sh} '
conky_text += '%{F\\#d79921}  %{F\\#989898}${cpu}% '
conky_text += '%{F\\#d79921}  %{F\\#989898}${memperc}% '
conky_text += '%{F\\#d79921}  %{F\\#989898}${i8k_right_fan_rpm} '
conky_text += '%{F\\#d79921}  %{F\\#989898}${i8k_cpu_temp}°C '
conky_text += '%{F\\#d79921}  %{F\\#989898}${wireless_link_qual_perc wlp3s0}% '
conky_text += '%{F\\#d79921}  %{F\\#989898}${downspeedf wlp3s0}K '
conky_text += '%{F\\#d79921}%{A2:gsimplecal: }  %{A} %{F\\#989898}${fs_used_perc /}% '
conky_text += '%{F\\#d79921}  %{F\\#989898}${battery_percent}% '
conky_weather = '%{F\\#d79921} %{F\\#989898}${texeci 3600 /home/notis/.config/polybar/weather.sh} '
conky_weather += '%{F\\#d79921}  %{F\\#989898}${kernel} '
conky_weather += '%{F\\#d79921}  %{F\\#989898}${uptime_short} '

# example options for the hlwm.HLWMLayoutSwitcher widget
xkblayouts = [
    'us us us'.split(' '),
    'gr gr gr'.split(' '),
]
setxkbmap = 'setxkbmap -option compose:menu -option ctrl:nocaps'
#setxkbmap += 'layout us,gr -option grp:ctrl_shift_toggle'
#setxkbmap += ' -option compose:ralt -option compose:rctrl'

# you can define custom themes
grey_frame = Theme(bg = '#32302f', fg = '#d79921', padding = (3,3))
orange_frame = Theme(bg = '#d79921', fg = '#32302f', padding = (3,3))

# Widget configuration:
bar = lemonbar.Lemonbar(geometry = (x,y,width,height))
bar.widget = W.ListLayout([
    W.RawLabel('%{l}'),
    hlwm.HLWMTags(hc, monitor, tag_renderer = hlwm.underlined_tags),
    hlwm.HLWMMonitorFocusLayout(hc, monitor,
           # this widget is shown on the focused monitor:
           orange_frame(hlwm.HLWMLayout(hc)),
           # this widget is shown on all unfocused monitors:
           orange_frame(hlwm.HLWMLayout(hc))
                                    ),
    W.RawLabel('%{c}'),
    hlwm.HLWMMonitorFocusLayout(hc, monitor,
           # this widget is shown on the focused monitor:
           grey_frame(hlwm.HLWMWindowTitle(hc)),
           # this widget is shown on all unfocused monitors:
           grey_frame(hlwm.HLWMWindowTitle(hc))
                                    ),
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
      W.RawLabel(' '),
      W.ListLayout([
      conky.ConkyWidget(text= conky_weather), 
      orange_frame(W.DateTime('%d. %B, %H:%M'))

      ])),
    
    trayer.TrayerWidget()

])


