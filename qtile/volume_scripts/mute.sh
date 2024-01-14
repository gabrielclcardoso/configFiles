#!/bin/bash

sinks=$(pacmd list-sinks | grep -e 'index:' | wc -l)
i=0
while [ $i -lt $sinks ]
do
	pactl set-sink-mute $i toggle
	((i++))
done
