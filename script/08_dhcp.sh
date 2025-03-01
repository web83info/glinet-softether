# 08.DHCP

echo '# 08.DHCP'

for i in $(seq 1 $vlan_max)
do
	vlann_name=VLAN${i}_NAME
	vlann_vid=VLAN${i}_VID
	if [ "${!vlann_name}" ]; then
		cat <<- EOT
		uci set dhcp.${!vlann_name}=dhcp
		uci set dhcp.${!vlann_name}.interface='${!vlann_name}'
		uci set dhcp.${!vlann_name}.ignore='1'
		uci add_list dhcp.${!vlann_name}.ra_flags='none'

		EOT
	fi
done
