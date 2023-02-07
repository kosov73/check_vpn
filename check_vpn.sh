#!/bin/bash
PATH=/bin:/bin/bash:/usr/bin:/sbin:/usr/sbin
lic=8.8.8.8
IP=("8.8.8.8" "8.8.9.9" "8.8.8.0/24")
result=$(ping -c 2 -W 1 -q $lic | grep transmitted)
pattern="0 received";
  if [[ $result =~ $pattern ]]; then
    date +%d-%m-%y/%H:%M:%S && echo "$lic is down" &&  echo "-----------------------------"
    killall pppd
    sleep 10
    /sbin/pppd call vpn
    sleep 20
    GW=$(ip a | grep ppp | grep peer | awk '{ print $2}')
    for g in ${IP[@]}; do
      pr=`echo "$g" | grep '0/24'`
      if [ -z "$pr" ]; then
        route add -host $g  gw $GW
      else
        route add -net $g  gw $GW
      fi
    done
  else
      date +%d-%m-%y/%H:%M:%S && echo -e "$lic is up\n-----------------------------"
  fi;
