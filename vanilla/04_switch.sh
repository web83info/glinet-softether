# 04.スイッチ

echo '# 04.スイッチ'

if [ "$glinet_has_switch" != 0 ]; then

	cat <<- EOT
	# VLAN LAN
	uci set network.@switch_vlan[0].vlan='$VLAN_LAN_VID'
	uci set network.@switch_vlan[0].vid='$VLAN_LAN_VID'
	uci set network.@switch_vlan[0].ports='$VLAN_LAN_PORTS'
	uci set network.@switch_vlan[0].description='$VLAN_LAN_NAME'

	# VLAN WAN
	uci set network.@switch_vlan[1].vlan='$VLAN_WAN_VID'
	uci set network.@switch_vlan[1].vid='$VLAN_WAN_VID'
	uci set network.@switch_vlan[1].ports='$VLAN_WAN_PORTS'
	uci set network.@switch_vlan[1].description='$VLAN_WAN_NAME'

	EOT

	for i in $(seq 1 $vlan_max)
	do
		vlann_name=VLAN${i}_NAME
		vlann_vlan=VLAN${i}_VID
		vlann_vid=VLAN${i}_VID
		vlann_ports=VLAN${i}_PORTS
		if [ -n "${!vlann_name}" ]; then
			cat <<- EOT
			# VLAN ${!vlann_vid}
			uci add network switch_vlan
			uci set network.@switch_vlan[-1].device='switch0'
			uci set network.@switch_vlan[-1].vlan='${!vlann_vlan}'
			uci set network.@switch_vlan[-1].vid='${!vlann_vid}'
			uci set network.@switch_vlan[-1].ports='${!vlann_ports}'
			uci set network.@switch_vlan[-1].description='${!vlann_name}'

			EOT
		fi
	done

fi
