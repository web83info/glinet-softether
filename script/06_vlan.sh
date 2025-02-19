# 06.VLAN

echo "# 06.VLAN"

# スイッチあり
if [ "$glinet_has_switch" != 0 ]; then
	for i in $(seq 1 $vlan_max)
	do
		vlann_name=VLAN${i}_NAME
		vlann_vlan=VLAN${i}_VID
		vlann_vid=VLAN${i}_VID

		# TAPデバイス
		vlann_hub_to=VLAN${i}_HUB_TO
		is_vlan=SE_HUB${!vlann_hub_to}_VLANTAG
		tap_port=tap_hub${!vlann_hub_to}
		if [ "${!is_vlan}" != 0 ]; then
			tap_port+=':t'
		fi
		if [ -n "${!vlann_name}" ]; then
			cat <<- EOT
			uci add network bridge-vlan
			uci set network.@bridge-vlan[-1].device='br-vlantap'
			uci set network.@bridge-vlan[-1].vlan='${!vlann_vlan}'
			uci add_list network.@bridge-vlan[-1].ports='${tap_port}'
			uci add_list network.@bridge-vlan[-1].ports='${glinet_switch_name}.${!vlann_vid}'

			EOT
		fi
	done
fi

# スイッチなし
if [ "$glinet_has_switch" = 0 ]; then
	cat <<- EOT
	uci add network bridge-vlan
	uci set network.@bridge-vlan[-1].device='br-vlantap'
	uci set network.@bridge-vlan[-1].vlan='1'
	EOT

	vlan_lan_ports_name_each=($VLAN_LAN_PORTS)
	for each_port in "${vlan_lan_ports_name_each[@]}"; do
		each_port_head4=${each_port::4}
		each_port_variable=glinet_ethernet_${each_port_head4}_name
		each_port_tail2=${each_port: -2}
		each_port_name=${!each_port_variable}
		if [ "$each_port_tail2" = ":t" ]; then
			each_port_name+=':t'
		fi
		if [ -n "${each_port_name}" ]; then
			cat <<- EOT
			uci add_list network.@bridge-vlan[-1].ports='${each_port_name}'
			EOT
		fi
	done;

	echo

	cat <<- EOT
	uci add network bridge-vlan
	uci set network.@bridge-vlan[-1].device='br-vlantap'
	uci set network.@bridge-vlan[-1].vlan='2'

	EOT

	for i in $(seq 1 $vlan_max)
	do
		vlann_name=VLAN${i}_NAME
		vlann_vlan=VLAN${i}_VID
		vlann_ports_name_variable=VLAN${i}_PORTS # VLAN1_PORTS
		vlann_ports_name=${!vlann_ports_name_variable} # "lan1:t lan2 lan3:t" separated by space.
		vlann_ports_name_each=($vlann_ports_name)

		# TAPデバイス
		vlann_hub_to=VLAN${i}_HUB_TO
		is_vlan=SE_HUB${!vlann_hub_to}_VLANTAG
		tap_port=tap_hub${!vlann_hub_to}
		if [ "${!is_vlan}" != 0 ]; then
			tap_port+=':t'
		fi

		# config書き出し
		if [ -n "${!vlann_name}" ]; then
			cat <<- EOT
			uci add network bridge-vlan
			uci set network.@bridge-vlan[-1].device='br-vlantap'
			uci set network.@bridge-vlan[-1].vlan='${!vlann_vlan}'
			uci add_list network.@bridge-vlan[-1].ports='${tap_port}'
			EOT
			for each_port in "${vlann_ports_name_each[@]}"; do
				each_port_head4=${each_port::4}
				each_port_variable=glinet_ethernet_${each_port_head4}_name
				each_port_tail2=${each_port: -2}
				each_port_name=${!each_port_variable}
				if [ "$each_port_tail2" = ":t" ]; then
					each_port_name+=':t'
				fi
				if [ -n "${each_port_name}" ]; then
					cat <<- EOT
					uci add_list network.@bridge-vlan[-1].ports='${each_port_name}'
					EOT
				fi
			done;
			echo
		fi
	done
fi

