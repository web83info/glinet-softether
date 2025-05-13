# 04.スイッチ

# イーサネット名をスイッチのポート番号に変換する
function convert_ethernet_name_switch_port() {
	ports_name=$1 # "lan1:t lan2 lan3:t" separated by space.
	ports_name_each=($ports_name)

	ports=${glinet_switch_port_cpu}
	ports+="t "
	for each_port in "${ports_name_each[@]}"; do
		each_port_head4=${each_port::4}
		each_port_variable=glinet_switch_port_${each_port_head4}
		each_port_tail2=${each_port: -2}
		each_port_name=${!each_port_variable}
		if [ "$each_port_tail2" = ":t" ]; then
			each_port_name+='t'
		fi
		ports+=${each_port_name}
		ports+=" "
	done;
	# 末尾のスペースを削除
	ports="${ports% }"
	echo "uci set network.@switch_vlan[$2].ports='${ports}'"
}

echo '# 04.スイッチ'

# スイッチあり
if [ "$glinet_has_switch" != 0 ]; then

	# VLAN LAN
	if [ "$VLAN_LAN_NAME" ]; then
		cat <<- EOT
		# VLAN LAN
		uci set network.@switch_vlan[0].vlan='$VLAN_LAN_VID'
		uci set network.@switch_vlan[0].vid='$VLAN_LAN_VID'
		uci set network.@switch_vlan[0].description='$VLAN_LAN_NAME'
		EOT
		if [ -n "$VLAN_LAN_PORTS" ]; then
			convert_ethernet_name_switch_port "${VLAN_LAN_PORTS}" "0"
		fi
		echo
	fi

	if [ "$VLAN_WAN_NAME" ]; then
		cat <<- EOT
		# VLAN WAN
		uci set network.@switch_vlan[1].vlan='$VLAN_WAN_VID'
		uci set network.@switch_vlan[1].vid='$VLAN_WAN_VID'
		uci set network.@switch_vlan[1].description='$VLAN_WAN_NAME'
		EOT
		if [ -n "$VLAN_WAN_PORTS" ]; then
			convert_ethernet_name_switch_port "${VLAN_WAN_PORTS}" "1"
		fi
		echo
	fi

	if [ "$VLAN_WAN_PROTO" = 'static' ]; then
		cat <<- EOT
		uci set network.@switch_vlan[1].proto='$VLAN_WAN_PROTO'
		uci set network.@switch_vlan[1].ipaddr='$VLAN_WAN_IPADDR'
		uci set network.@switch_vlan[1].netmask='$VLAN_WAN_NETMASK'
		uci set network.@switch_vlan[1].gateway='$VLAN_WAN_GATEWAY'
		uci add_list network.@switch_vlan[1].dns='$VLAN_WAN_DNS'

		EOT
	fi

	if [ "$VLAN_WAN_ZONE" ]; then
		if [ "$VLAN_WAN_ZONE" = 'lan' ]; then
			cat <<- EOT
			uci add_list firewall.@zone[0].network='wan'
			uci add_list firewall.@zone[0].network='wan6'
			uci del_list firewall.@zone[1].network='wan'
			uci del_list firewall.@zone[1].network='wan6'

			EOT
		else
			cat <<- EOT
			uci add_list firewall.$VLAN_WAN_ZONE.network='wan'
			uci add_list firewall.$VLAN_WAN_ZONE.network='wan6'

			EOT
		fi
	fi

	# 各VLAN
	for i in $(seq 1 $vlan_max)
	do
		vlann_name=VLAN${i}_NAME
		vlann_vlan=VLAN${i}_VID
		vlann_vid=VLAN${i}_VID
		vlann_ports_name_variable=VLAN${i}_PORTS
		if [ -n "${!vlann_name}" ]; then
			cat <<- EOT
			# VLAN ${!vlann_vid}
			uci add network switch_vlan
			uci set network.@switch_vlan[-1].device='switch0'
			uci set network.@switch_vlan[-1].vlan='${!vlann_vlan}'
			uci set network.@switch_vlan[-1].vid='${!vlann_vid}'
			uci set network.@switch_vlan[-1].description='${!vlann_name}'
			EOT
			convert_ethernet_name_switch_port "${!vlann_ports_name_variable}" "-1"
			echo
		fi
	done
fi

# スイッチなし
if [ "$glinet_has_switch" = 0 ]; then
	# VLAN WAN
	if [ "$VLAN_WAN_DELETE" ] && [ "$VLAN_WAN_DELETE" != 0 ]; then
		cat <<- EOT
		# VLAN WAN 削除
		uci del network.wan
		uci del network.wan6
		uci del firewall.@zone[1].network
		uci del dhcp.wan
		EOT
		echo
	fi

	if [ "$VLAN_WAN_PROTO" = 'static' ]; then
		cat <<- EOT
		uci set network.wan.proto='$VLAN_WAN_PROTO'
		uci set network.wan.ipaddr='$VLAN_WAN_IPADDR'
		uci set network.wan.netmask='$VLAN_WAN_NETMASK'
		uci set network.wan.gateway='$VLAN_WAN_GATEWAY'
		uci add_list network.wan.dns='$VLAN_WAN_DNS'

		EOT
	fi
	echo

	if [ "$VLAN_WAN_ZONE" ]; then
		if [ "$VLAN_WAN_ZONE" = 'lan' ]; then
			cat <<- EOT
			uci add_list firewall.@zone[0].network='wan'
			uci add_list firewall.@zone[0].network='wan6'
			uci del_list firewall.@zone[1].network='wan'
			uci del_list firewall.@zone[1].network='wan6'

			EOT
		else
			cat <<- EOT
			uci add_list firewall.$VLAN_WAN_ZONE.network='wan'
			uci add_list firewall.$VLAN_WAN_ZONE.network='wan6'

			EOT
		fi
	fi
fi
