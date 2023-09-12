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

# SSID最大数
if [ "$GLINET_MODEL" = 'Slate' ]; then
	wifi_ssid_max=16
fi
if [ "$GLINET_MODEL" = 'Mango' ]; then
	wifi_ssid_max=4
fi
if [ "$GLINET_MODEL" = 'Shadow' ]; then
	wifi_ssid_max=8
fi

# スペース区切りの文字列を分割し、複数行で処理するためのサブルーチン
function printf_multi() {
	array=($2)
	for S in "${array[@]}"; do
		printf "$1\n" $S
	done
}
