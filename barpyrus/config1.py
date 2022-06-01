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
monitor = 0 #if len(sys.argv) >= 2 else 0
(x, y, monitor_w, monitor_h) = hc.monitor_rect(monitor)
height = 20 # height of the panel
width = 1920 # width of the panel
hc(['pad', str(monitor), str(height)]) # get space for the panel

# An example conky-section:
# icons

# first icon: 0 percent
# last icon: 100 percent
#conky_text = '%{F\\#ffb86c} %{F\\#989898}${texeci 600 /home/notis/.config/polybar/gmail/launch.py} '
conky_text = '%{F\\#d79921} ${texeci 3600 /home/notis/.config/polybar/packages.sh} '
conky_text += "%{F\\#d3869b}  ${cpu}% - ${freq_g}Ghz  "
conky_text += '%{F\\#8ec07c} ${memperc}%  '
conky_text += '%{F\\#83a598} ${exec sensors | grep fan1 | cut -c14-23 | head -n 1} '
conky_text += '%{F\\#fabd2f} ${exec sensors | grep temp1 | cut -c16-23 | head -n 1} '
#conky_text += '%{F\\#ebdbb2} ${wireless_link_qual_perc wlp3s0}% '
conky_text += '%{F\\#fb4934}  ${upspeedf wlp3s0}K '
conky_text += '%{F\\#b8bb26}  ${downspeedf wlp3s0}K  '
conky_text += '%{F\\#cc241d} ${texeci 60 /home/notis/.config/polybar/isrunning-openvpn.sh}  '
conky_text += '%{F\\#fb4934} ${texeci 3600 /home/notis/.config/polybar/isrunning-firewall.sh}  '
conky_text += '%{F\\#458588} ${battery_percent}% %{F-} '
conky_weather = '%{F\\#ffb86c} %{F\\#989898}${texeci 3600 /home/notis/.config/polybar/weather.sh} '
conky_sys = '%{F\\#d3869b}%{A:gsimplecal:}  ${fs_used_perc /}% %{A} '
conky_sys += '%{F\\#fabd2f} ${kernel}  '
conky_sys += '%{F\\#458588} ${uptime_short} %{F-} '
#conky_sys += "%{A1:pavucontrol:} Click Here %{A}"

# example options for the hlwm.HLWMLayoutSwitcher widget
xkblayouts = [
    'us us us'.split(' '),
    'gr gr gr'.split(' '),
]

#setxkbmap = 'setxkbmap -option compose:menu -option rctrl:nocaps'
setxkbmap = 'setxkbmap -layout us,gr -option grp:rctrl_rshift_toggle'
#setxkbmap += ' -option compose:ralt -option compose:rctrl > /dev/null'

# you can define custom themes
grey_frame = Theme(bg = '#6272a4', fg = '#32302f', padding = (3,3))
green_frame = Theme(bg = '#458588', fg = '#32302f', padding = (3,3))
orange_frame = Theme(bg = '#d79921', fg = '#32302f', padding = (3,3))
pink_frame = Theme(bg = '#ebdbb2', fg = '#32302f', padding = (3,3))
purple_frame = Theme(bg = '#d5c4a1', fg = '#32302f', padding = (3,3))

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


