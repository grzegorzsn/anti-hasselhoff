#!/bin/bash

sudo echo

DEFAULT_PASSWORD="asdf"
DEFAULT_COUNTDOWN=5
KEYLOG=.anti-hasselhoff.log
TIMEOUT=5

password=$1
countdown=$2

if [ -z $password ] ; then
  password=$DEFAULT_PASSWORD
fi

if [ -z $countdown ] ; then
  countdown=$DEFAULT_COUNTDOWN
fi

echo "Running anti-hasselhoff with password " $password " in " $countdown " seconds."

while [ $countdown -gt 0 ] ; do
  echo $countdown "seconds to start!"
  sleep 1
  countdown=$((countdown-1))
done

echo "FIRE!"
sudo logkeys --start --output $KEYLOG --device /dev/input/event16
sudo chmod a+r $KEYLOG

while [ 1 ] ; do
  if [ $(cat $KEYLOG | wc --bytes) -gt 48 ]  # dirty hack to indicate some button was pressed
  then
    echo "INTRUSION"
    xdg-screensaver lock
    sudo logkeys --kill
    fswebcam -r 1024x768 --jpeg 95 -D 1 intruder.jpg
    gsettings set org.gnome.desktop.screensaver picture-uri "file://$PWD/intruder.jpg"
    sleep 1
    for (( i = 0; i < $TIMEOUT; i++ )); do
        xdotool sleep 1 key Ctrl
    done
    sudo rm $KEYLOG
    exit 1
  fi
done
