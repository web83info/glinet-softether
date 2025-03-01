# 07.インターフェース

echo '# 07.インターフェース'

for i in $(seq 1 $vlan_max)
do
	vlann_name=VLAN${i}_NAME
	vlann_vid=VLAN${i}_VID
	vlann_proto=VLAN${i}_PROTO
	vlann_ipaddr=VLAN${i}_IPADDR
	vlann_netmask=VLAN${i}_NETMASK
	vlann_gateway=VLAN${i}_GATEWAY
	vlann_dns=VLAN${i}_DNS
	vlann_zone=VLAN${i}_ZONE

	if [ "${!vlann_name}" ]; then

		if [ "${!vlann_proto}" = 'static' ]; then
			cat <<- EOT
			uci set network.${!vlann_name}=interface
			uci set network.${!vlann_name}.proto='${!vlann_proto}'
			uci set network.${!vlann_name}.ipaddr='${!vlann_ipaddr}'
			uci set network.${!vlann_name}.netmask='${!vlann_netmask}'
			uci set network.${!vlann_name}.gateway='${!vlann_gateway}'
			uci set network.${!vlann_name}.device='br-vlantap.${!vlann_vid}'
			uci add_list network.${!vlann_name}.dns='${!vlann_dns}'

			EOT
		else
			cat <<- EOT
			uci set network.${!vlann_name}=interface
			uci set network.${!vlann_name}.proto='none'
			uci set network.${!vlann_name}.device='br-vlantap.${!vlann_vid}'

			EOT
		fi

		if [ -n "${!vlann_zone}" ]; then
			if [ "${!vlann_zone}" = 'lan' ]; then
				cat <<- EOT
				uci add_list firewall.@zone[0].network='${!vlann_name}'

				EOT
			else
				cat <<- EOT
				uci add_list firewall.${!vlann_zone}.network='${!vlann_name}'

				EOT
			fi
		fi
	fi
done
cat <<- 'EOT'
uci del dhcp.@dnsmasq[0].boguspriv
uci del dhcp.@dnsmasq[0].filterwin2k
uci del dhcp.@dnsmasq[0].nonegcache
uci del dhcp.@dnsmasq[0].nonwildcard

uci add_list dhcp.@dnsmasq[0].notinterface='br-vlantap*'

EOT
