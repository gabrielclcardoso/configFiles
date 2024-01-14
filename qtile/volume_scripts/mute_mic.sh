#!/bin/bash

sinks=$(pacmd list-sources | grep -e 'index:' | wc -l)
i=0
while [ $i -lt $sinks ]
do
	pactl set-source-mute $i toggle
	((i++))
done
