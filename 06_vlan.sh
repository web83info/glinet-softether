# 06.VLAN

echo "# 06.VLAN"

if [ "$GLINET_MODEL" = 'Slate' ] || [ "$GLINET_MODEL" = 'Mango' ]; then
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
			uci set network.@bridge-vlan[-1].device='BR_VLANALL'
			uci set network.@bridge-vlan[-1].vlan='${!vlann_vlan}'
			uci add_list network.@bridge-vlan[-1].ports='eth0.${!vlann_vid}'
			uci add_list network.@bridge-vlan[-1].ports='${tap_port}'

			EOT
		fi
	done
fi

if [ "$GLINET_MODEL" = 'Shadow' ]; then
	cat <<- EOT
		uci add network bridge-vlan
		uci set network.@bridge-vlan[-1].device='br-lan'
		uci set network.@bridge-vlan[-1].vlan='1'
		uci add_list network.@bridge-vlan[-1].ports='eth0'

	EOT
	for i in $(seq 1 $vlan_max)
	do
		vlann_name=VLAN${i}_NAME
		vlann_vlan=VLAN${i}_VID
		vlann_vid=VLAN${i}_VID
		vlann_ports=VLAN${i}_PORTS
		vlann_hub_to=VLAN${i}_HUB_TO
		is_vlan=SE_HUB${!vlann_hub_to}_VLANTAG
		tap_port=tap_hub${!vlann_hub_to}
		if [ "${!is_vlan}" != 0 ]; then
			tap_port+=':t'
		fi
		if [ -n "${!vlann_name}" ]; then
			cat <<- EOT
			uci add network bridge-vlan
			uci set network.@bridge-vlan[-1].device='br-lan'
			uci set network.@bridge-vlan[-1].vlan='${!vlann_vlan}'
			uci add_list network.@bridge-vlan[-1].ports='${tap_port}'
			EOT
			if [ -n "${!vlann_ports}" ]; then
				cat <<- EOT
				uci add_list network.@bridge-vlan[-1].ports='${!vlann_ports}'
				EOT
			fi
			echo
		fi
	done
	cat <<- EOT
		uci del network.@device[0].ports
		uci add_list network.@device[0].ports='eth0'
	EOT
	for i in $(seq 1 $hub_max)
	do
		se_hubn_name=SE_HUB${i}_NAME
		if [ -n "${!se_hubn_name}" ]; then
			cat <<- EOT
			uci add_list network.@device[0].ports='tap_hub${i}'
			EOT
		fi
	done
	echo
	cat <<- EOT
		uci set network.lan.device='br-lan.1'

	EOT
fi
