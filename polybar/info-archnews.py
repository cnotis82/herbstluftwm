#!/usr/bin/python
import sys
import feedparser
from subprocess import call
import re
import textwrap

d = feedparser.parse("https://www.naftemporiki.gr/rssFeed")

if sys.argv[1] == "1":
    for f in range(0, 1):
        print(d.entries[f].title[:70])
else:
    print(" ")
   


    