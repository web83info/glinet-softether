# 05.ブリッジ

echo '# 05.ブリッジ'

# スイッチあり
if [ "$glinet_has_switch" != 0 ]; then
	cat <<- 'EOT'
	uci add network device
	uci set network.@device[-1].type='bridge'
	uci set network.@device[-1].name='br-vlantap'
	EOT

	for i in $(seq 1 $vlan_max)
	do
		vlann_name=VLAN${i}_NAME
		vlann_vid=VLAN${i}_VID
		if [ -n "${!vlann_name}" ]; then
			cat <<- EOT
			uci add_list network.@device[-1].ports='${glinet_switch_name}.${!vlann_vid}'
			EOT
		fi
	done

	for i in $(seq 1 $hub_max)
	do
		se_hubn_name=SE_HUB${i}_NAME
		if [ -n "${!se_hubn_name}" ]; then
			cat <<- EOT
			uci add_list network.@device[-1].ports='tap_hub${i}'
			EOT
		fi
	done
	echo
fi

# スイッチなし
if [ "$glinet_has_switch" = 0 ]; then
	cat <<- EOT
	uci add network device
	uci set network.@device[-1].type='bridge'
	uci set network.@device[-1].name='br-vlantap'
	EOT

	[ -n "$glinet_ethernet_lan1_name" ] && cat <<- EOT
	uci add_list network.@device[-1].ports='${glinet_ethernet_lan1_name}'
	EOT

	[ -n "$glinet_ethernet_lan2_name" ] && cat <<- EOT
	uci add_list network.@device[-1].ports='${glinet_ethernet_lan2_name}'
	EOT

	for i in $(seq 1 $hub_max)
	do
		se_hubn_name=SE_HUB${i}_NAME
		if [ -n "${!se_hubn_name}" ]; then
			cat <<- EOT
			uci add_list network.@device[-1].ports='tap_hub${i}'
			EOT
		fi
	done
	echo
fi
