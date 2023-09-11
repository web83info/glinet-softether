# 07.インターフェース

echo '# 07.インターフェース'

if [ "$GLINET_MODEL" = 'Slate' ]; then
	for i in $(seq 1 $vlan_max)
	do
		j=$((${i}+2))
		vlann_name=VLAN${j}_NAME
		vlann_vid=VLAN${j}_VID
		if [ -n "${!vlann_name}" ]; then
			cat <<- EOT
			uci set network.${!vlann_name}=interface
			uci set network.${!vlann_name}.proto='none'
			uci set network.${!vlann_name}.device='BR_VLANALL.${!vlann_vid}'

			EOT
		fi
	done
fi

cat <<- 'EOT'
uci del dhcp.@dnsmasq[0].boguspriv
uci del dhcp.@dnsmasq[0].filterwin2k
uci del dhcp.@dnsmasq[0].nonegcache
uci del dhcp.@dnsmasq[0].nonwildcard
uci add_list dhcp.@dnsmasq[0].notinterface='BR_VLAN*'

EOT
