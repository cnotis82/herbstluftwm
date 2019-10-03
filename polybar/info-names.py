#!/usr/bin/python
import sys
import feedparser
from subprocess import call
import re
import textwrap

d = feedparser.parse("http://www.eortologio.gr/rss/si_el.xml")

for f in range(0, 1):
    print(d.entries[f].title[:70])

   


    