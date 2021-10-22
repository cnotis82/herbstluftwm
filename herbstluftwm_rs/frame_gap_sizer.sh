#!/usr/bin/env bash


[ $1 = "+x" ] && hc_rs set frame_gap $(( $(hc_rs attr settings.frame_gap) + 2 ))
[ $1 = "-x" ] && hc_rs set frame_gap $(( $(hc_rs attr settings.frame_gap) - 2 ))
