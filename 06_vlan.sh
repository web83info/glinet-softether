# 06.VLAN

echo "# 06.VLAN"

if [ "$GLINET_MODEL" = 'Slate' ]; then
	for i in $(seq 1 $vlan_max)
	do
		j=$((${i}+2))
		vlann_name=VLAN${j}_NAME
		vlann_vlan=VLAN${j}_VID
		vlann_vid=VLAN${j}_VID
		vlann_hub_to=VLAN${j}_HUB_TO
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
