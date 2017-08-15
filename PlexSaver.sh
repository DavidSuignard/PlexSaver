#!/bin/bash 
date
ping -q -c 5 192.168.0.84

plexOnline=$?
activeforbiddenSSID=0
scanSSID=$(sudo iwlist wlan0 scan)

echo -e ¨This is the current list of forbidden networks:¨

while read s; do
 echo $s
 if [[ $scanSSID == *$s* ]]; then
     ((activeforbiddenSSID++))
 fi
done </home/pi/Desktop/Smart_Switch/forbiddenSSID

if (($activeforbiddenSSID > 0)) && [ $plexOnline -eq 0 ]; then
     echo ¨A forbidden network is detected and the Plex is online. Shutdown¨
     ssh root@192.168.0.84 /sbin/poweroff
elif (($activeforbiddenSSID > 0)) && [ $plexOnline -eq 1 ]; then
     echo ¨A forbidden network is detected and the Plex is offline. Do nothing¨
elif (($activeforbiddenSSID == 0)) && [ $plexOnline -eq 0 ]; then
     echo ¨A forbidden network is not detected and the Plex is online. Do nothing¨
elif (($activeforbiddenSSID == 0)) && [ $plexOnline -eq 1 ]; then 
     echo ¨A forbidden network is not detected and the Plex is offline. Turn on ¨
     wakeonlan 1c:1b:0d:99:95:9d
fi