# 07.インターフェース

echo '# 07.インターフェース'

for i in $(seq 1 $vlan_max)
do
	vlann_name=VLAN${i}_NAME
	vlann_vid=VLAN${i}_VID
	if [ -n "${!vlann_name}" ]; then
		cat <<- EOT
		uci set network.${!vlann_name}=interface
		uci set network.${!vlann_name}.proto='none'
		uci set network.${!vlann_name}.device='br-vlantap.${!vlann_vid}'

		EOT
	fi
done
cat <<- 'EOT'
uci del dhcp.@dnsmasq[0].boguspriv
uci del dhcp.@dnsmasq[0].filterwin2k
uci del dhcp.@dnsmasq[0].nonegcache
uci del dhcp.@dnsmasq[0].nonwildcard

uci add_list dhcp.@dnsmasq[0].notinterface='br-vlantap*'

EOT
