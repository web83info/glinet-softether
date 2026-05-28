# 07.VLAN

echo "# 07.VLAN"

# ポート処理の共通関数
output_uci_bridge_vlan_ports() {
	local ports_list="$1"
	for each_port in $ports_list; do
		each_port_head=${each_port%??}
		each_port_tail2=${each_port: -2}
		if [ "$each_port_tail2" = ":t" ]; then
			each_port_variable=glinet_ethernet_${each_port_head}_name
			each_port_name=${!each_port_variable}
			each_port_name+=':t'
		else
			each_port_variable=glinet_ethernet_${each_port}_name
			each_port_name=${!each_port_variable}
		fi
		if [ -n "${each_port_name}" ]; then
			echo "uci add_list network.@bridge-vlan[-1].ports='${each_port_name}'"
		fi
	done
}

# スイッチあり
if [ "$glinet_has_switch" != 0 ]; then

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
			EOT

			if [ -n "${!vlann_hub_to}" ]; then
				echo "uci add_list network.@bridge-vlan[-1].ports='${tap_port}'"
			fi

			cat <<- EOT
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

	# 関数呼び出し
	output_uci_bridge_vlan_ports "$VLAN_LAN_PORTS"

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
		vlann_device=VLAN${i}_DEVICE

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
			EOT

			if [ -n "${!vlann_device}" ]; then
				cat <<- EOT
				uci set network.@bridge-vlan[-1].device='${!vlann_device}'
				EOT
			else
				cat <<- EOT
				uci set network.@bridge-vlan[-1].device='br-vlantap'
				EOT
			fi

			cat <<- EOT
			uci set network.@bridge-vlan[-1].vlan='${!vlann_vlan}'
			EOT

			if [ -n "${!vlann_hub_to}" ]; then
				echo "uci add_list network.@bridge-vlan[-1].ports='${tap_port}'"
			fi

			# 関数呼び出し
			output_uci_bridge_vlan_ports "$vlann_ports_name"
			echo
		fi
	done
fi