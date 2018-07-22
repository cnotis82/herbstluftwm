# -*- coding: utf-8 -*-

import os

cmd = "herbstclient layout"
wstr = ""

output = str(os.popen(cmd).read())
index = output.find("%")
if output[4] == "g":
    print(" ")
elif output[4] == "v":    
    if output[index] == "%":
        print(" " + output[index-2:index+1])
    else:
        print(" ")
elif output[4] == "h":
    if output[index] == "%":
        print(" "  + output[index-2:index+1])
    else:
       print(" " )
elif output[4] == "m":
    print(" ")