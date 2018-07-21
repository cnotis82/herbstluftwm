# -*- coding: utf-8 -*-

import os

cmd = "herbstclient layout"
wstr = ""

output = str(os.popen(cmd).read())
index = output.find(":")
print(output[0:index])