#!/usr/bin/env python3
def run(*cmd):
    from subprocess import Popen, PIPE
    proc = Popen(cmd, shell=False, stderr=PIPE, stdout=PIPE)
    return proc.stdout.read()

import sys
import binascii
tag_offset, mode = sys.argv[1:]
tag_offset = int(tag_offset)
if mode == 'full':
    ch = {'.', '-'}
elif mode == 'empty':
    ch = {':', '!'}
else:
    raise Exception('Unknown type ' + mode)
tag_list = run('herbstclient', 'tag_status', '0').decode("utf-8").replace(" ", "").strip().split("\t")
tag_curr = int(run('herbstclient', 'attr', 'tags.focus.index').strip())
tag_next = (tag_curr + tag_offset) % len(tag_list)
while (tag_next != tag_curr) and (tag_list[tag_next][0] in ch):
    tag_next = (tag_next + tag_offset) % len(tag_list)
if tag_next != tag_curr:
    run('herbstclient', 'use_index', str(tag_next))