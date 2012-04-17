#!/bin/bash

# run stuff context sensitive based on wifi location
# based on http://tech.inhelsinki.nl/locationchanger/ by Onne Gorter 

exec 1>/dev/null 2>/dev/null

sleep 2

# get wifi information
SSID=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I\
 | grep ' SSID:' | cut -d ':' -f 2 | tr -d ' '`
EN0IP=`ifconfig en0 | grep 'inet ' | cut -d' ' -f 2`
EN1IP=`ifconfig en1 | grep 'inet ' | cut -d' ' -f 2`

LOCATION=
 
LOCATIONS=()
SSIDS=()
EN0IPS=()
EN1IPS=()

. HOME_DIR/Library/Application\ Support/osxautovpn/config

for (( i = 0 ; i < ${#LOCATIONS[@]} ; i++ )); do
    if [ "${SSID}" = "${SSIDS[$i]}" ]; then
      REASON=${SSID}
      LOCATION=${LOCATIONS[$i]}
      break
    fi

    if [[ ("${EN0IP}" != "") && ("${EN0IP}" = "${EN0IPS[$i]}") ]]; then
      REASON=${EN0IP}
      LOCATION=${LOCATIONS[$i]}
      break
    fi

    if [[ ("${EN1IP}" != "") && ("${EN1IP}" = "${EN1IPS[$i]}") ]]; then
      REASON=${EN1IP}
      LOCATION=${LOCATIONS[$i]}
      break
    fi
done


if [ -z $LOCATION ]; then
	# still didn't get a location, so we connect to the vpn
	LOCATION="unknown"
        REASON="Can't identify location"
        
        # connect to vpn
		osascript "HOME_DIR/Library/Application\ Support/osxautovpn/connect.scpt"
fi


# write log
echo `date` "Location: $LOCATION - $REASON" >> $HOME/.osxautovpn.log

exit 0
