#!/bin/bash

if dunstctl is-paused | grep -q "false"; then
    dunstctl set-paused true
else
    dunstctl set-paused false
fi
