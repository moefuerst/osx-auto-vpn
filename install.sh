#!/bin/bash

echo "installing osx auto vpn"

if [ ! -e "${HOME}/Library/Application\ Support/osxautovpn" ]; then
  echo "creating ~/Library/Application Support/osxautovpn"
  mkdir -p ~/Library/Application\ Support/osxautovpn
  echo "writing ~/Library/Application Support/osxautovpn/connect.scpt"
  cp ./connect.scpt ~/Library/Application\ Support/osxautovpn/connect.scpt
  echo "writing ~/Library/Application Support/osxautovpn/config"
  cp ./config ~/Library/Application\ Support/osxautovpn/config
fi

if [ ! -e "${HOME}/bin/osxautovpn" ]; then
  echo "writing ~/bin/osxautovpn.sh"
  sed "s:HOME_DIR:${HOME}:g" < ./osxautovpn.sh > ~/bin/osxautovpn.sh
  echo "making executable ~/bin/osxautovpn"
  cat ~/bin/osxautovpn.sh > ~/bin/osxautovpn
  chmod +x ~/bin/osxautovpn
  rm ~/bin/osxautovpn.sh
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



