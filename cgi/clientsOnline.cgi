#!/bin/sh
arp_info=$(/www/cgi-bin/clientsOnline.sh)
printf "Content-Type: application/json\r\n"
printf "\r\n"
echo "$arp_info"
