#!/bin/bash

sinks=$(pacmd list-sinks | grep -e 'index:' | wc -l)
i=0
while [ $i -lt $sinks ]
do
	pactl set-sink-volume $i -5%
	((i++))
done
