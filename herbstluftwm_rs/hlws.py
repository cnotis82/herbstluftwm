# -*- coding: utf-8 -*-

import os

cmd = "herbstclient tag_status"
wstr = ""

output = str(os.popen(cmd).read())
index = output.find("")
if index == -1 :
    index = output.find("")

dynIndex = output.find("^")
if index < dynIndex :
    index = dynIndex

i = 0

for i in range(index):
    if output[i] == ":": # occupied
        wstr += "  "
        cstr = '%{F'+ '#555' + '}'+ output[i+2:i+3] + ' %{F-}'
        wstr += cstr
                             
    elif output[i] == "-": # occupied other monitor
        wstr += "  "             
        cstr = '%{F'+ '#55555' + '}' + output[i+2:i+3] + ' %{F-}'
        wstr += cstr
    elif output[i] == ".": # unoccupied
        wstr += "  "
        cstr = '%{F'+ '#555' + '}'+ "" + ' %{F-}'
        wstr += cstr             
    elif output[i] == "#": # current
        wstr += "  "             
        cstr = '%{F'+ '#9fbc00' + '}' + output[i+2:i+3] + ' %{F-}'
        wstr += cstr
        
    elif output[i] == "!": # urgent
        wstr += "  "             
        cstr = '%{F'+ '#e06c75' + '}' + "  " + ' %{F-}'
        wstr += cstr   
print(wstr[1:])
#print(output[0:])