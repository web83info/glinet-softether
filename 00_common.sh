# 00.スクリプト生成用初期設定

# 定数

# 機種名（指定がないときはSlateを指定したものとみなす）
if [ -z "$GLINET_MODEL" ]; then
	GLINET_MODEL=Slate
fi

# 仮想ハブ最大数
hub_max=5

# VLAN最大数
vlan_max=10

# 機種ごと
if [ "$GLINET_MODEL" = 'Slate' ]; then
	# 内部構成
	glinet_has_switch=1
	glinet_switch_name=eth0

	# SSID最大数
	wifi_ssid_max=16

	# 無線周波数帯
	wireless_24g=radio1
	wireless_5g=radio0
fi

if [ "$GLINET_MODEL" = 'Mango' ]; then
	# 内部構成
	glinet_has_switch=1
	glinet_switch_name=eth0

	# SSID最大数
	wifi_ssid_max=4

	# 無線周波数帯
	wireless_24g=radio0
fi

if [ "$GLINET_MODEL" = 'Shadow' ]; then
	# 内部構成
	glinet_has_switch=0

	# SSID最大数
	wifi_ssid_max=8

	# 無線周波数帯
	wireless_24g=radio0
fi

# スペース区切りの文字列を分割し、複数行で処理するためのサブルーチン
function printf_multi() {
	array=($2)
	for S in "${array[@]}"; do
		printf "$1\n" $S
	done
}
