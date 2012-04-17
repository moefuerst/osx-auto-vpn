#!/bin/bash

echo "installing osx auto vpn"

if [ ! -e "${HOME}/.osxautovpn" ]; then
  echo "creating ~/.osxautovpn"
  mkdir -p ~/.osxautovpn
  echo "writing ~/.osxautovpn/connect.scpt"
  cp ./connect.scpt ~/.osxautovpn/connect.scpt
  echo "writing ~/.osxautovpn/config"
  cp ./config ~/.osxautovpn/config
fi

if [ ! -e "${HOME}/.osxautovpn/osxautovpn" ]; then
  echo "writing ./osxautovpn.sh"
  sed "s:HOME_DIR:${HOME}:g" < ./autovpn.sh > ./osxautovpn.sh
  echo "making executable ./osxautovpn"
  cat ./osxautovpn.sh > ./osxautovpn
  chmod +x ./osxautovpn
  echo "writing ~/.osxautovpn/osxautovpn"
  mv ./osxautovpn ~/.osxautovpn
  rm ./osxautovpn.sh
fi

if [ ! -e "${HOME}/Library/LaunchAgents" ]; then
  echo "creating ~/Library/LaunchAgents"
  mkdir -p ~/Library/LaunchAgents
fi

echo "writing ~/Library/LaunchAgents/com.mof.autovpn.plist"
sed "s:HOME_DIR:${HOME}:g" < ./com.mof.autovpn.plist > ~/Library/LaunchAgents/com.mof.autovpn.plist

echo -n "osx auto vpn is installed. per default it logs to ~/.osxautovpn.log. do you want to run it now? (y/n)"
read ans
[ $ans == "y" ] && echo "loading ~/Library/LaunchAgents/com.mof.autovpn.plist" && launchctl load ~/Library/LaunchAgents/com.mof.autovpn.plist && sleep 2 && echo "setup finished. osx autovpn is running." || echo "setup finished. osx autovpn will launch on the next reboot"



