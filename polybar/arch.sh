#!/bin/bash

kernel=$(uname -r)

echo "${kernel}" | cut -d'-' -f1-1
