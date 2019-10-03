# -*- coding: utf-8 -*-

import os

cmd = "herbstclient layout"
clients_count = "herbstclient attr tags.focus.client_count"
wstr = ""

output = str(os.popen(cmd).read())
index = output.find("%")
if output[4] == "g":
    os.popen("herbstclient set window_gap 5")
    print("[G] ")
elif output[4] == "v":    
    if output[index] == "%":
        count = str(os.popen(clients_count).read())
        print("[T-"+count[0]+"]")

    else:
        #os.popen("herbstclient set window_gap 5")
        print("[V]")
elif output[4] == "h":
    if output[index] == "%":
        count = str(os.popen(clients_count).read())
        print("[T-"+count[0]+"]")

    else:
       #os.popen("herbstclient set window_gap 5")
       print("[H]" )
elif output[4] == "m":
    #os.popen("herbstclient set window_gap 0")
    count = str(os.popen(clients_count).read())
    print("["+count[0]+"]")
