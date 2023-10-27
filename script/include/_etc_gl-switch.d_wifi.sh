#!/bin/sh

action=$1

if [ "$action" = "on" ]; then
	wifi up
    logger -p notice -t wifi-toggle "Wifi up"
fi

if [ "$action" = "off" ]; then
	wifi down
    logger -p notice -t wifi-toggle "Wifi down"
fi

sleep 5
