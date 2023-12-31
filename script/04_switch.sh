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
	cat <<- EOT
	uci set network.@switch_vlan[-1].ports='${ports}'
	EOT
}

echo '# 04.スイッチ'

# スイッチあり
if [ "$glinet_has_switch" != 0 ]; then

	# VLAN LAN
	if [ -n "$VLAN_LAN_NAME" ]; then
		cat <<- EOT
		# VLAN LAN
		uci set network.@switch_vlan[0].vlan='$VLAN_LAN_VID'
		uci set network.@switch_vlan[0].vid='$VLAN_LAN_VID'
		uci set network.@switch_vlan[0].description='$VLAN_LAN_NAME'
		EOT
		[ -n "$VLAN_LAN_PORTS" ] && convert_ethernet_name_switch_port "${VLAN_LAN_PORTS}"
		echo
	fi

	# VLAN WAN
	if [ -n "$VLAN_WAN_NAME" ]; then
		cat <<- EOT
		# VLAN WAN
		uci set network.@switch_vlan[1].vlan='$VLAN_WAN_VID'
		uci set network.@switch_vlan[1].vid='$VLAN_WAN_VID'
		uci set network.@switch_vlan[1].description='$VLAN_WAN_NAME'
		EOT
		[ -n "$VLAN_WAN_PORTS" ] && convert_ethernet_name_switch_port "${VLAN_WAN_PORTS}"
		echo
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
			convert_ethernet_name_switch_port "${!vlann_ports_name_variable}"
			echo
		fi
	done
fi

# スイッチなし
if [ "$glinet_has_switch" = 0 ]; then
	echo
fi
