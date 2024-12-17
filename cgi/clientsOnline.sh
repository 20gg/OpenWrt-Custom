
#!/bin/sh

# ...... ARP ...
arp_table=$(cat /proc/net/arp)

wifiName=$(iwinfo | grep -A 1 "ESSID" | head -n 1 | awk '{print $1}')

# ............... MAC ......
mac_list=$(iwinfo $wifiName assoclist | sed -n 's/.*\(\([0-9A-F:]\{17\}\)\).*/\1/p')

# ...... JSON ......
json_array="["

# ............ MAC ......
for mac in $mac_list; do
    # ... ARP ..................... IP ........................
    ip=$(echo "$arp_table" | grep -i "$mac" | awk '{print $1}')
    if [ -n "$ip" ]; then
        # 过滤掉IP末尾是100的IP地址
        if [[ $ip != *100 ]]; then
            # ... IP ... MAC ............... JSON ......
            # 检查是否是第一个元素，如果不是，添加逗号分隔符
            if [ -n "${json_array#[}" ]; then
                json_array="$json_array,"
            fi
            json_array="$json_array{\"ip\": \"$ip\", \"mac\": \"$mac\"}"
        fi
    fi
done

# ...... JSON ......
json_array="$json_array]"
echo "$json_array"
