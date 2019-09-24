#!/bin/bash


DEFAULT_PASSWORD="asdf"
DEFAULT_COUNTDOWN=5
KEYLOG=.anti-hasselhoff.log
TIMEOUT=5

sudo rm $KEYLOG || true

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

events=`ls -l /dev/input/by-path/ | grep kbd | grep -o -e "event[0-9][0-9]*"`
for event in $events ; do
 sudo evtest /dev/input/$event >> $KEYLOG &
done
sudo chmod a+r $KEYLOG
sleep 0.1

starting_log_len=`wc -l $KEYLOG | cut -d " " -f 1`

while [ 1 ] ; do
  sleep 1
  current_log_len=`wc -l $KEYLOG | cut -d " " -f 1`
  if [ $starting_log_len != $current_log_len ]  # dirty hack to indicate some button was pressed
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
    sudo kill $(jobs -p)
    exit 1
  fi
done
