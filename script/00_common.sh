# 00.スクリプト生成用初期設定

# 定数

# 機種名（指定がないときはSlateを指定したものとみなす）
if [ -z "$GLINET_MODEL" ]; then
	GLINET_MODEL=Slate
fi

# ファームウェア（指定がないときはStockを指定したものとみなす）
if [ -z "$GLINET_FIRMWARE" ]; then
	GLINET_FIRMWARE=Stock
fi

# 仮想ハブ最大数
hub_max=5

# VLAN最大数
vlan_max=10

# 機種ごと

if [ "$GLINET_MODEL" = 'Mango' ]; then
	# 内部構成
	glinet_has_switch=1
	glinet_switch_name=eth0
	glinet_ethernet_wan_name=eth0.2
	glinet_ethernet_lan1_name=eth0.1
	glinet_interface_admin=eth0.1
	glinet_interface_lan=eth0

	# SSID最大数
	wifi_ssid_max=4

	# 無線周波数帯
	wireless_24g=radio0
fi

if [ "$GLINET_MODEL" = 'Shadow' ]; then
	# 内部構成
	glinet_has_switch=0
	if [ "$GLINET_FIRMWARE" = 'Vanilla' ]; then
		glinet_ethernet_wan_name=eth1
		glinet_ethernet_lan1_name=eth0
	fi
	if [ "$GLINET_FIRMWARE" = 'Stock' ]; then
		glinet_ethernet_wan_name=eth0
		glinet_ethernet_lan1_name=eth1
	fi
	glinet_interface_admin=br-vlantap.1
	glinet_interface_lan=br-vlantap.2

	# SSID最大数
	wifi_ssid_max=8

	# 無線周波数帯
	wireless_24g=radio0
fi

if [ "$GLINET_MODEL" = 'Creta' ]; then
	# 内部構成
	glinet_has_switch=1
	glinet_switch_name=eth0
	glinet_ethernet_wan_name=eth1
	glinet_ethernet_lan1_name=eth0.1
	glinet_ethernet_lan2_name=eth0.1
	glinet_interface_admin=eth0.1
	glinet_interface_lan=eth0

	# SSID最大数
	wifi_ssid_max=16

	# 無線周波数帯
	wireless_24g=radio1
	wireless_5g=radio0
fi

if [ "$GLINET_MODEL" = 'Slate' ]; then
	# 内部構成
	glinet_has_switch=1
	glinet_switch_name=eth0
	glinet_ethernet_wan_name=eth0.2
	glinet_ethernet_lan1_name=eth0.1
	glinet_ethernet_lan2_name=eth0.1
	glinet_interface_admin=eth0.1
	glinet_interface_lan=eth0

	# SSID最大数
	wifi_ssid_max=16

	# 無線周波数帯
	wireless_24g=radio1
	wireless_5g=radio0
fi

if [ "$GLINET_MODEL" = 'Beryl' ]; then
	# 内部構成
	glinet_has_switch=0
	glinet_ethernet_wan_name=wan
	glinet_ethernet_lan1_name=lan2
	glinet_ethernet_lan2_name=lan1
	glinet_interface_admin=br-vlantap.1
	glinet_interface_lan=br-vlantap.2

	# SSID最大数
	wifi_ssid_max=16

	# 無線周波数帯
	wireless_24g=radio0
	wireless_5g=radio1
	wireless_radio0_band=2g
fi

if [ "$GLINET_MODEL" = 'AC1304' ]; then
	# 内部構成
	glinet_has_switch=0
	glinet_ethernet_wan_name=wan
	glinet_ethernet_lan1_name=lan
	glinet_interface_admin=br-vlantap.1
	glinet_interface_lan=br-vlantap.2

	# SSID最大数
	wifi_ssid_max=16

	# 無線周波数帯
	wireless_24g=radio0
	wireless_5g=radio1
	wireless_radio0_band=2g
fi

if [ "$GLINET_MODEL" = 'ERX' ]; then
	# 内部構成
	glinet_has_switch=0
	glinet_ethernet_wan_name=eth0
	glinet_ethernet_lan1_name=eth1
	glinet_ethernet_lan2_name=eth2
	glinet_ethernet_lan3_name=eth3
	glinet_ethernet_lan4_name=eth4
	glinet_interface_admin=br-vlantap.1
	glinet_interface_lan=br-vlantap.2
fi

# スペース区切りの文字列を分割し、複数行で処理するためのサブルーチン
function printf_multi() {
	array=($2)
	for S in "${array[@]}"; do
		printf "$1\n" $S
	done
}
