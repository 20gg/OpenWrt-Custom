

#!/bin/sh

# ...... get_arp_info.sh .....................
arp_info=$(/www/cgi-bin/clientsOnline.sh)
# ...... HTTP ............ JSON
printf "Content-Type: application/json\r\n"
printf "\r\n"

# .................. JSON ......
echo "$arp_info"
