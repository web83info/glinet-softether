# 04.スイッチ

echo '# 04.スイッチ'

if [ "$GLINET_MODEL" = 'Slate' ] || [ "$GLINET_MODEL" = 'Mango' ]; then

	cat <<- EOT
	# VLAN 1
	uci set network.@switch_vlan[0].vlan='$VLAN1_VID'
	uci set network.@switch_vlan[0].vid='$VLAN1_VID'
	uci set network.@switch_vlan[0].ports='$VLAN1_PORTS'
	uci set network.@switch_vlan[0].description='$VLAN1_NAME'

	# VLAN 2
	uci set network.@switch_vlan[1].vlan='$VLAN2_VID'
	uci set network.@switch_vlan[1].vid='$VLAN2_VID'
	uci set network.@switch_vlan[1].ports='$VLAN2_PORTS'
	uci set network.@switch_vlan[1].description='$VLAN2_NAME'

	EOT

	for i in $(seq 1 $vlan_max)
	do
		j=$((${i}+2))
		vlann_name=VLAN${j}_NAME
		vlann_vlan=VLAN${j}_VID
		vlann_vid=VLAN${j}_VID
		vlann_ports=VLAN${j}_PORTS
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
