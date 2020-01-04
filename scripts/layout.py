# -*- coding: utf-8 -*-

import os

cmd = "herbstclient layout"
clients_count = "herbstclient attr tags.focus.client_count"
clients_wcount = "herbstclient attr tags.focus.curframe_wcount"
maximized = "herbstclient try get_attr tags.focus.my_unmaximized_layout"
wstr = ""

output = str(os.popen(cmd).read())
index = output.find("%")
if output[4] == "g":
    os.popen("herbstclient set window_gap 5")
    print("[G] ")
elif output[4] == "v":    
    if output[index] == "%":
        wcount = str(os.popen(clients_wcount).read())
        print("[T-"+wcount[0]+"]")

    else:
        #os.popen("herbstclient set window_gap 5")
        print("[V]")
elif output[4] == "h":
    if output[index] == "%":
        wcount = str(os.popen(clients_wcount).read())
        print("[T-"+wcount[0]+"]")

    else:
       #os.popen("herbstclient set window_gap 5")
       print("[H]" )
elif output[4] == "m":
    max_ = str(os.popen(maximized).read())
    count = str(os.popen(clients_count).read())
    if max_[0] == "U":
        print("["+count[0]+"]")
    else:
        print("[M-"+count[0]+"]")
