# 06.VLAN

echo "# 06.VLAN"

# スイッチあり
if [ "$glinet_has_switch" != 0 ]; then
	for i in $(seq 1 $vlan_max)
	do
		vlann_name=VLAN${i}_NAME
		vlann_vlan=VLAN${i}_VID
		vlann_vid=VLAN${i}_VID
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
	uci add_list network.@bridge-vlan[-1].ports='$glinet_ethernet_lan1_name'

	uci add network bridge-vlan
	uci set network.@bridge-vlan[-1].device='br-vlantap'
	uci set network.@bridge-vlan[-1].vlan='2'

	EOT

	for i in $(seq 1 $vlan_max)
	do
		vlann_name=VLAN${i}_NAME
		vlann_vlan=VLAN${i}_VID
		vlann_ports_name_variable=VLAN${i}_PORTS
		vlann_ports_name=${!vlann_ports_name_variable}
		vlann_ports_variable=glinet_ethernet_${vlann_ports_name}_name
		vlann_ports=${!vlann_ports_variable}
		vlann_ports_is_tagged=VLAN${i}_PORTS_IS_TAGGED
		if [  -n "${!vlann_ports_is_tagged}" ] && [ "${!vlann_ports_is_tagged}" != 0 ]; then
			vlann_ports+=':t'
		fi
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
			EOT
			if [ -n "${vlann_ports}" ]; then
				cat <<- EOT
				uci add_list network.@bridge-vlan[-1].ports='${vlann_ports}'
				EOT
			fi
			echo
		fi
	done
fi

